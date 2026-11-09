local colors = require("colors")

-- Transparent floating pills (à la neutonfoo). No center items: notch.
sbar.bar({
  height = 32,
  color = 0x00000000,
  sticky = true,
  padding_right = 23,
  padding_left = 23,
  y_offset = 24,
  notch_width = 188,
  topmost = "window",
})
