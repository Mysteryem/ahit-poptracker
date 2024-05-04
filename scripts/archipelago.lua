require("objects/chapter_info")

ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

CUR_INDEX = -1
--SLOT_DATA = nil

-- Locations for time pieces that need to be collected to unlock finales
local subcon_timepieces = {
    contractual_obligations = "@Yellow Firewall/Contractual Obligations/Time Piece",
    subcon_well = "@Yellow Firewall/Subcon Well/Time Piece",
    toilet_of_doom = "@Boss Arena Area/Boss Arena/Toilet of Doom",
    queen_vanessas_manor = "@Yellow Firewall/Queen Vanessa's Manor/Time Piece",
    mail_delivery_service = "@Subcon Forest/Snatcher/Mail Delivery Service"
}

local apline_timepieces = {
    birdhouse = "@Birdhouse Zipline/Bird House/Time Piece",
    lava_cake = "@Lava Cake Zipline/Lava Cake/Time Piece",
    twilight_bell = "@Twilight Bell Zipline/The Twilight Bell/Time Piece",
    windmill = "@Windmill Zipline/The Windmill/Time Piece"
}

local nyakuza_timepieces = {
    intro = "@Nyakuza Metro/Nyakuza Metro Intro/Time Piece",
    yellow_station = "@Nyakuza Metro/Yellow Overpass Station/Time Piece",
    yellow_manhole = "@Nyakuza Metro/Yellow Overpass Manhole/Time Piece",
    green_station = "@Nyakuza Metro/Green Clean Station/Time Piece",
    green_manhole = "@Nyakuza Metro/Green Clean Manhole/Time Piece",
    bluefin_tunnel = "@Nyakuza Metro/Bluefin Tunnel/Time Piece",
    pink_station = "@Nyakuza Metro/Pink Paw Station/Time Piece",
    pink_manhole = "@Nyakuza Metro/Pink Paw Manhole/Time Piece"
}

-- Setup for auto map switching
local map_table = {
    hub_spaceship = "Spaceship",

    mafia_town = "Mafia Town",
    mafia_town_night = "Mafia Town",
    mafia_town_lava = "Mafia Town",
    mafia_hq = "Mafia Town",
    mafia_town_dw_ufo = "Mafia Town",

    deadbirdstudio = "Dead Bird Studio",
    chapter3_murder = "Dead Bird Studio",
    themoon = "Dead Bird Studio",
    trainwreck_selfdestruct = "Dead Bird Studio",
    dead_cinema = "Dead Bird Studio",

    deadbirdbasement = "Dead Bird Basement",
    djgrooves_boss = "Dead Bird Basement",

    subconforest = "Subcon Forest",
    subcon_cave = "Subcon Forest",
    vanessa_manor = "Subcon Forest",

    alpsandsails = "Alpine Skyline",

    -- placeholders for the DLC
    -- ship_main = "Boat",
    -- ship_sinking = "Boat",

    DLC_Metro = "Nyakuza Metro"
}

--I initialise HatOrder in onClear but need to read the table during item checks
HatOrder = {}

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


