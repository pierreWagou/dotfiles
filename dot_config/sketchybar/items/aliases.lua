-- Native menu-bar mirrors (alias component). Requires Screen Recording
-- permission; only items listed by `sketchybar --query default_menu_items`
-- can be mirrored. Clicks pass through to the native dropdowns.
local aliases = {
  "Vorssaint,(3)",
  "Vorssaint,(4)",
  "Aerial,(2)",
  "LinkedNotesUIService,Window(1)",
}

for _, app in ipairs(aliases) do
  sbar.add("alias", app, {
    position = "right",
    alias = { scale = 1.0, update_freq = 1 },
  })
end
