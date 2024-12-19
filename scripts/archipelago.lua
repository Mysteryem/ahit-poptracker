require("objects/chapter_info")

ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

CUR_INDEX = -1
--SLOT_DATA = nil

-- Setup for auto map switching
local map_table = {
    hub_spaceship = "default",
    timerift_water_spaceship_mail = "Spaceship",
    timerift_water_spaceship = "Spaceship",
    castle_mu = "Spaceship", -- The Finale
    timerift_cave_tour = "Spaceship",

    mafia_town = "Mafia Town",
    mafia_town_night = "Mafia Town",
    mafia_town_lava = "Mafia Town",
    mafia_hq = "Mafia Town",
    mafia_town_dw_ufo = "Mafia Town",
    timerift_cave_mafia = "Mafia Town",
    timerift_water_mafia_easy = "Mafia Town",
    timerift_water_mafia_hard = "Mafia Town",

    deadbirdstudio = "Dead Bird Studio",
    chapter3_murder = "Dead Bird Studio",
    themoon = "Dead Bird Studio",
    trainwreck_selfdestruct = "Dead Bird Studio",
    dead_cinema = "Dead Bird Studio",
    timerift_cave_deadbird = "Dead Bird Studio",
    timerift_water_twreck_panels = "Dead Bird Studio",
    timerift_water_twreck_parade = "Dead Bird Studio",

    deadbirdbasement = "Dead Bird Basement",
    djgrooves_boss = "Dead Bird Basement",

    subconforest = "Subcon Forest",
    subcon_cave = "Subcon Forest",
    vanessa_manor = "Subcon Forest",
    timerift_cave_raccoon = "Subcon Forest",
    timerift_water_subcon_hookshot = "Subcon Forest",
    timerift_water_subcon_dwellers = "Subcon Forest",

    alpsandsails = "Alpine Skyline",
    timerift_cave_alps = "Alpine Skyline",
    timerift_water_alp_goats = "Alpine Skyline",
    timerift_water_alp_cats = "Alpine Skyline",

    ship_main = "Arctic Cruise",
    ship_sinking = "Arctic Cruise",
    timerift_cave_aquarium = "Arctic Cruise",
    timerift_water_cruise_slide = "Arctic Cruise",

    dlc_metro = "Nyakuza Metro",
    timerift_cave_rumbifactory = "Nyakuza Metro",

    dlc_metro = "Nyakuza Metro"
}