function onClear(slot_data)
    --SLOT_DATA = slot_data
    CUR_INDEX = -1

    -- reset locations
    for _, v in pairs(LOCATION_MAPPING) do
        if v[1] then
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[1]:sub(1, 1) == "@" then
                    obj.AvailableChestCount = obj.ChestCount
                else
                    obj.Active = false
                end
            end
        end
    end
    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    obj.CurrentStage = 0
                    obj.Active = false
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
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

    if slot_data['ShuffleStorybookPages'] then
        local obj = Tracker:FindObjectForCode("pages")
        local val = slot_data['ShuffleStorybookPages']
        if obj then
            obj.Active = val
        end
    end

    if slot_data['ShuffleActContracts'] then
        local obj = Tracker:FindObjectForCode("contract")
        local val = slot_data['ShuffleActContracts']
        if obj then
            obj.Active = val
        end
    end

    if slot_data['ShuffleSubconPaintings'] then
        local obj = Tracker:FindObjectForCode("paintings")
        local stage = slot_data['ShuffleSubconPaintings']
        if obj then
            obj.CurrentStage = stage
        end
    end

    if slot_data['ShuffleAlpineZiplines'] then
        local obj = Tracker:FindObjectForCode("ziplines_logic")
        local stage = slot_data['ShuffleAlpineZiplines']
        if obj then
            obj.CurrentStage = stage
        end
    end

    if slot_data['UmbrellaLogic'] then
        local obj = Tracker:FindObjectForCode("umbrella_logic")
        local val = slot_data['UmbrellaLogic']
        if obj then
            obj.CurrentStage = val
        end
    end

    if slot_data['LogicDifficulty'] then
        local obj = Tracker:FindObjectForCode("difficulty")
        local val = slot_data['LogicDifficulty']
        if obj then
            obj.CurrentStage = val + 1
        end
    end

    if slot_data['CTRLogic'] then
        local obj = Tracker:FindObjectForCode("ctrlogic")
        local val = slot_data['CTRLogic']
        if obj then
            obj.CurrentStage = val
        end
    end

    if slot_data['NoPaintingSkips'] then
        local obj = Tracker:FindObjectForCode("painting_skips")
        local val = slot_data['NoPaintingSkips']
        if obj then
            obj.CurrentStage = val + 1
        end
    end

    if slot_data['NoTicketSkips'] then
        local obj = Tracker:FindObjectForCode("ticket_skips")
        local val = slot_data['NoTicketSkips']
        if obj then
            obj.CurrentStage = val
        end
    end

    if slot_data['BadgeSellerItemCount'] then
        local obj = Tracker:FindObjectForCode("@Shops/Badge Seller/Scammed")
        local val = slot_data['BadgeSellerItemCount']
        if obj then
            obj.AvailableChestCount = val
        end
    end

    if slot_data['Hat_NPC_NyakuzaShop_0'] then
        local obj = Tracker:FindObjectForCode("@Nyakuza Shops/Main Station Thugs/Thug A")
        local val = slot_data['Hat_NPC_NyakuzaShop_0']
        if obj then
            obj.AvailableChestCount = val
        end
    end

    if slot_data['Hat_NPC_NyakuzaShop_1'] then
        local obj = Tracker:FindObjectForCode("@Nyakuza Shops/Main Station Thugs/Thug B")
        local val = slot_data['Hat_NPC_NyakuzaShop_1']
        if obj then
            obj.AvailableChestCount = val
        end
    end

    if slot_data['Hat_NPC_NyakuzaShop_2'] then
        local obj = Tracker:FindObjectForCode("@Nyakuza Shops/Main Station Thugs/Thug C")
        local val = slot_data['Hat_NPC_NyakuzaShop_2']
        if obj then
            obj.AvailableChestCount = val
        end
    end

    if slot_data['Hat_NPC_NyakuzaShop_13'] then
        local obj = Tracker:FindObjectForCode("@Nyakuza Shops/Yellow Overpass Thug A/Scammed")
        local val = slot_data['Hat_NPC_NyakuzaShop_13']
        if obj then
            obj.AvailableChestCount = val
        end
    end

    if slot_data['Hat_NPC_NyakuzaShop_5'] then
        local obj = Tracker:FindObjectForCode("@Nyakuza Shops/Yellow Overpass Thug B/Scammed")
        local val = slot_data['Hat_NPC_NyakuzaShop_5']
        if obj then
            obj.AvailableChestCount = val
        end
    end

    if slot_data['Hat_NPC_NyakuzaShop_14'] then
        local obj = Tracker:FindObjectForCode("@Nyakuza Shops/Yellow Overpass Thug C/Scammed")
        local val = slot_data['Hat_NPC_NyakuzaShop_14']
        if obj then
            obj.AvailableChestCount = val
        end
    end

    if slot_data['Hat_NPC_NyakuzaShop_4'] then
        local obj = Tracker:FindObjectForCode("@Nyakuza Shops/Green Clean Thug A/Scammed")
        local val = slot_data['Hat_NPC_NyakuzaShop_4']
        if obj then
            obj.AvailableChestCount = val
        end
    end

    if slot_data['Hat_NPC_NyakuzaShop_6'] then
        local obj = Tracker:FindObjectForCode("@Nyakuza Shops/Green Clean Thug B/Scammed")
        local val = slot_data['Hat_NPC_NyakuzaShop_6']
        if obj then
            obj.AvailableChestCount = val
        end
    end

    if slot_data['Hat_NPC_NyakuzaShop_7'] then
        local obj = Tracker:FindObjectForCode("@Nyakuza Shops/Bluefin Tunnel Thug/Scammed")
        local val = slot_data['Hat_NPC_NyakuzaShop_7']
        if obj then
            obj.AvailableChestCount = val
        end
    end

    if slot_data['Hat_NPC_NyakuzaShop_12'] then
        local obj = Tracker:FindObjectForCode("@Nyakuza Shops/Pink Paw Station Thug/Scammed")
        local val = slot_data['Hat_NPC_NyakuzaShop_12']
        if obj then
            obj.AvailableChestCount = val
        end
    end

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

    -- there is an arguement that key and act should be swapped (i dont know if its worth it though)
    for key, act in pairs(chapter_act_info) do
        if act and slot_data[key] then
            act:setActName(slot_data[key])
