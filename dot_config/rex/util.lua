-- Shared constants and helpers for the Rex config. No dependencies.
local M = {}

M.HOME = os.getenv("HOME")
M.SHELL_FLAVOR = "com.superlogical.terminal.shell"

-- The agent command typed into the agent pane (like tmux send-keys would).
-- Plain `opencode`, run in the pane's directory.
M.AGENT_CMD = "opencode"

function M.file_exists(path)
  local f = io.open(path, "r")
  if f == nil then return false end
  f:close()
  return true
end

function M.read_file(path)
  local f = io.open(path, "r")
  if f == nil then return nil end
  local s = f:read("*a")
  f:close()
  return s
end

function M.basename(path)
  return path:match("([^/]+)/?$")
end

function M.expand_home(path)
  if path:sub(1, 1) == "~" then return (os.getenv("HOME") or "") .. path:sub(2) end
  return path
end

-- Abbreviate $HOME as ~ for display (sesh shows ~/paths for zoxide rows).
function M.abbr_home(path)
  local home = M.HOME
  if home ~= nil and home ~= "" then
    local pat = "^" .. home:gsub("([^%w])", "%%%1")
    path = path:gsub(pat, "~", 1)
  end
  return path
end

function M.is_dir(path)
  local r, err = rex.exec({ "/bin/test", "-d", path })
  if r == nil then error(err, 0) end
  return r.ok
end

-- The server runs with a minimal PATH, so bare tool names may not resolve
-- there (unlike in `rex do -e` scripts, which exec locally). Probe absolute
-- locations once and cache the winner.
local eza_bin = nil
function M.find_eza()
  if eza_bin ~= nil then return eza_bin end
  local cands = {
    "/run/current-system/sw/bin/eza",
    (os.getenv("HOME") or "") .. "/.nix-profile/bin/eza",
    "/opt/homebrew/bin/eza",
    "/usr/local/bin/eza",
    "eza",
  }
  eza_bin = false
  for _, c in ipairs(cands) do
    local r = rex.exec({ c, "--version" })
    if r ~= nil and r.ok then
      eza_bin = c
      break
    end
  end
  return eza_bin
end

local zoxide_bin = nil
function M.find_zoxide()
  if zoxide_bin ~= nil then return zoxide_bin end
  local cands = {
    "/run/current-system/sw/bin/zoxide",
    (os.getenv("HOME") or "") .. "/.nix-profile/bin/zoxide",
    "/opt/homebrew/bin/zoxide",
    "/usr/local/bin/zoxide",
    "zoxide",
  }
  zoxide_bin = false
  for _, c in ipairs(cands) do
    local r = rex.exec({ c, "--version" })
    if r ~= nil and r.ok then
      zoxide_bin = c
      break
    end
  end
  return zoxide_bin
end

function M.session_exists(name)
  local list, err = rex.call("session.list")
  if list == nil then error(err, 0) end
  for _, s in ipairs(list.sessions) do
    if s.label == name then return true end
  end
  return false
end

function M.find_session_id(label)
  local list, err = rex.call("session.list")
  if list == nil then error(err, 0) end
  for _, s in ipairs(list.sessions or {}) do
    if s.label == label then return s.session_id end
  end
  return nil
end

function M.app_client_ids()
  local list, err = rex.call("client.list", { kinds = { "app" } })
  if list == nil then error(err, 0) end
  local ids = {}
  for _, c in ipairs(list.clients or {}) do
    ids[#ids + 1] = c.client_id
  end
  return ids
end

-- Switch every connected app to the given session label.
-- Needs "Remote Control" enabled in Rex Settings under Rex Server.
function M.select_session(label)
  local sid = M.find_session_id(label)
  if sid == nil then error("cockpit: no such session: " .. label, 0) end
  local ids = M.app_client_ids()
  if #ids == 0 then error("cockpit: no Rex app connected", 0) end
  for _, cid in ipairs(ids) do
    local _, err = rex.call("client.perform", {
      client_id = cid,
      action = "session.select",
      args = { session_id = sid },
    })
    if err ~= nil then
      error("cockpit: switching needs Remote Control enabled in Rex Settings > Rex Server", 0)
    end
  end
  return { session_id = sid }
end

function M.preview_session(label)
  local sid = M.find_session_id(label)
  if sid == nil then
    return "no such session: " .. label
  end
  local _, aerr = rex.call("session.attach", { session_id = sid })
  local view, verr
  if aerr == nil then view, verr = rex.call("session.view", { session_id = sid }) end
  rex.call("session.detach", { session_id = sid })
  if view == nil then
    return label .. "\n(unavailable: " .. tostring(verr or aerr) .. ")"
  end
  local lines = { label }
  for _, w in ipairs(view.windows or {}) do
    local marker = (w.window_id == view.active_window_id) and "*" or " "
    lines[#lines + 1] = marker .. " " .. (w.label or w.window_id)
  end
  return table.concat(lines, "\n")
end

function M.preview_dir(path)
  path = M.expand_home(path)
  if not M.is_dir(path) then
    return "no such directory: " .. path
  end
  local eza = M.find_eza()
  local r = nil
  if eza then
    r = rex.exec({ eza, "--all", "--git", "--icons", "--color=always", path })
  end
  if r == nil or not r.ok then
    r = rex.exec({ "/bin/ls", "-la", path })
  end
  if r ~= nil and r.stdout ~= nil and r.stdout ~= "" then
    return r.stdout
  end
  return "empty: " .. path
end

function M.block_cwd(block_id)
  local args = {}
  if block_id ~= nil then args.block_id = block_id end
  local r, _ = rex.block.call("com.superlogical.terminal", "process", args)
  if type(r) == "table" and type(r.foreground) == "table" then
    return r.foreground.cwd
  end
  return nil
end

-- Pickers open in a centered floating popup over the current window.
-- Closing the picker's block (the scripts do this on selection) dismisses it.
function M.picker_window(cmd, cwd)
  local opts = { command = cmd }
  if cwd ~= nil then opts.cwd = cwd end
  local l, err = rex.session.new_layer{
    bounds = { x = 0.15, y = 0.2, w = 0.7, h = 0.6 },
    focus = true,
    layout = rex.layout.block{
      flavor = "com.superlogical.terminal.shell",
      options = opts,
    },
  }
  if err ~= nil then error(err, 0) end
  return l
end

-- Project name to workspace profile (mirrors the tmuxinator profile names).
function M.profile_for_name(name)
  if name == "alan" then return "alan" end
  if name == "atelier-limoun" then return "atelier-limoun" end
  return "workspace"
end

return M
