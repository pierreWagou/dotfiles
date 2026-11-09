-- Seafile exposes no CLI or aliasable status item on this OS;
-- this pill just summons the app.
local seafile = sbar.add("item", {
  position = "right",
  icon = { drawing = false },
  label = { string = "Seafile", color = 0xff9399b2 },
})

seafile:subscribe("mouse.clicked", function()
  sbar.exec("open -a 'Seafile Client'")
end)