--             act:setIsAccessible(false)
        end
    end

    updateActToEntrance()

    updateAccessibleLevelsByTimepieces()
end

function updateGalleryRiftAccessibility(timePieceCount, hasBrewer)
    local actAtGalleryRift = chapter_act_info["Spaceship_WaterRift_Gallery"]

    if hasBrewer == nil then
        hasBrewer = Tracker:FindObjectForCode("brewer").Active
    end

    if timePieceCount == nil then
        timePieceCount = Tracker:FindObjectForCode("timepiece").AcquiredCount
    end

--     actAtGalleryRift.isAccessible = timePieceCount >= chapter_costs[2] and hasBrewer
end

function updateLabRiftAccessibility(timePieceCount, hasDweller)
    -- The rift was moved to The Lab of the spaceship in an update.
    local actAtLabRift = chapter_act_info["Spaceship_WaterRift_MailRoom"]

    if hasDweller == nil then
        hasDweller = Tracker:FindObjectForCode("dweller").Active
    end

    if timePieceCount == nil then
        timePieceCount = Tracker:FindObjectForCode("timepiece").AcquiredCount
    end

--     actAtLabRift.isAccessible = timePieceCount >= chapter_costs[4] and hasDweller
end

function updateChapter7Accessibility(timePieceCount, hasDweller, hasIce)
--     local chapterCost = chapter_costs[7]
--     if chapterCost == nil then
--         -- DLC2 is disabled.
--         return
--     end
--
--     if hasIce == nil then
--         hasIce = Tracker:FindObjectForCode("ice").Active
--     end
--
--     if hasDweller == nil then
--         hasDweller = Tracker:FindObjectForCode("dweller").Active
--     end
--
--     if timePieceCount == nil then
--         timePieceCount = Tracker:FindObjectForCode("timepiece").AcquiredCount
--     end
--
--     local isAccessible = timePieceCount >= chapterCost and hasIce and hasDweller
--     for _, entrance in ipairs(chapter_to_entrances[7]) do
--         if entrance.act_requirements[1] ~= "" then
--             entrance.isAccessible = isAccessible
--         end
--     end
--
--     local bossEntrance = chapter_act_info.Metro_Escape
--     local bossEntranceLocation = Tracker:FindObjectForCode("@SpecialEntrances/Chapter7BossEntrance")
--     bossEntrance.isAccessible = bossEntranceLocation.AccessibilityLevel == AccessibilityLevel.Normal and isAccessible
end

-- Mysteryem: Alternatively, code watchers could be added for "brewer", "dweller" and "timepiece", that way, the code
--            will be run even when the user manually toggles a hat or adds/removes timepieces.
--unlock the rifts behind the chapter doors if you have the required item and time pieces
function updateSpaceShipRiftAccessibility()
--     local timePieceCount = Tracker:FindObjectForCode("timepiece").AcquiredCount
--     local brewer = Tracker:FindObjectForCode("brewer")
--     local dweller = Tracker:FindObjectForCode("dweller")
--
--     local chapter2Cost = chapter_costs[2]
--     if brewer.Active and chapter2Cost <= timePieceCount then
--         local actAtGalleryRift = chapter_act_info["Spaceship_WaterRift_Gallery"]
--         if not actAtGalleryRift.isAccessible then
--             print("Setting " .. actAtGalleryRift.act_name .. " at the Gallery Rift entrance as accessible")
--             actAtGalleryRift:setIsAccessible(true)
--         end
--     end
--
--     local chapter4Cost = chapter_costs[4]
--     if dweller.Active and chapter4Cost <= timePieceCount then
--         -- The rift was moved to The Lab of the spaceship in an update.
--         local actAtLabRift = chapter_act_info["Spaceship_WaterRift_MailRoom"]
--         if not actAtLabRift.isAccessible then
--             print("Setting " .. actAtLabRift.act_name .. " at the Lab Rift entrance as accessible")
--             actAtLabRift:setIsAccessible(true)
--         end
--     end
end