-- 38 total death wishes
local num_death_wish_classes = 38
local death_wish_classes = {
    Hat_SnatcherContract_DeathWish_HeatingUpHarder = "Beat the Heat",
    Hat_SnatcherContract_DeathWish_BackFromSpace = "So You're Back From Outer Space",
    Hat_SnatcherContract_DeathWish_KillEverybody = "Snatcher's Hit List",
    Hat_SnatcherContract_DeathWish_PonFrenzy = "Collect-a-thon",
    Hat_SnatcherContract_DeathWish_RiftCollapse_MafiaTown = "Rift Collapse: Mafia of Cooks",
    Hat_SnatcherContract_DeathWish_MafiaBossEX = "Encore! Encore!",
    Hat_SnatcherContract_DeathWish_Speedrun_MafiaAlien = "She Speedran from Outer Space",
    Hat_SnatcherContract_DeathWish_NoAPresses_MafiaAlien = "Mafia's Jumps",
    Hat_SnatcherContract_DeathWish_MovingVault = "Vault Codes in the Wind",
    Hat_SnatcherContract_DeathWish_Tokens_MafiaTown = "Snatcher Coins in Mafia Town",

    Hat_SnatcherContract_DeathWish_DeadBirdStudioMoreGuards = "Security Breach",
    Hat_SnatcherContract_DeathWish_DifficultParade = "The Great Big Hootenanny",
    Hat_SnatcherContract_DeathWish_RiftCollapse_Birds = "Rift Collapse: Dead Bird Studio",
    Hat_SnatcherContract_DeathWish_TrainRushShortTime = "10 Seconds until Self-Destruct",
    Hat_SnatcherContract_DeathWish_BirdBossEX = "Killing Two Birds",
    Hat_SnatcherContract_DeathWish_Tokens_Birds = "Snatcher Coins in Battle of the Birds",
    Hat_SnatcherContract_DeathWish_NoAPresses = "Zero Jumps",

    Hat_SnatcherContract_DeathWish_Speedrun_SubWell = "Speedrun Well",
    Hat_SnatcherContract_DeathWish_RiftCollapse_Subcon = "Rift Collapse: Sleepy Subcon",
    Hat_SnatcherContract_DeathWish_BossRush = "Boss Rush",
    Hat_SnatcherContract_DeathWish_SurvivalOfTheFittest = "Quality Time with Snatcher",
    Hat_SnatcherContract_DeathWish_SnatcherEX = "Breaching the Contract",
    Hat_SnatcherContract_DeathWish_Tokens_Subcon = "Snatcher Coins in Subcon Forest",

    Hat_SnatcherContract_DeathWish_NiceBirdhouse = "Bird Sanctuary",
    Hat_SnatcherContract_DeathWish_RiftCollapse_Alps = "Rift Collapse: Alpine Skyline",
    Hat_SnatcherContract_DeathWish_FastWindmill = "Wound-Up Windmill",
    Hat_SnatcherContract_DeathWish_Speedrun_Illness = "The Illness has Speedrun",
    Hat_SnatcherContract_DeathWish_Tokens_Alps = "Snatcher Coins in Alpine Skyline",
    Hat_SnatcherContract_DeathWish_CameraTourist_1 = "Camera Tourist",

    Hat_SnatcherContract_DeathWish_HardCastle = "The Mustache Gauntlet",
    Hat_SnatcherContract_DeathWish_MuGirlEX = "No More Bad Guys",

    Hat_SnatcherContract_DeathWish_BossRushEX = "Seal the Deal",
    Hat_SnatcherContract_DeathWish_RiftCollapse_Cruise = "Rift Collapse: Deep Sea",
    Hat_SnatcherContract_DeathWish_EndlessTasks = "Cruisin' for a Bruisin'",

    Hat_SnatcherContract_DeathWish_CommunityRift_RhythmJump = "Community Rift: Rhythm Jump Studio",
    Hat_SnatcherContract_DeathWish_CommunityRift_TwilightTravels = "Community Rift: Twilight Travels",
    Hat_SnatcherContract_DeathWish_CommunityRift_MountainRift = "Community Rift: The Mountain Rift",

    Hat_SnatcherContract_DeathWish_Tokens_Metro = "Snatcher Coins in Nyakuza Metro",
}
-- Number of stamps required to unlock specific contracts in normal Death Wish mode.
local death_wish_contract_stamp_requirements = {
    Hat_SnatcherContract_DeathWish_BackFromSpace = 2,
    Hat_SnatcherContract_DeathWish_DeadBirdStudioMoreGuards = 4,
    Hat_SnatcherContract_DeathWish_PonFrenzy = 5,
    Hat_SnatcherContract_DeathWish_DifficultParade = 7,
    Hat_SnatcherContract_DeathWish_Speedrun_MafiaAlien = 8,
    Hat_SnatcherContract_DeathWish_MafiaBossEX = 10,
    Hat_SnatcherContract_DeathWish_Speedrun_SubWell = 10,
    Hat_SnatcherContract_DeathWish_TrainRushShortTime = 15,
    Hat_SnatcherContract_DeathWish_BossRush = 15,
    Hat_SnatcherContract_DeathWish_NiceBirdhouse = 15,
    Hat_SnatcherContract_DeathWish_SurvivalOfTheFittest = 20,
    Hat_SnatcherContract_DeathWish_BirdBossEX = 25,
    Hat_SnatcherContract_DeathWish_FastWindmill = 30,
    Hat_SnatcherContract_DeathWish_Tokens_Metro = 30,
    Hat_SnatcherContract_DeathWish_Speedrun_Illness = 35,
    Hat_SnatcherContract_DeathWish_HardCastle = 35,
    Hat_SnatcherContract_DeathWish_SnatcherEX = 40,
    Hat_SnatcherContract_DeathWish_MuGirlEX = 50,
    Hat_SnatcherContract_DeathWish_BossRushEX = 70,
}
-- Prerequisite contracts to unlock specific contracts in noraml Death Wish mode.
local death_wish_contract_prerequisites = {
    Hat_SnatcherContract_DeathWish_BackFromSpace = {"Hat_SnatcherContract_DeathWish_HeatingUpHarder"},
    Hat_SnatcherContract_DeathWish_NoAPresses_MafiaAlien = {"Hat_SnatcherContract_DeathWish_Speedrun_MafiaAlien"},
    Hat_SnatcherContract_DeathWish_PonFrenzy = {"Hat_SnatcherContract_DeathWish_BackFromSpace"},
    Hat_SnatcherContract_DeathWish_Speedrun_MafiaAlien = {"Hat_SnatcherContract_DeathWish_RiftCollapse_MafiaTown"},
    Hat_SnatcherContract_DeathWish_MovingVault = {"Hat_SnatcherContract_DeathWish_PonFrenzy",
                                                  "Hat_SnatcherContract_DeathWish_Speedrun_MafiaAlien"},
    Hat_SnatcherContract_DeathWish_MafiaBossEX = {"Hat_SnatcherContract_DeathWish_PonFrenzy"},
    Hat_SnatcherContract_DeathWish_DeadBirdStudioMoreGuards = {"Hat_SnatcherContract_DeathWish_HeatingUpHarder"},
    Hat_SnatcherContract_DeathWish_TrainRushShortTime = {"Hat_SnatcherContract_DeathWish_DifficultParade"},
    Hat_SnatcherContract_DeathWish_DifficultParade = {"Hat_SnatcherContract_DeathWish_DeadBirdStudioMoreGuards"},
    Hat_SnatcherContract_DeathWish_BirdBossEX = {"Hat_SnatcherContract_DeathWish_RiftCollapse_Birds",
                                                 "Hat_SnatcherContract_DeathWish_TrainRushShortTime"},
    Hat_SnatcherContract_DeathWish_Speedrun_SubWell = {"Hat_SnatcherContract_DeathWish_HeatingUpHarder"},
    Hat_SnatcherContract_DeathWish_BossRush = {"Hat_SnatcherContract_DeathWish_Speedrun_SubWell"},
    Hat_SnatcherContract_DeathWish_SurvivalOfTheFittest = {"Hat_SnatcherContract_DeathWish_RiftCollapse_Subcon"},
    Hat_SnatcherContract_DeathWish_SnatcherEX = {"Hat_SnatcherContract_DeathWish_BossRush",
                                                 "Hat_SnatcherContract_DeathWish_SurvivalOfTheFittest"},
    Hat_SnatcherContract_DeathWish_NiceBirdhouse = {"Hat_SnatcherContract_DeathWish_HeatingUpHarder"},
    Hat_SnatcherContract_DeathWish_FastWindmill = {"Hat_SnatcherContract_DeathWish_NiceBirdhouse"},
    Hat_SnatcherContract_DeathWish_Speedrun_Illness = {"Hat_SnatcherContract_DeathWish_RiftCollapse_Alps",
                                                       "Hat_SnatcherContract_DeathWish_FastWindmill"},
    Hat_SnatcherContract_DeathWish_HardCastle = {"Hat_SnatcherContract_DeathWish_FastWindmill"},
    Hat_SnatcherContract_DeathWish_MuGirlEX = {"Hat_SnatcherContract_DeathWish_HardCastle"},
    Hat_SnatcherContract_DeathWish_EndlessTasks = {"Hat_SnatcherContract_DeathWish_RiftCollapse_Cruise"},
    Hat_SnatcherContract_DeathWish_BossRushEX = {"Hat_SnatcherContract_DeathWish_MafiaBossEX",
                                                 "Hat_SnatcherContract_DeathWish_BirdBossEX",
                                                 "Hat_SnatcherContract_DeathWish_SnatcherEX",
                                                 "Hat_SnatcherContract_DeathWish_MuGirlEX"},
    Hat_SnatcherContract_DeathWish_RiftCollapse_MafiaTown = {"Hat_SnatcherContract_DeathWish_BackFromSpace"},
    Hat_SnatcherContract_DeathWish_RiftCollapse_Birds = {"Hat_SnatcherContract_DeathWish_DeadBirdStudioMoreGuards"},
    Hat_SnatcherContract_DeathWish_RiftCollapse_Subcon = {"Hat_SnatcherContract_DeathWish_Speedrun_SubWell"},
    Hat_SnatcherContract_DeathWish_RiftCollapse_Alps = {"Hat_SnatcherContract_DeathWish_NiceBirdhouse"},
    Hat_SnatcherContract_DeathWish_RiftCollapse_Cruise = {"Hat_SnatcherContract_DeathWish_RiftCollapse_MafiaTown",
                                                          "Hat_SnatcherContract_DeathWish_RiftCollapse_Birds",
                                                          "Hat_SnatcherContract_DeathWish_RiftCollapse_Subcon",
                                                          "Hat_SnatcherContract_DeathWish_RiftCollapse_Alps"},
    Hat_SnatcherContract_DeathWish_CommunityRift_RhythmJump = {"Hat_SnatcherContract_DeathWish_TrainRushShortTime"},
    Hat_SnatcherContract_DeathWish_CommunityRift_TwilightTravels = {"Hat_SnatcherContract_DeathWish_SurvivalOfTheFittest"},
    Hat_SnatcherContract_DeathWish_CommunityRift_MountainRift = {"Hat_SnatcherContract_DeathWish_RiftCollapse_Alps"},
    Hat_SnatcherContract_DeathWish_KillEverybody = {"Hat_SnatcherContract_DeathWish_HeatingUpHarder"},
    Hat_SnatcherContract_DeathWish_Tokens_MafiaTown = {"Hat_SnatcherContract_DeathWish_BackFromSpace"},
    Hat_SnatcherContract_DeathWish_Tokens_Birds = {"Hat_SnatcherContract_DeathWish_DifficultParade"},
    Hat_SnatcherContract_DeathWish_NoAPresses = {"Hat_SnatcherContract_DeathWish_RiftCollapse_Birds"},
    Hat_SnatcherContract_DeathWish_Tokens_Subcon = {"Hat_SnatcherContract_DeathWish_RiftCollapse_Subcon"},
    Hat_SnatcherContract_DeathWish_Tokens_Alps = {"Hat_SnatcherContract_DeathWish_NiceBirdhouse"},
    Hat_SnatcherContract_DeathWish_Tokens_Metro = {"Hat_SnatcherContract_DeathWish_BirdBossEX"},
    Hat_SnatcherContract_DeathWish_CameraTourist_1 = {"Hat_SnatcherContract_DeathWish_RiftCollapse_Alps"},
}

