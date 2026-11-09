-- Worktree picker backend: what rex-wt did, as a Lua action.
-- Resolves the workspace profile from the worktree's repo and builds it.
-- Unknown repos fall back to the default workspace profile.
-- Depends on util and workspace.
local util = require("util")
local workspace = require("workspace")

local known_profiles = {
  workspace = true,
  alan = true,
  ["atelier-limoun"] = true,
  wagounix = true,
  ["alan-apps"] = true,
}

local function profile_for_repo(path)
  local r = rex.exec({ "git", "-C", path, "rev-parse", "--show-toplevel" })
  if r == nil or not r.ok or r.stdout == nil then return "workspace" end
  local root = r.stdout:gsub("%s+$", "")
  if root == "" then return "workspace" end
  local repo = util.basename(root) or ""
  if known_profiles[repo] and util.file_exists(util.HOME .. "/.config/tmuxinator/" .. repo .. ".yml") then
    return repo
  end
  return "workspace"
end

rex.action{
  name = "worktree_open",
  title = "Open Worktree Workspace",
  description = "Build the workspace layout for a worktree path (wt switch -x backend).",
  category = "Rex",
  keywords = "worktree branch wt workspace",
  args = { path = "string" },
  run = function(ctx, args)
    local path = util.expand_home(args.path or "")
    if not util.is_dir(path) then error("worktree: no such directory: " .. path, 0) end
    local name = util.basename(path) or path
    if util.find_session_id(name) == nil then
      workspace.build_workspace(path, name, profile_for_repo(path))
    end
    return util.select_session(name)
  end,
}

rex.action{
  name = "worktree_picker",
  title = "Pick Worktree in New Session",
  description = "Pick a git worktree with tv and open it in a new Rex session with the workspace layout.",
  category = "Rex",
  keywords = "worktree branch wt worktrunk",
  run = function(ctx, args)
    util.picker_window({ "tv", "rex-worktrees" }, util.block_cwd(ctx.block_id))
  end,
}
