-- Project workspace builder: native Rex equivalents of the tmuxinator
-- workspace layouts. Depends on util.
local util = require("util")

local M = {}

-- One shell block. Commands are typed into an interactive shell, exactly
-- like tmuxinator send-keys, so quitting nvim/mprocs/ssh drops back to a
-- prompt instead of closing the pane.
local function shell_block(cwd, input)
  local options = { cwd = cwd }
  if input ~= nil then options.initial_input = input .. "\n" end
  return rex.layout.block{ flavor = util.SHELL_FLAVOR, options = options }
end

-- The standard 3-pane workspace (mirrors tmuxinator workspace.yml:
-- split -h 40%, split -v 25% on the left; agent command on the right,
-- plain terminal bottom-left).
local function workspace_layout(cwd, agent_cmd)
  return rex.layout.horizontal(0.6,
    rex.layout.vertical(0.75,
      shell_block(cwd, "nvim"),
      shell_block(cwd)),
    shell_block(cwd, agent_cmd))
end

-- Restricted-subset parser for per-project .tmuxinator.yml overrides
-- (mirrors workspace.yml's ERB override): top-level `- name:` windows and
-- their pane commands. tmux plumbing lines are skipped. Returns
-- { agent = cmd|nil, extra = { { label, input } } }.
local function parse_override(text)
  local agent = text:match("send%-keys%s+%S+%s+'([^']+)'")
  local panes = {}
  local order = {}
  local current = nil
  for line in text:gmatch("[^\r\n]+") do
    local name = line:match("^  %- ([%w_%.%-]+):%s*$")
    if name ~= nil then
      current = name
      if panes[current] == nil then
        panes[current] = {}
        order[#order + 1] = current
      end
    else
      local cmd = line:match("^%s+%- (.-)%s*$")
      if cmd ~= nil and current ~= nil
          and not cmd:match(":$")
          and not cmd:match("^tmux%s") then
        table.insert(panes[current], cmd)
      end
    end
  end
  local extra = {}
  for _, name in ipairs(order) do
    if name ~= "workspace" and #panes[name] > 0 then
      extra[#extra + 1] = { label = name, input = table.concat(panes[name], "\n") }
    end
  end
  return { agent = agent, extra = extra }
end

local function window_has(windows, label)
  for _, w in ipairs(windows) do
    if w.window_label == label then return true end
  end
  return false
end

-- Build a project workspace as a native Rex session. Mirrors the tmuxinator
-- profiles 1:1, minus tmux-only bits: the alan-apps ~/.alan/bin/tmux
-- symlink hack and `clear` are dropped. All profiles run plain opencode.
function M.build_workspace(path, name, profile)
  if not util.is_dir(path) then
    error("workspace: no such directory: " .. path, 0)
  end
  local windows = {}
  local function add(label, layout)
    windows[#windows + 1] = { window_label = label, layout = layout }
  end

  if profile == "workspace" then
    local agent = util.AGENT_CMD
    local extra = {}
    local override = util.read_file(path .. "/.tmuxinator.yml")
    if override ~= nil then
      local parsed = parse_override(override)
      if parsed.agent ~= nil then agent = parsed.agent end
      extra = parsed.extra
    end
    add("workspace", workspace_layout(path, agent))
    for _, e in ipairs(extra) do
      add(e.label, shell_block(path, e.input))
    end
    if util.file_exists(path .. "/mprocs.yaml") and not window_has(windows, "services") then
      add("services", shell_block(path, "mprocs"))
    end
  elseif profile == "alan" then
    add("workspace", rex.layout.horizontal(0.5,
      shell_block(path, util.AGENT_CMD),
      shell_block(path, util.AGENT_CMD)))
  elseif profile == "atelier-limoun" then
    add("workspace", workspace_layout(path, util.AGENT_CMD))
    add("services", shell_block(path, "mprocs"))
    add("vps", shell_block(path, "ssh atelier-limoun"))
  elseif profile == "wagounix" then
    add("workspace", workspace_layout(path, util.AGENT_CMD))
    add("wagou-prime", shell_block(path, "ssh wagou-prime"))
  elseif profile == "alan-apps" then
    add("workspace", workspace_layout(path, util.AGENT_CMD))
    add("services", shell_block(path, "mise run mprocs"))
  else
    error("workspace: unknown profile '" .. profile .. "'", 0)
  end

  if util.session_exists(name) then
    error("workspace: session '" .. name .. "' already exists (switch with cmd+k)", 0)
  end

  -- First window goes in session.create (it takes focus, like tmuxinator's
  -- opened window); the rest are appended unfocused to preserve tab order.
  -- Per-session calls need an attachment to the new session first.
  local first = table.remove(windows, 1)
  local created, err = rex.call("session.create", {
    label = name,
    initial_windows = { first },
  })
  if created == nil then error(err, 0) end
  local sid = created.session_id
  local function fail(msg)
    rex.call("session.destroy", { session_id = sid })
    error(msg, 0)
  end
  local _, aerr = rex.call("session.attach", { session_id = sid })
  if aerr ~= nil then fail(aerr) end
  for _, w in ipairs(windows) do
    local _, werr = rex.session.new_window{
      session_id = sid,
      window_label = w.window_label,
      layout = w.layout,
      focus = false,
    }
    if werr ~= nil then fail(werr) end
  end
  rex.call("session.detach", { session_id = sid })
  return { session_id = sid }
end

rex.action{
  name = "workspace",
  title = "Open Workspace for Project",
  description = "Build the tmuxinator-equivalent workspace layout as a native Rex session.",
  category = "Rex",
  keywords = "workspace layout project session tmuxinator",
  args = { path = "string", name = "string?", profile = "string?" },
  run = function(ctx, args)
    return M.build_workspace(args.path, args.name or util.basename(args.path), args.profile or "workspace")
  end,
}

rex.action{
  name = "workspace_here",
  title = "Open Workspace for This Directory",
  description = "Build the workspace layout in a new Rex session for the focused pane's directory.",
  category = "Rex",
  keywords = "workspace layout project session",
  run = function(ctx, args)
    local cwd = util.block_cwd(ctx.block_id) or util.HOME
    return rex.invoke("workspace", { path = cwd })
  end,
}

return M