death_wish_data_storage_key_to_class = {}
death_wish_class_to_shuffle_number = {}
death_wish_shuffle_completion_count = 0
death_wish_completions = {}
death_wish_remaining_excluded_main_objectives = {}
death_wish_remaining_excluded_bonuses = {}
DW_MODE_NORMAL = 0
DW_MODE_SHUFFLE = 1

--I initialise HatOrder in onClear but need to read the table during item checks
HatOrder = {}
-- There are missing numbers, that's just how it is.
local metro_thug_numbers = {0, 1, 2, 4, 5, 6, 7, 12, 13, 14}

FLAG_CODES = {}

function has_value (t, val)
    for i, v in ipairs(t) do
        if v == val then return 1 end
    end
    return 0
end

function dump_table(o, depth)
    if depth == nil then
        depth = 0
    end
    if type(o) == 'table' then
        local tabs = ('\t'):rep(depth)
        local tabs2 = ('\t'):rep(depth + 1)
        local s = '{\n'
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. tabs2 .. '[' .. k .. '] = ' .. dump_table(v, depth + 1) .. ',\n'
        end
        return s .. tabs .. '}'
    else
        return tostring(o)
    end
end

-- Enable progressive items that start with a lock icon when a specified option is enabled.
local function enabled_linked_progressive_items(option_item_code, linked_item_codes)
    local option_item = Tracker:FindObjectForCode(option_item_code)
    if not option_item then
        print("No item found for option_item_code '"..option_item_code.."'")
        return
    end
    local option_item_type = option_item.Type

    local option_enabled
    if option_item_type == "toggle" then
        option_enabled = option_item.Active
    elseif option_item_type == "progressive" then
        option_enabled = option_item.CurrentStage ~= 0
    else
        print("Unsupported option_item Type "..option_item_type)
    end

    if option_enabled then
        for _, item_code in ipairs(linked_item_codes) do
            local linked_item = Tracker:FindObjectForCode(item_code)
            if linked_item.Type == "progressive" then
                linked_item.CurrentStage = linked_item.CurrentStage + 1
            else
                print("Linked item Type should be 'progressive', but was '"..linked_item.Type.."'")
            end
        end
    end
