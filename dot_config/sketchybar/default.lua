local settings = require("settings")
local colors = require("colors")

-- Pill defaults: translucent surface, small radius.
sbar.default({
  updates = "when_shown",
  background = {
    color = 0x6645475a,
    corner_radius = 5,
    height = 26,
    padding_right = 5,
  },
  icon = {
    font = {
      family = settings.font,
      style = "Medium",
      size = 15.0
    },
    color = colors.white,
    padding_left = 5,
    padding_right = 5,
  },
  label = {
    font = {
      family = settings.font,
      style = "Medium",
      size = 12.0
    },
    color = colors.white,
    padding_left = 0,
    padding_right = 5,
  },
  popup = {
    background = {
      border_width = 1,
      corner_radius = 12,
      border_color = colors.bg2,
      color = 0xe61e1e2e,
      shadow = { drawing = true },
    },
    blur_radius = 40,
  },
  padding_left = 5,
  padding_right = 5
})
