-- Shared popup row language: borderless rows, grey section headers,
-- hover tint on clickable rows. Parents pass popup = { align = "right" }.
local colors = require("colors")

local M = {}

function M.header(parent, text)
  return sbar.add("item", {
    position = "popup." .. parent,
    icon = { drawing = false },
    label = { string = text:upper(), color = colors.grey, font = { size = 10.0 } },
    background = { drawing = false },
  })
end

function M.row(parent, opts)
  local item = sbar.add("item", {
    position = "popup." .. parent,
    icon = opts.icon ~= nil and { string = opts.icon, color = opts.icon_color or colors.white } or { drawing = false },
    label = { string = opts.label, color = opts.label_color or colors.white },
    background = { drawing = false },
  })
  if opts.click ~= nil then
    item:subscribe("mouse.clicked", opts.click)
    item:subscribe("mouse.entered", function()
      item:set({ background = { drawing = true, color = colors.bg1, height = 22, corner_radius = 5 } })
    end)
    item:subscribe("mouse.exited", function()
      item:set({ background = { drawing = false } })
    end)
  end
  return item
end

M.toggle_on = "\239\136\133"
M.toggle_off = "\239\136\132"
M.chevron = "\239\129\148"

return M