-- There's no explicit event on receiving hats so I fetched the hat order and cost
-- for each hat on Clear, then here I count how many yarn has been received
function updateYarn(yarn)
    count = yarn.AcquiredCount
    local timepieces = Tracker:FindObjectForCode("timepiece")
    --print("Yarn: "..(yarn.AcquiredCount))
    for k,v in ipairs(HatOrder) do
        for l,w in pairs(v) do
            local obj = Tracker:FindObjectForCode(l)
            if count >= w then
                if not obj.Active then
                    obj.Active = true
                    print("Activating hat " .. l .. " due to getting enough Yarn")
                    if l == "brewer" or l == "dweller" then
                        print("Checking spaceship rift accessibility from getting the " .. l .. " hat")
                        updateSpaceShipRiftAccessibility()
                    end
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
    -- should start disabled?
    -- add button to disable auto switching
    internal_map_name = map_table[current_map]
    
    if internal_map_name == nil then
        print("Could not find map name; Setting to Spaceship")
        internal_map_name = "Spaceship"
    end
    Tracker:UiHint("ActivateTab", internal_map_name)
end

--funky time
function updateAccessibleLevelsByTimepieces()
    local timepieces = Tracker:FindObjectForCode("timepiece")
    local ice = Tracker:FindObjectForCode("ice")
    local dweller = Tracker:FindObjectForCode("dweller")
    local chapters_to_keep = {}
    print(timepieces.AcquiredCount .. " timepieces")

    local locked_chapters = {}
    local unlocked_chapters = {}

    for chapter, cost in pairs(chapter_costs) do
        print (chapter .. ": " .. cost)
        -- Chapter 7, Nyakuza Metro requires both Ice Hat and Dweller Mask to access.
        if cost <= timepieces.AcquiredCount and (chapter ~= 7 or (ice.Active and dweller.Active)) then
            unlocked_chapters[chapter] = true
        else
            locked_chapters[chapter] = cost
        end
    end

    if unlocked_chapters[2] or unlocked_chapters[4] then
        --unlock the rifts behind the chapter doors if you have the required item and time pieces
        updateSpaceShipRiftAccessibility()
    end

    -- TODO: Time's End telescope/Tour Rift entrance requirements
    --if unlocked_chapters[5] then
    --    --Normal: Dweller + Brewing
    --    --Hard: Or Ice
    --    --Expert: Or Nothing?
    --end

    --unlock the intro levels if we meet the chapter cost and the act name isn't empty
--     for key, act in pairs(chapter_act_info) do
--         if unlocked_chapters[act.chapter] and act.act_requirements[1] == "intro" and act.act_name ~= "" then
--             act:setIsAccessible(true)
--             print(act.act_name .. " is accessible at location " .. key .. " due to timepiece count")
--         end
--     end

    local update = Tracker:FindObjectForCode("update")
    update.Active = not update.Active
end

