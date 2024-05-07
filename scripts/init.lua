-- entry point for all lua code of the pack
-- more info on the lua API: https://github.com/black-sliver/PopTracker/blob/master/doc/PACKS.md#lua-interface
ENABLE_DEBUG_LOG = true
-- get current variant
local variant = Tracker.ActiveVariantUID
-- check variant info

print("-- Example Tracker --")
print("Loaded variant: ", variant)
if ENABLE_DEBUG_LOG then
    print("Debug logging is enabled!")
end

-- Utility Script for helper functions etc.
ScriptHost:LoadScript("scripts/utils.lua")

-- Logic
ScriptHost:LoadScript("scripts/logic/logic.lua")

-- Items
Tracker:AddItems("items/items.json")

-- Maps
Tracker:AddMaps("maps/maps.json")

-- Locations
Tracker:AddLocations("locations/general_logic.json")
Tracker:AddLocations("locations/spaceship.json")
Tracker:AddLocations("locations/mafiatown.json")
Tracker:AddLocations("locations/deadbirdstudio.json")
Tracker:AddLocations("locations/basement.json")
Tracker:AddLocations("locations/subcon.json")
Tracker:AddLocations("locations/alpineskyline.json")
Tracker:AddLocations("locations/cruise.json")
Tracker:AddLocations("locations/nyakuza.json")
Tracker:AddLocations("locations/entrances/chapter1.json")
Tracker:AddLocations("locations/entrances/chapter2.json")
Tracker:AddLocations("locations/entrances/chapter3.json")
Tracker:AddLocations("locations/entrances/chapter4.json")
Tracker:AddLocations("locations/entrances/chapter5.json")
Tracker:AddLocations("locations/entrances/chapter6.json")
Tracker:AddLocations("locations/entrances/spaceship_lab.json")
Tracker:AddLocations("locations/entrances/chapter7.json")
Tracker:AddLocations("locations/entrances/chapter_time_rifts.json")
Tracker:AddLocations("locations/entrances/spaceship_attic.json")
Tracker:AddLocations("locations/entrances/spaceship_gallery.json")

-- Layout
Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")

-- AutoTracking for Poptracker
if PopVersion and PopVersion >= "0.18.0" then
    ScriptHost:LoadScript("scripts/archipelago.lua")
end