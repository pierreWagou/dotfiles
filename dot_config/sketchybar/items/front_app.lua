-- Front app as green pill + powerline separator + name (à la neutonfoo).
local apps = {
  ["Arc"] = { icon = "\243\176\158\141", pad = 5 },
  ["Code"] = { icon = "\243\176\168\158", pad = 4 },
  ["Calendar"] = { icon = "\238\188\183", pad = 3 },
  ["Discord"] = { icon = "\239\135\191", pad = 5 },
  ["FaceTime"] = { icon = "\239\130\149", pad = 5 },
  ["Finder"] = { icon = "\243\176\128\182", pad = 5 },
  ["Google Chrome"] = { icon = "\239\137\168", pad = 7 },
  ["IINA"] = { icon = "\243\176\149\188", pad = 4 },
  ["kitty"] = { icon = "\243\176\132\155", pad = 5 },
  ["Messages"] = { icon = "\239\137\186", pad = 5 },
  ["Notion"] = { icon = "\243\176\142\154", pad = 6 },
  ["Preview"] = { icon = "\239\130\131", pad = 3 },
  ["PS Remote Play"] = { icon = "\238\136\176", pad = 3 },
  ["Spotify"] = { icon = "\239\134\188", pad = 2 },
  ["TextEdit"] = { icon = "\239\133\156", pad = 4 },
  ["Transmission"] = { icon = "\243\176\182\152", pad = 3 },
}
local fallback = { icon = "\239\145\143", pad = 2 }

local app_icon = sbar.add("item", {
  icon = { y_offset = 1, color = 0xff11111b },
  label = { drawing = false },
  background = { color = 0xffa6e3a1, padding_left = 0, padding_right = 0 },
})

local app_sep = sbar.add("item", {
  icon = {
    string = "\238\130\176",
    color = 0xffa6e3a1,
    font = { style = "Bold", size = 20.0 },
    padding_left = 0,
    padding_right = 0,
    y_offset = 1,
  },
  label = { drawing = false },
  background = { color = 0x00000000, padding_left = -3 },
})

local app_name = sbar.add("item", {
  icon = { drawing = false },
  label = { font = { style = "Bold", size = 12.0 }, padding_right = 0 },
  background = { color = 0x00000000, padding_right = 0 },
})

app_icon:subscribe("front_app_switched", function(env)
  local app = apps[env.INFO] or fallback
  app_icon:set({ icon = { string = app.icon, padding_right = app.pad } })
  app_name:set({ label = env.INFO })
end)