function updateAccessibleLevelsByRelics(relic_type, relic_count)
--     local relic_chapter
--     local relic_chapter_number
--
--     --convert relic type to the internal chapter name only if we have the correct amount of relics
--     if relic_type == "burgerrelic" and relic_count >= 2 then
--         relic_chapter = "TimeRift_Cave_Mafia"
--         relic_chapter_number = 1
--     elseif relic_type == "trainrelic" and relic_count >= 2 then
--         relic_chapter = "TimeRift_Cave_BirdBasement"
--         relic_chapter_number = 2
--     elseif relic_type == "uforelic" and relic_count >= 4 then
--         relic_chapter = "TimeRift_Cave_Raccoon"
--         relic_chapter_number = 3
--     elseif relic_type == "crayonrelic" and relic_count >= 4 then
--         relic_chapter = "TimeRift_Cave_Alps"
--         relic_chapter_number = 4
--     elseif relic_type == "cakerelic" and relic_count >= 4 then
--         relic_chapter = "Cruise_CaveRift_Aquarium"
--         relic_chapter_number = 6
--     elseif relic_type == "jewelryrelic" and relic_count >= 4 then
--         relic_chapter = "Metro_CaveRift_RumbiFactory"
--         relic_chapter_number = 7
--     end
--
--     -- Funky stuff required for checking if you can reach the portal
--     -- TODO: Need to update the relic accessibility when we already have the relics and then unlock levels that can
--     --       access the
--     if relic_chapter then
--         local canAccess = false
--
--         for _, act in pairs(chapter_act_info) do
--             --chapters 2 and 6 rifts can only be accessed from one specific act
--             --chapter 3 rift has an act that makes it only accessible if on expert difficulty, otherwise it needs either painting shuffle to be off or on a specific stage or for the expert diffuclty to be enabled
--             --chapters 1, 4, and 7 can be accessed from any of their acts
--             if relic_chapter_number == 2 and (act.act_name == "DeadBirdStudio" or act.act_name == "chapter3_secret_finale") and act.isAccessible then
--                 canAccess = true
--                 break
--             elseif relic_chapter_number == 3 and act.chapter == relic_chapter_number and act.isAccessible then
--                 local paintings = Tracker:FindObjectForCode("paintings")
--                 local difficulty = Tracker:FindObjectForCode("difficulty")
--
--                 if (act.act_name == "snatcher_boss" and difficulty.CurrentStage == 4) or act.act_name ~= "snatcher_boss" then
--                     if paintings.CurrentStage == 0 or paintings.CurrentStage == 4 or difficulty.CurrentStage >= 0 then
--                         canAccess = true
--                     end
--                 end
--                 break
--             elseif relic_chapter_number == 6 and act.act_name == "Cruise_Boarding" and act.isAccessible then
--                 canAccess = true
--                 break
--             elseif act.isAccessible and act.chapter == relic_chapter_number then
--                 canAccess = true
--                 break
--             end
--
--         end
--
--         if canAccess then
--             chapter_act_info[relic_chapter]:setIsAccessible(true)
--             print(chapter_act_info[relic_chapter]:getActName() .. " is accessible at location " .. relic_chapter .. " due to relics")
--         end
--     end

    local update = Tracker:FindObjectForCode("update")
    update.Active = not update.Active
end

function updateAccessibleLevelsByCompletedLevels(completed_acts)
--     local chapter_counts = {
--         [1] = 0,
--         [2] = 0,
--         [3] = 0,
--         [6] = 0
--     }
--     for key, act in pairs(chapter_act_info) do
--         if act.act_name ~= "" then
--             local allRequirementsMet = true
--
--             if act.act_requirements and act.act_requirements[1] ~= "" then
--                 for _, act_requirement in ipairs(act.act_requirements) do
--                     --handle normal level unlocks
--                     if act:getActRequirements() and not containsItem(completed_acts, act_requirement) then
--                         allRequirementsMet = false
--                         break
--                     end
--                 end
--
--                 if allRequirementsMet and act and not act:getIsAccessible() then
--                     act:setIsAccessible(true)
--                     print(act.act_name .. " is accessible at location " .. key .. " due to level completion")
--                 end
--             end
--
--             --increase completion amounts of chapters for time rifts
--             if act.chapter and act.act_name and completed_acts then
--                 for _, completed_act in pairs(completed_acts) do
--                     if act.act_name == completed_act then
--                         if chapter_counts[act.chapter] then
--                             chapter_counts[act.chapter] = chapter_counts[act.chapter] + 1
--                         end
--                     end
--                 end
--             end
--
--             --check if rift requirements are met
--             if act.isAccessible and act.chapter == 1 then
--                 if chapter_counts[1] >= 6 then
--                     chapter_act_info["TimeRift_Water_Mafia_Hard"]:setIsAccessible(true)
--                 elseif chapter_counts[1] >= 4 then
--                     chapter_act_info["TimeRift_Water_Mafia_Easy"]:setIsAccessible(true)
--                 end
--             end
--
--             if chapter_counts[2] >= 3 and act.isAccessible and act.act_name == "chapter3_murder" then
--                 chapter_act_info["TimeRift_Water_TWreck_Panels"]:setIsAccessible(true)
--             end
--
--             if chapter_counts[2] >= 5 and act.isAccessible and (act.act_name == "moon_camerasnap" or act.act_name == "moon_parade") then
--                 chapter_act_info["TimeRift_Water_TWreck_Parade"]:setIsAccessible(true)
--             end
--
--             local paintings = Tracker:FindObjectForCode("paintings")
--             local difficulty = Tracker:FindObjectForCode("difficulty")
--
--             if (act.act_name == "snatcher_boss" and difficulty.CurrentStage == 4) or (act.act_name ~= "snatcher_boss" and act.chapter == 3) and act.isAccessible then
--                 if chapter_counts[3] >= 3 and (paintings.CurrentStage == 0 or paintings.CurrentStage == 2 or difficulty.CurrentStage >= 0)  then
--                     chapter_act_info["TimeRift_Water_Subcon_Hookshot"]:setIsAccessible(true)
--                 end
--
--                 if chapter_counts[3] >= 5 and (paintings.CurrentStage == 0 or paintings.CurrentStage == 4 or difficulty.CurrentStage >= 0)  then
--                     chapter_act_info["TimeRift_Water_Subcon_Dwellers"]:setIsAccessible(true)
--                 end
--             end
--
--             if chapter_counts[6] >= 2 and act.isAccessible and act.act_name == "Cruise_Boarding" then
--                 chapter_act_info["Cruise_WaterRift_Slide"]:setIsAccessible(true)
--             end
--         end
--     end
--
--     local update = Tracker:FindObjectForCode("update")
--     update.Active = not update.Active
end

