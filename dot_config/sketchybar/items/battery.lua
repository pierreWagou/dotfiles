local popup = require("items.popup")
local colors = require("colors")

local icons = {
  high = "\239\137\128",
  med_high = "\239\137\129",
  med = "\239\137\130",
  med_low = "\239\137\131",
  low = "\239\137\132",
  charging = "\239\131\167",
}

local battery = sbar.add("item", {
  position = "right",
  icon = { font = { style = "Regular", size = 19.0 } },
  label = { drawing = false },
  update_freq = 120,
  popup = { align = "right", height = 26 },
})

popup.header(battery.name, "power")
local status_row = popup.row(battery.name, { label = "…" })
local time_row = popup.row(battery.name, { label = "", label_color = colors.grey })
local health_row = popup.row(battery.name, { label = "Cycle count: …", label_color = colors.grey })
popup.row(battery.name, {
  icon = popup.chevron,
  icon_color = colors.grey,
  label = "Battery Settings",
  click = function()
    sbar.exec("open 'x-apple.systempreferences:com.apple.Battery-Settings.extension' || open -a 'System Settings'")
  end,
})

function battery_update()
  sbar.exec("pmset -g batt", function(info)
    local icon, color = nil, nil
    if info:find("AC Power") then
      icon, color = icons.charging, 0xfff9e2af
    else
      local charge = tonumber(info:match("(%d+)%%"))
      if charge ~= nil then
        if charge >= 80 then icon, color = icons.high, 0xffa6e3a1
        elseif charge >= 70 then icon, color = icons.med_high, 0xfff9e2af
        elseif charge >= 40 then icon, color = icons.med, 0xfffab387
        elseif charge >= 10 then icon, color = icons.med_low, 0xfff5c2e7
        else icon, color = icons.low, 0xfff38ba8 end
      end
    end
    if icon ~= nil then
      local pct = info:match("(%d+)%%") or ""
      battery:set({ icon = { string = icon, color = color }, label = pct .. "%" })
      local on_ac = info:find("AC Power") ~= nil
      status_row:set({
        icon = { string = icon, color = color },
        label = (on_ac and "AC Power" or "On Battery") .. " · " .. pct .. "%",
      })
      local remain = info:match("(%d+:%d+) remaining") or info:match("(%d+:%d+) until full")
      time_row:set({ label = remain and (remain .. (info:find("until full") and " until full" or " remaining")) or "—" })
    end
  end)
end

local function health_update()
  sbar.exec("system_profiler SPPowerDataType | awk -F': ' '/Cycle Count|Condition/ {print $2}'", function(out)
    local cycles, condition = out:match("(%d+)%s*\n?%s*([^\n]*)")
    if cycles ~= nil then
      health_row:set({ label = "Cycle count: " .. cycles .. (condition ~= "" and " · " .. condition or "") })
    end
  end)
end

battery:subscribe({ "routine", "power_source_change", "system_woke" }, battery_update)

battery:subscribe("mouse.clicked", function()
  battery_update()
  health_update()
  battery:set({ popup = { drawing = "toggle" } })
end)

battery:subscribe("mouse.exited.global", function()
  battery:set({ popup = { drawing = false } })
end)
