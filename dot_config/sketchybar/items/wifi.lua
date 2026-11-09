local popup = require("items.popup")
local colors = require("colors")

local wifi = sbar.add("item", {
  position = "right",
  icon = { string = "\239\135\171", color = 0xffcdd6f4 },
  label = { drawing = false },
  update_freq = 30,
  popup = { align = "right", height = 26 },
})

popup.header(wifi.name, "wi-fi")
local power = "On"
local wifi_update
local ssid_row = popup.row(wifi.name, { label = "…" })
local toggle_row = popup.row(wifi.name, {
  icon = popup.toggle_on,
  icon_color = colors.green,
  label = "Wi-Fi",
  click = function()
    sbar.exec("networksetup -setairportpower en0 " .. (power == "On" and "off" or "on"), function()
      sbar.delay(1, wifi_update)
    end)
  end,
})
popup.row(wifi.name, {
  icon = popup.chevron,
  icon_color = colors.grey,
  label = "Wi-Fi Settings",
  click = function()
    sbar.exec("open 'x-apple.systempreferences:com.apple.Wi-Fi-Settings.extension' || open -a 'System Settings'")
  end,
})

wifi_update = function()
  sbar.exec("ipconfig getsummary en0 | awk '/^ *SSID :/ {print $NF}'; networksetup -getairportpower en0; ipconfig getifaddr en0", function(out)
    power = out:match("Wi%-Fi Power %(en0%): (%a+)") or power
    local rest = out:gsub("Wi%-Fi Power %(en0%): %a+\n?", ""):gsub("%d+%.%d+%.%d+%.%d+\n?", ""):gsub("%s+", "")
    local ssid = (rest ~= "" and rest) or (power == "On" and "no network" or "off")
    local ip = out:match("(%d+%.%d+%.%d+%.%d+)") or "--"
    wifi:set({ label = ssid })
    ssid_row:set({ label = ssid .. "  ·  " .. ip })
    toggle_row:set({
      icon = {
        string = (power == "On" and popup.toggle_on or popup.toggle_off),
        color = (power == "On" and colors.green or colors.grey),
      },
    })
  end)
end

wifi:subscribe({ "routine", "wifi_change" }, wifi_update)

wifi:subscribe("mouse.clicked", function()
  wifi_update()
  wifi:set({ popup = { drawing = "toggle" } })
end)

wifi:subscribe("mouse.exited.global", function()
  wifi:set({ popup = { drawing = false } })
end)
