local popup = require("items.popup")

local cal = sbar.add("item", {
  icon = {
    string = "\243\176\131\176",
    color = 0xfff38ba8,
  },
  position = "right",
  update_freq = 10,
  popup = { align = "right", height = 26 },
})

popup.header(cal.name, os.date("%B %Y"))
local grid = popup.row(cal.name, { label = "" })
popup.row(cal.name, {
  icon = popup.chevron,
  icon_color = 0xff9399b2,
  label = "Open Calendar",
  click = function()
    sbar.exec("open -a Calendar")
  end,
})

local function update()
  cal:set({ label = os.date("%a %b %e %H:%M") })
end

cal:subscribe("routine", update)
cal:subscribe("forced", update)

local function grid_update()
  sbar.exec("cal", function(out)
    local day = tonumber(os.date("%e"))
    out = out:gsub(" " .. day .. " ", "[" .. day .. "]", 1)
    grid:set({ label = out })
  end)
end

cal:subscribe("mouse.clicked", function()
  grid_update()
  cal:set({ popup = { drawing = "toggle" } })
end)

cal:subscribe("mouse.exited.global", function()
  cal:set({ popup = { drawing = false } })
end)