--Handles the unique finale conditions for chapter 4 and 7
function updateAccessibleLevelsByFinale(chapter)
--     local chapter_to_check
--     local finale
--
--     if chapter == 4 then
--         chapter_to_check = apline_timepieces
--         finale = "AlpineSkyline_Finale"
--     elseif chapter == 7 then
--         chapter_to_check = nyakuza_timepieces
--         finale = "Metro_Escape"
--     end
--
--     for _, timepiece in pairs(chapter_to_check) do
--         local obj = Tracker:FindObjectForCode(timepiece)
--         if obj.AvailableChestCount > 0 then
--             print("Found uncollected time piece at " .. timepiece)
--             return
--         end
--     end
--
--     chapter_act_info[finale]:setIsAccessible(true)

    local update = Tracker:FindObjectForCode("update")
    update.Active = not update.Active
end

function updateAccessibleLevelsByContract(contract)
--     local contract_act
--
--     if string.find(contract, "The Subcon Well") then
--         contract_act = "subcon_cave"
--     elseif string.find(contract, "Toilet of Doom") then
--         contract_act = "chapter2_toiletboss"
--     elseif string.find(contract, "Queen Vanessa's Manor") then
--         contract_act = "vanessa_manor_attic"
--     elseif string.find(contract, "Mail Delivery Service") then
--         contract_act = "subcon_maildelivery"
--     end
--
--     chapter_act_info[completed_act]:setIsAccessible(true)

    local update = Tracker:FindObjectForCode("update")
    update.Active = not update.Active
end

--Tracker Handlers

function onItem(index, item_id, item_name, player_number)
    if index <= CUR_INDEX then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index;
    local v = ITEM_MAPPING[item_id]
    if not v or not v[1] then
        --print(string.format("onItem: could not find item mapping for id %s", item_id))
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[2] == "toggle" then
            obj.Active = true
            if string.find(v[1], "Contract") then
                updateAccessibleLevelsByContract(v[1])
            elseif v[1] == 'dweller' or v[1] == 'brewing' then
                -- Acquiring
                updateSpaceShipRiftAccessibility()
            end
        elseif v[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
            if v[1] == 'yarn' then --extra handling for hat autotracking
                updateYarn(obj)
            elseif v[1] == 'timepiece' then
                updateAccessibleLevelsByTimepieces()
            elseif string.find(v[1], "relic") then
                updateAccessibleLevelsByRelics(v[1], obj.AcquiredCount)
            end
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: unknown item type %s for code %s", v[2], v[1]))
        end
        --print("onItem: Updated item check "..v[1])
    else
        print(string.format("onItem: could not find object for code %s", v[1]))
    end
end

--called when a location gets cleared
function onLocation(location_id, location_name)
    local v = LOCATION_MAPPING[location_id]
    if not v or not v[1] then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])

    --handle check for rush hour
    if containsItem(apline_timepieces, v[1]) then
        updateAccessibleLevelsByFinale(4)
    elseif containsItem(nyakuza_timepieces, v[1]) then
        updateAccessibleLevelsByFinale(7)
    end

    if obj then
        if v[1]:sub(1, 1) == "@" then
            obj.AvailableChestCount = obj.AvailableChestCount - 1
        else
            obj.Active = true
        end
        --print("onLocation: checked spot "..v[1])
    else
        print(string.format("onLocation: could not find object for code %s", v[1]))
    end
end

function onEvent(key, new_value, old_value)
    if key == map_key then
        changedMap(new_value, old_value)
    elseif key == completed_acts_key then
        updateAccessibleLevelsByCompletedLevels(new_value)
    end
end

Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddRetrievedHandler("event handler", onEvent)
Archipelago:AddSetReplyHandler("event launch handler", onEvent)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
