local warp = sbar.add("item", {
  position = "right",
  icon = { string = "\239\131\130" },
  label = { drawing = false },
  update_freq = 30,
})

local connected = false

local function warp_update()
  sbar.exec("/usr/local/bin/warp-cli status", function(out)
    if out:find("Disconnected") or out:find("Connecting") then
      connected = false
    elseif out:find("Connected") then
      connected = true
    end
    warp:set({ icon = { color = connected and 0xffcdd6f4 or 0x559399b2 } })
  end)
end

warp:subscribe("routine", warp_update)
warp_update()

warp:subscribe("mouse.clicked", function()
  sbar.exec("/usr/local/bin/warp-cli " .. (connected and "disconnect" or "connect"), function()
    sbar.delay(3, warp_update)
  end)
end)