end


function onClear(slot_data)
    --SLOT_DATA = slot_data
    CUR_INDEX = -1

    -- Reset completed entrances
    completed_entrances = {}

    for _, v in pairs(chapter_act_info) do
        v:clearCompletion()
    end

    -- reset locations
    -- Multiple location IDs can correspond to the same location in the tracker, so only reset each tracker location
    -- once.
    local reset_locations = {}
    for _, v in pairs(LOCATION_MAPPING) do
        if reset_locations[v] == nil then
            reset_locations[v] = true
            local obj = Tracker:FindObjectForCode(v)
            if obj then
                obj.AvailableChestCount = obj.ChestCount
            else
                print(string.format("onClear: Could not find location '%s'", v))
            end
        end
    end
    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onClear: clearing item %s", v))
        end
        local obj = Tracker:FindObjectForCode(v)
        if obj then
            local obj_type = obj.Type
            if obj_type == "toggle" then
                obj.Active = false
            elseif obj_type == "progressive" then
                obj.CurrentStage = 0
                obj.Active = false
            elseif obj_type == "consumable" then
                obj.AcquiredCount = 0
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: unknown item type %s for code %s", obj_type, v))
            end
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onClear: could not find object for code %s", v))
        end
    end

    --reset HatOrder
    HatOrder = {}

    if slot_data == nil  then
        print("welp")
        return
    end
    
    if slot_data['Hat1'] then
        SprintHatCost = slot_data['SprintYarnCost']
        BrewingHatCost = slot_data['BrewingYarnCost']
        IceHatCost = slot_data['IceYarnCost']
        DwellerMaskCost = slot_data['DwellerYarnCost']
        TimeHatCost = slot_data['TimeStopYarnCost']

        function GetHat(hatnum)
            SPRINT = 0
            BREWING = 1
            ICE = 2
            DWELLER = 3
            TIME_STOP = 4
            if hatnum == 0 then return 'sprint', SprintHatCost end
            if hatnum == 1 then return 'brewer', BrewingHatCost end
            if hatnum == 2 then return 'ice', IceHatCost end
            if hatnum == 3 then return 'dweller', DwellerMaskCost end
            if hatnum == 4 then return 'timestop', TimeHatCost end
        end

        for i=1, 5 do
            k, v = GetHat(slot_data['Hat'..i])
            HatOrder[i] = { [k] = v }
        end
        --[[ debug stuff, in case autochecking hats still needs work
        print("Hat1: "..slot_data['Hat1'])
        print("Hat2: "..slot_data['Hat2'])
        print("Hat3: "..slot_data['Hat3'])
        print("Hat4: "..slot_data['Hat4'])
        print("Hat5: "..slot_data['Hat5'])
        print(dump_table(HatOrder))
        ]]
    end

    --set data storage keys
    map_key = string.format("ahit_currentmap_%s", Archipelago.PlayerNumber)
    completed_acts_key = string.format("ahit_clearedacts_%s", Archipelago.PlayerNumber)

    Archipelago:SetNotify({map_key, completed_acts_key})
    Archipelago:Get({map_key, completed_acts_key})

    local function setFromSlotData(slot_data_key, item_code_or_location, offset)
        -- Optional offset added to the value read from slot data.
        -- Only applicable to locations and progressive items.
        offset = offset or 0

        local v = slot_data[slot_data_key]
        if not v then
            print(string.format("Could not find key '%s' in slot data", slot_data_key))
            return
        end
        local obj = Tracker:FindObjectForCode(item_code_or_location)
        if not obj then
            print(string.format("Could not find item/location for code '%s'", item_code_or_location))
            return
        end

        if item_code_or_location:sub(1, 1) == "@" then
            obj.AvailableChestCount = v + offset
        else
            if obj.Type == 'toggle' then
                obj.Active = v ~= 0
            elseif obj.Type == 'progressive' then
                obj.CurrentStage = v + offset
            elseif obj.Type == 'consumable' then
                obj.AcquiredCount = v + offset
            else
                print(string.format("Unsupported item type '%s' for item '%s'", tostring(obj.Type), item_code_or_location))
            end
        end
    end

    setFromSlotData('ShuffleStorybookPages', "pages")
    setFromSlotData('ShuffleActContracts', "contract")
    setFromSlotData('ShuffleSubconPaintings', "paintings")
    setFromSlotData('ShuffleAlpineZiplines', "ziplines_logic")
    setFromSlotData('UmbrellaLogic', "umbrella_logic")
    setFromSlotData('LogicDifficulty', "difficulty", 1)
    setFromSlotData('CTRLogic', "ctrlogic")
    setFromSlotData('NoPaintingSkips', "no_painting_skips")
    setFromSlotData('NoTicketSkips', "no_ticket_skips")
    setFromSlotData('ExcludeTour', "exclude_tour_option")
    setFromSlotData('Tasksanity', "tasksanity")
    setFromSlotData('EnableDLC1', "dlc1")
    setFromSlotData('EnableDLC2', "dlc2")

    setFromSlotData('TasksanityCheckCount', "@The Arctic Cruise/Lost and Found/Tasksanity Check")
    setFromSlotData('BadgeSellerItemCount', "@Shops/Badge Seller/Scammed")
    setFromSlotData('Hat_NPC_NyakuzaShop_0', "@Nyakuza Shops/Main Station Thugs/Thug A")
    setFromSlotData('Hat_NPC_NyakuzaShop_1', "@Nyakuza Shops/Main Station Thugs/Thug B")
    setFromSlotData('Hat_NPC_NyakuzaShop_2', "@Nyakuza Shops/Main Station Thugs/Thug C")
    setFromSlotData('Hat_NPC_NyakuzaShop_13', "@Nyakuza Shops/Yellow Overpass Thug A/Scammed")
    setFromSlotData('Hat_NPC_NyakuzaShop_5', "@Nyakuza Shops/Yellow Overpass Thug B/Scammed")
    setFromSlotData('Hat_NPC_NyakuzaShop_14', "@Nyakuza Shops/Yellow Overpass Thug C/Scammed")
    setFromSlotData('Hat_NPC_NyakuzaShop_4', "@Nyakuza Shops/Green Clean Thug A/Scammed")
    setFromSlotData('Hat_NPC_NyakuzaShop_6', "@Nyakuza Shops/Green Clean Thug B/Scammed")
    setFromSlotData('Hat_NPC_NyakuzaShop_7', "@Nyakuza Shops/Bluefin Tunnel Thug/Scammed")
    setFromSlotData('Hat_NPC_NyakuzaShop_12', "@Nyakuza Shops/Pink Paw Station Thug/Scammed")
    -- There are internal items used by the tracker to specify if a shop should be visible on the map.
    Tracker:FindObjectForCode("badge_seller_enabled").Active = (slot_data["BadgeSellerItemCount"] or 0) > 0
    local dlc2_enabled = Tracker:FindObjectForCode("dlc2").Active
    if dlc2_enabled then
        for _, v in ipairs(metro_thug_numbers) do
            v = tostring(v)
            local thug_enabled_item = Tracker:FindObjectForCode("metro_thug_enabled_"..v)
            local item_count = slot_data["Hat_NPC_NyakuzaShop_"..v]
            -- AHiT in Archipelago 0.5.0 has a bug where Metro Thug shops can be absent from slot_data when they have no
            -- items.
            thug_enabled_item.Active = item_count ~= nil and item_count ~= 0
        end
    end

    -- Enable DLC items depending on which DLCs are enabled.
    -- The DLC items have an extra initial stage that displays a lock icon. Increase the stage to show the default icon
    -- for items that have not been acquired yet.
    enabled_linked_progressive_items("dlc1", {"cakerelic"})
    enabled_linked_progressive_items("dlc2", {"jewelryrelic",
                                              "metro_ticket_green",
                                              "metro_ticket_blue",
                                              "metro_ticket_pink",
                                              "metro_ticket_yellow"})

    -- Enable the zipline unlocks when ziplines are shuffled
    enabled_linked_progressive_items("ziplines_logic", {"zipline_unlock_twilight_bell",
                                                        "zipline_unlock_birdhouse",
                                                        "zipline_unlock_lava_cake",
                                                        "zipline_unlock_windmill"})

    -- set hash table to randomized acts
    for chapter_number = 1,7 do
        local chapter = string.format('Chapter%dCost', chapter_number)
        
        if slot_data[chapter] and slot_data[chapter] >= 0 then
            chapter_costs[chapter_number] = slot_data[chapter]
        else
            -- Effectively disable the chapter.
            chapter_costs[chapter_number] = 99999
        end
    end

    if slot_data['ActRandomizer'] then
        -- 0: Disabled
        -- 1: Light
        -- 2: Insanity
        act_rando_enabled = slot_data['ActRandomizer'] > 0
    end

    -- Load randomized act entrances. If an act is not present, e.g. the chapter is not enabled, it is set to its
    -- vanilla act.
    for vanilla_act_name, act in pairs(chapter_act_info) do
        local act_name = slot_data[vanilla_act_name] or vanilla_act_name
        act:setActName(act_name)
    end

    updateActToEntrance()

    if Tracker.ActiveVariantUID == "variant_death_wish" then
        death_wish_data_storage_key_to_class = {}
        death_wish_class_to_shuffle_number = {}
        death_wish_shuffle_completion_count = 0
        death_wish_completions = {}
        death_wish_remaining_excluded_main_objectives = {}
        death_wish_remaining_excluded_bonuses = {}

        setFromSlotData('DWEnableBonus', "dw_enable_bonus")
        setFromSlotData('DWAutoCompleteBonuses', "dw_auto_complete_bonuses")
        setFromSlotData('DWShuffle', "dw_mode") -- 0: normal, 1: shuffle
        setFromSlotData('DWTimePieceRequirement', "dw_timepiece_requirement")

        -- Stamps are calculated from completed contracts.
        local stamps = Tracker:FindObjectForCode("stamp")
        stamps.AcquiredCount = 0
        local logical_stamps = Tracker:FindObjectForCode("logical_stamp")
        logical_stamps.AcquiredCount = 0

        -- Reset cleared contract events.
        for _, contract_name in pairs(death_wish_classes) do
            local contract_location_name = string.format("@Death Wish/Contract - %s/%s", contract_name, contract_name)

            -- Reset main objective.
            local main_objective_event_section_name = contract_location_name.."/Main Objective Complete (Event)"
            local main_objective_event_section = Tracker:FindObjectForCode(main_objective_event_section_name)
            main_objective_event_section.AvailableChestCount = main_objective_event_section.ChestCount

            -- Reset bonuses.
            local all_clear_event_section_name = string.format("%s/All Clear Complete (Event)", contract_location_name)
            local all_clear_event_section = Tracker:FindObjectForCode(all_clear_event_section_name)
            all_clear_event_section.AvailableChestCount = all_clear_event_section.ChestCount
        end

        local data_storage_request_keys = {}
        local dw_mode = Tracker:FindObjectForCode("dw_mode").CurrentStage
        if dw_mode == DW_MODE_NORMAL then
            -- # # # # #
            -- DW Normal

            -- TODO: Find out if excluded contracts/bonuses get set into data storage as if they have been cleared.
            --       If not, then we would need to read the excluded ones to determine stamp counts.
            -- Read "excluded_dw{num}" from slot data from 0 to ??? until nil to find all excluded contracts.

            -- Read "excluded_bonus{num}" from slot data from 0 to ??? until nil to find all excluded bonuses.

            -- Request from data storage and listen to updates to "{contract_class}_{slot_number}" for each non-excluded
            -- contract.
            for death_wish_class, _ in pairs(death_wish_classes) do
                if dlc2_enabled or death_wish_class ~= "Hat_SnatcherContract_DeathWish_Tokens_Metro" then
                    local data_storage_key = string.format("%s_%s", death_wish_class, Archipelago.PlayerNumber)
                    death_wish_data_storage_key_to_class[data_storage_key] = death_wish_class
                    table.insert(data_storage_request_keys, data_storage_key)
                end
            end

            -- Load excluded Death Wish Contracts.
            for i=1,num_death_wish_classes do
                -- The slot data keys are zero-indexed, so subtract 1.
                local excluded_contract = slot_data["excluded_dw"..(i - 1)]
                if excluded_contract == nil then
                    break
                else
                    death_wish_remaining_excluded_main_objectives[excluded_contract] = true
                end
            end

            -- Beat The Heat is the initially unlocked contract, if it is excluded, it will auto-complete, which could
            -- cause other excluded contracts to auto-complete.
            if death_wish_remaining_excluded_main_objectives["Hat_SnatcherContract_DeathWish_HeatingUpHarder"] then
                checkDeathWishAutoCompletions()
            end

            -- Load excluded Bonuses
            for i=1,num_death_wish_classes do
                -- The slot data keys are zero-indexed, so subtract 1.
                local excluded_bonus = slot_data["excluded_bonus"..(i - 1)]
                if excluded_bonus == nil then
                    break
                else
                    death_wish_remaining_excluded_bonuses[excluded_bonus] = true
                end
            end
        elseif dw_mode == DW_MODE_SHUFFLE then
            -- # # # # #
            -- DW Shuffle
            --
            -- Slot data does not contain excluded contracts/bonuses in this mode.
            -- Excluded contracts are simply not part of the shuffle sequence.
            -- Stamps are irrelevant in this mode, so we don't care if the stamp count doesn't match.
            -- The stamp counts in shuffle mode are weird anyway, I'm not sure how they get counted.
            local num_shuffle_contracts = num_death_wish_classes
            for i=1,num_death_wish_classes do
                -- The slot data keys are zero-indexed, so subtract 1.
                local shuffle_contract = slot_data["dw_"..(i - 1)]
                if shuffle_contract == nil then
                    num_shuffle_contracts = i - 1
                    break
                else
                    death_wish_class_to_shuffle_number[shuffle_contract] = i - 1
                    local data_storage_key = string.format("%s_%s", shuffle_contract, Archipelago.PlayerNumber)
                    death_wish_data_storage_key_to_class[data_storage_key] = shuffle_contract
                    table.insert(data_storage_request_keys, data_storage_key)
                end
            end

            -- Read "dw_{num}" from slot data from 0 to ??? until nil to find the contract at each part of the sequence.

            -- Request from data storage and listen to updates to "{contract_class}_{slot_number}" for each contract in the
            -- sequence.
        else
            print("Error: Unknown Death Wish Mode "..tostring(dw_mode))
        end

        Archipelago:SetNotify(data_storage_request_keys)
        Archipelago:Get(data_storage_request_keys)
    end

    --print(dump_table(slot_data))
