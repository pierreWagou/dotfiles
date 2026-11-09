local colors = require("colors")

-- Native spaces, indicator only (no WM for click-to-focus).
-- Floating pills; the selected one gets the blue border.
local function space_selection(env)
  local selected = env.SELECTED == "true"
  sbar.set(env.NAME, {
    icon = { highlight = selected },
    label = { highlight = selected },
    background = { border_color = selected and colors.blue or colors.bg2 },
  })
end

for i = 1, 5, 1 do
  local space = sbar.add("space", {
    associated_space = i,
    icon = {
      string = i,
      padding_left = 10,
      padding_right = 10,
      color = colors.white,
      highlight_color = colors.blue,
    },
    padding_left = 2,
    padding_right = 2,
    label = { drawing = false },
  })

  space:subscribe("space_change", space_selection)
end
