-- Session picker backend for the tv rex-sessions channel.
-- All picker logic lives here as real config: tv only displays entries and
-- forwards the selected kind/name/path triple via `rex do cockpit_open`
-- (enter) or `rex do cockpit_preview` (preview).
-- Depends on util and workspace.
local util = require("util")
local workspace = require("workspace")

-- Row format for the tv rex-sessions channel:
-- ICON \t kind \t name \t path \t display. Rows are generated here
-- (not in shell pipelines) so the cable holds only
-- `rex do sessions_list` one-liners. Icons match `sesh list --icons`
-- per source (active: blue U+EB88, configs: grey U+E615, zoxide: cyan
-- U+F194); display is the sesh-like text (name, or ~/path for zoxide).
local ICON_ACTIVE = string.char(27) .. "[34m" .. "" .. string.char(27) .. "[39m"
local ICON_CONFIG = string.char(27) .. "[90m" .. "" .. string.char(27) .. "[39m"
local ICON_ZOXIDE = string.char(27) .. "[36m" .. "" .. string.char(27) .. "[39m"

local function list_active()
  local list, err = rex.call("session.list")
  if list == nil then error(err, 0) end
  local rows = {}
  for _, s in ipairs(list.sessions or {}) do
    rows[#rows + 1] = ICON_ACTIVE .. "\tactive\t" .. s.label .. "\t" .. s.label .. "\t" .. s.label
  end
  return rows
end

-- Favorites are plain data parsed from sesh.toml (no sesh binary):
-- [[session]] blocks with name = "..." / path = "..." lines.
local function list_favorites()
  local text = util.read_file(util.HOME .. "/.config/sesh/sesh.toml")
  if text == nil then return {} end
  local rows = {}
  local name = nil
  for line in text:gmatch("[^\r\n]+") do
    if line:match("^%[%[session%]%]$") then
      name = nil
    else
      local n = line:match("^name%s*=%s*\"([^\"]+)\"%s*$")
      if n ~= nil then
        name = n
      else
        local p = line:match("^path%s*=%s*\"([^\"]+)\"%s*$")
        if p ~= nil and name ~= nil then
          local dir = util.expand_home(p)
          rows[#rows + 1] = ICON_CONFIG .. "\tconfig\t" .. name .. "\t" .. dir .. "\t" .. name
        end
      end
    end
  end
  return rows
end

local function list_zoxide()
  local zoxide = util.find_zoxide()
  if not zoxide then error("sessions: zoxide not found (tried nix/homebrew/PATH)", 0) end
  local r, err = rex.exec({ zoxide, "query", "-l" })
  if r == nil then error(err, 0) end
  if not r.ok then error("sessions: zoxide query failed", 0) end
  local rows = {}
  for line in (r.stdout or ""):gmatch("[^\r\n]+") do
    rows[#rows + 1] = ICON_ZOXIDE .. "\tzoxide\t" .. (util.basename(line) or line) .. "\t" .. line .. "\t" .. util.abbr_home(line)
  end
  return rows
end

rex.action{
  name = "sessions_list",
  title = "List Rex Session Picker Rows",
  description = "Emit tv rex-sessions rows (icon, kind, name, path) for one source.",
  category = "Rex",
  keywords = "session list picker cockpit",
  args = { source = "string" },
  run = function(ctx, args)
    local source = args.source or ""
    local rows
    if source == "active" then
      rows = list_active()
    elseif source == "favorites" then
      rows = list_favorites()
    elseif source == "zoxide" then
      rows = list_zoxide()
    else
      error("sessions: unknown source '" .. source .. "'", 0)
    end
    return table.concat(rows, "\n")
  end,
}

rex.action{
  name = "sessions_kill",
  title = "Kill Picked Rex Session",
  description = "Destroy a live Rex session picked in tv rex-sessions (Active source only; other kinds are a silent no-op).",
  category = "Rex",
  keywords = "session kill destroy cockpit",
  args = { kind = "string", name = "string" },
  run = function(ctx, args)
    if (args.kind or "") ~= "active" then return {} end
    local name = args.name or ""
    local sid = util.find_session_id(name)
    if sid == nil then error("sessions: no such session: " .. name, 0) end
    -- session.destroy needs our connection attached to the target first.
    local _, aerr = rex.call("session.attach", { session_id = sid })
    if aerr ~= nil then error(aerr, 0) end
    local _, err = rex.call("session.destroy", { session_id = sid })
    if err ~= nil then error(err, 0) end
    return { session_id = sid }
  end,
}

rex.action{
  name = "cockpit_preview",
  title = "Preview Picked Session",
  description = "Preview text for a tv rex-sessions entry.",
  category = "Rex",
  keywords = "session preview cockpit",
  args = { kind = "string", name = "string", path = "string" },
  run = function(ctx, args)
    local kind = args.kind or ""
    local name = args.name or ""
    local path = args.path or ""
    if kind == "active" then
      return util.preview_session(name)
    elseif kind == "config" or kind == "zoxide" then
      return util.preview_dir(path ~= "" and path or name)
    else
      return "unknown entry: " .. kind .. " " .. name
    end
  end,
}

rex.action{
  name = "cockpit_open",
  title = "Open Picked Session",
  description = "Switch to a live Rex session or build the workspace for a favorite / zoxide dir (tv rex-sessions backend).",
  category = "Rex",
  keywords = "session sesh workspace cockpit",
  args = { kind = "string", name = "string", path = "string", picker_block = "string" },
  run = function(ctx, args)
    local kind = args.kind or ""
    local name = args.name or ""
    local path = args.path or ""
    local picker = args.picker_block or ""
    if picker == "" then error("cockpit: picker_block is required", 0) end
    if kind == "active" then
      util.select_session(name)
    elseif kind == "config" or kind == "zoxide" then
      local dir = util.expand_home(path ~= "" and path or name)
      if util.find_session_id(name) == nil then
        workspace.build_workspace(dir, name, util.profile_for_name(name))
      end
      util.select_session(name)
    else
      error("cockpit: unknown entry kind '" .. kind .. "'", 0)
    end
    rex.call("block.close", { block_id = picker })
  end,
}

rex.action{
  name = "cockpit",
  title = "Pick Project in New Session",
  description = "Pick a session with tv (live Rex sessions, favorites, zoxide) and switch to it or open it with the workspace layout.",
  category = "Rex",
  keywords = "project session sesh workspace cockpit",
  run = function(ctx, args)
    util.picker_window({ "tv", "rex-sessions" })
  end,
}