end

function onClearHandler(slot_data)
    -- Disable tracker updates.
    Tracker.BulkUpdate = true
    -- Use a protected call so that tracker updates always get enabled again, even if an error occurred.
    local ok, err = pcall(onClear, slot_data)
    -- Enable tracker updates again.
    if ok then
        -- Defer re-enabling tracker updates until the next frame, which doesn't happen until all received items/cleared
        -- locations from AP have been processed.
        local handlerName = "AP onClearHandler"
        local function frameCallback()
            ScriptHost:RemoveOnFrameHandler(handlerName)
            Tracker.BulkUpdate = false
            forceUpdate()
        end
        ScriptHost:AddOnFrameHandler(handlerName, frameCallback)
    else
        Tracker.BulkUpdate = false
        print("Error: onClear failed:")
        print(err)
    end
end

-- There's no explicit event on receiving hats so I fetched the hat order and cost
-- for each hat on Clear, then here I count how many yarn has been received
function updateYarn(yarn)
    count = yarn.AcquiredCount
    --print("Yarn: "..(yarn.AcquiredCount))
    for k,v in ipairs(HatOrder) do
        for l,w in pairs(v) do
            local obj = Tracker:FindObjectForCode(l)
            if count >= w then
                if not obj.Active then
                    obj.Active = true
                    print("Activating hat " .. l .. " due to getting enough Yarn")
                end
            else
                obj.Active = false
            end
            count = count - w
        end
    end
end

--called when map is changed
function changedMap(current_map, previous_map)
    if current_map == nil then
        return
    end

    local auto_switch_setting_item = Tracker:FindObjectForCode("setting_auto_map_switch")
    if not auto_switch_setting_item.Active then
        -- Automatic map switching is disabled
        return
    end

    local internal_map_name = map_table[current_map]
    
    if internal_map_name == nil then
        print(string.format("Could not find map name %s; Setting to default map", current_map))
        internal_map_name = "default"
    end
    if internal_map_name == "default" then
        local default_map_setting_item = Tracker:FindObjectForCode("setting_default_map")
        local current_stage = default_map_setting_item.CurrentStage
        if current_stage == 1 then
            internal_map_name = "Entrances"
        else
            internal_map_name = "Spaceship"
        end
    end
    Tracker:UiHint("ActivateTab", internal_map_name)
end

function tryCompleteEntranceWithFreeRoamAct(act_name, free_roam_acts)
    for free_roam_act, _ in pairs(free_roam_acts) do
        if completed_entrances[free_roam_act] == nil then
            -- Not all of the free roam's acts have been completed.
            return
        end
    end

    -- Clear the location sections of the entrance whose act is `act_name`.
    local entrance_with_free_roam_act = getActInfo(act_name)
    entrance_with_free_roam_act:markAsCompleted()
end

function changedCompletedEntrances(current, previous)
    if current == nil then
        return
    end
    local new_completions = false

    -- todo: Find out if `current` is guaranteed to be the same as `previous` but with extra elements. Then the
    --       iteration could skip immediately to the new elements. Note that `previous` is initially `nil` at the start.
    for _, entrance_name in ipairs(current) do
        if completed_entrances[entrance_name] == nil then
            new_completions = true
            completed_entrances[entrance_name] = true
            entrance = chapter_act_info[entrance_name]
            if entrance then
                entrance:markAsCompleted()
                --print("Player has completed the act at entrance '" .. entrance_name .. "', so the entrance has been cleared")

                -- Clear the entrance that has a free roam act if all of the free roam's acts have been completed.
                if nyakuza_free_roam_act_names[entrance_name] then
                    tryCompleteEntranceWithFreeRoamAct("MetroFreeRoam", nyakuza_free_roam_act_names)
                elseif alpine_free_roam_act_names[entrance_name] then
                    tryCompleteEntranceWithFreeRoamAct("AlpineFreeRoam", alpine_free_roam_act_names)
                end
            else
                print("Error: Player has completed the act at the entrance '" .. entrance_name .. "', but no such entrance could be found.")
            end
        else
            --print("Player has re-completed the act at entrance '" .. entrance_name .. "'")
        end
    end

    if new_completions then
        forceUpdate()
    end

    --print(dump_table(current))
end

function checkDeathWishAutoCompletions()
    local stamps = Tracker:FindObjectForCode("stamp")
    -- Logic only counts stamps from bonuses when both parts of the bonus are completed.
    local logical_stamps = Tracker:FindObjectForCode("logical_stamp")

    local stamp_count = stamps.AcquiredCount

    local changed
    repeat
        changed = false

        -- Check for excluded main objectives that should now auto-complete.
        -- In death wish shuffle, excluded main objectives do not exist in the sequence, so can be ignored.
        for contract, _ in pairs(death_wish_remaining_excluded_main_objectives) do
            local stamp_requirement = death_wish_contract_stamp_requirements[contract] or 0
            if stamp_count >= stamp_requirement then
                local prerequisite_contracts = death_wish_contract_prerequisites[contract] or {}
                local all_prerequisites_complete = true
                for _, prerequisite_contract in ipairs(prerequisite_contracts) do
                    local prerequisite_completion_state = death_wish_completions[prerequisite_contract] or {}
                    if not prerequisite_completion_state[0] then
                        all_prerequisites_complete = false
                        break
                    end
                end
                if all_prerequisites_complete then
                    print(string.format("Auto-completing excluded contract %s", contract))
                    -- Auto-complete the entire contract.
                    local completion_state = death_wish_completions[contract]
                    if completion_state == nil then
                        completion_state = {}
                        death_wish_completions[contract] = completion_state
                    end
                    -- An excluded main objective auto-completes everything.
                    local stamps_to_add = 0
                    local logical_stamps_to_add = 0
                    if not completion_state[0] then
                        completion_state[0] = true
                        stamps_to_add = stamps_to_add + 1
                        logical_stamps_to_add = logical_stamps_to_add + 1
                    end

                    local auto_completing_bonus = false
                    if not completion_state[1] then
                        completion_state[1] = true
                        stamps_to_add = stamps_to_add + 1
                        auto_completing_bonus = true
                    end
                    if not completion_state[2] then
                        completion_state[2] = true
                        stamps_to_add = stamps_to_add + 1
                        auto_completing_bonus = true
                    end
                    if auto_completing_bonus then
                        logical_stamps_to_add = logical_stamps_to_add + 2
                        -- Normally, a fully excluded contract won't be present in the excluded bonuses, but remove it
                        -- from excluded bonuses if this is not the case (maybe manually excluded bonuses could cause
                        -- this?).
                        death_wish_remaining_excluded_bonuses[contract] = nil
                    end

                    -- Loop again in-case auto-completing the contract unlocks additional contracts that also
                    -- auto-complete.
                    changed = true
                    stamps.AcquiredCount = stamps.AcquiredCount + stamps_to_add
                    logical_stamps.AcquiredCount = logical_stamps.AcquiredCount + logical_stamps_to_add
                    -- Remove the excluded contract from the next loop
                    death_wish_remaining_excluded_main_objectives[contract] = nil
                end
            end
        end
    until not changed
end

function onDeathWishContractCompleted(contract_class, current, previous)
    current = current or ""

    local stamps = Tracker:FindObjectForCode("stamp")
    -- Logic only counts stamps from bonuses when both parts of the bonus are complete.
    local logical_stamps = Tracker:FindObjectForCode("logical_stamp")

    local current_completion = death_wish_completions[contract_class]
    if current_completion == nil then
        current_completion = {}
        death_wish_completions[contract_class] = current_completion
    end

    local changed = false

    for i=0,2 do
        -- Replace `nil` with `false` by comparing against `true`.
        local already_complete = current_completion[i] == true
        -- String contains "0" if the main objective is complete.
        -- String contains "1" if the first part of the bonus is complete.
        -- String contains "2" if the second part of the bonus is complete.
        -- I have seen a string be "0012". I have no idea how that can happen, but the code here handles that odd case
        -- without issue.
        -- The AHiT AP mod only updates contracts in datastorage when the main objective gets completed or when the
        -- contract is fully completed. If the main objective and one bonus are completed simultaneously, or a bonus is
        -- completed before the main objective, and then the main objective is completed afterward, datastorage for the
        -- contract can end up as "01" or "02". Completing only the main objective sets "0", but completing only bonus 1
        -- or 2 after that will not update datastorage until both bonuses are completed.
        local is_complete = string.find(current, tostring(i)) ~= nil
        if is_complete ~= already_complete then
            changed = true
            if is_complete then
                current_completion[i] = true
                stamps.AcquiredCount = stamps.AcquiredCount + 1
                local contract_name = death_wish_classes[contract_class]
                local contract_location_name = string.format("@Death Wish/Contract - %s/%s", contract_name, contract_name)
                if i == 0 then
                    death_wish_shuffle_completion_count = death_wish_shuffle_completion_count + 1
                    logical_stamps.AcquiredCount = logical_stamps.AcquiredCount + 1
                    if death_wish_remaining_excluded_main_objectives[contract_class] then
                        print(string.format("Warning: Manually completed main objective of excluded contract %s which"..
                                            " should have been completed automatically."))
                        death_wish_remaining_excluded_main_objectives[contract_class] = nil
                    end

                    -- Clear the Main Objective event section.
                    local main_objective_event_section_name = contract_location_name.."/Main Objective Complete (Event)"
                    local main_objective_event_section = Tracker:FindObjectForCode(main_objective_event_section_name)
                    main_objective_event_section.AvailableChestCount = main_objective_event_section.AvailableChestCount - 1

                    if death_wish_remaining_excluded_bonuses[contract_class] then
                        -- Act as if the bonuses have also been completed.
                        current = "012"
                        -- Remove the contract from the remaining excluded bonuses.
                        death_wish_remaining_excluded_bonuses[contract_class] = nil
                        print(string.format("Auto-completing excluded bonuses for %s", contract_class))

                        -- Clear the All Clear event section.
                        local all_clear_event_section_name = string.format("%s/All Clear Complete (Event)", contract_location_name)
                        local all_clear_event_section = Tracker:FindObjectForCode(all_clear_event_section_name)
                        all_clear_event_section.AvailableChestCount = all_clear_event_section.AvailableChestCount - 1
                    end
                elseif (i == 1 and current_completion[2]) or (i == 2 and current_completion[1]) then
                    -- Clear the All Clear event section
                    local all_clear_event_section_name = string.format("%s/All Clear Complete (Event)", contract_location_name)
                    local all_clear_event_section = Tracker:FindObjectForCode(all_clear_event_section_name)
                    all_clear_event_section.AvailableChestCount = all_clear_event_section.AvailableChestCount - 1

                    logical_stamps.AcquiredCount = logical_stamps.AcquiredCount + 2
                end
                print(string.format("Completed death wish contract %s objective %s.", contract_class, i))
                --print("New stamp count: "..tostring(stamps.AcquiredCount))
                --print("New logical stamp count: "..tostring(logical_stamps.AcquiredCount))
            end
        end
    end

    if changed then
        -- Excluded death wishes do not exist in death wish shuffle and stamps are irrelevant to logic in death wish
        -- shuffle.
        local is_normal_death_wish = Tracker:FindObjectForCode("dw_mode").CurrentStage == 0
        if is_normal_death_wish then
            checkDeathWishAutoCompletions()
        end
    end
end

function forceUpdate()
    local update = Tracker:FindObjectForCode("update")
    update.Active = not update.Active
end

--Tracker Handlers

function onItem(index, item_id, item_name, player_number)
    if index <= CUR_INDEX then
        return
    end
    --local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index;
    local v = ITEM_MAPPING[item_id]
    if not v then
        --print(string.format("onItem: could not find item mapping for id %s", item_id))
        return
    end
    local obj = Tracker:FindObjectForCode(v)
    if obj then
        local obj_type = obj.Type
        if obj_type == "toggle" then
            obj.Active = true
        elseif obj_type == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif obj_type == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
            if v == 'yarn' then --extra handling for hat autotracking
                updateYarn(obj)
            end
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: unknown item type %s for code %s", obj_type, v))
        end
        --print("onItem: Updated item check "..v)
    else
        print(string.format("onItem: could not find object for code %s", v))
    end
end

--called when a location gets cleared
function onLocation(location_id, location_name)
    local v = LOCATION_MAPPING[location_id]
    if not v then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
        return
    end
    local obj = Tracker:FindObjectForCode(v)

    if obj then
        if v:sub(1, 1) == "@" then
            obj.AvailableChestCount = obj.AvailableChestCount - 1
        end
        --print("onLocation: checked spot "..v[1])
    else
        print(string.format("onLocation: could not find object for code %s", v))
    end
end

function onEvent(key, new_value, old_value)
    if key == map_key then
        changedMap(new_value, old_value)
    elseif key == completed_acts_key then
        -- `old_value` may be `nil` initially.
        -- Values are expected to be a list of strings, e.g. {"chapter1_tutorial", "chapter1_cannon_repair"}
        changedCompletedEntrances(new_value, old_value)
    else
        local contract_class = death_wish_data_storage_key_to_class[key]
        if contract_class ~= nil then
            onDeathWishContractCompleted(contract_class, new_value, old_value)
        else
            print("Unknown key "..tostring(key))
        end
        -- print(key..":\n\t"..dump_table(new_value))
    end
end

Archipelago:AddClearHandler("clear handler", onClearHandler)
Archipelago:AddRetrievedHandler("event handler", onEvent)
Archipelago:AddSetReplyHandler("event launch handler", onEvent)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
