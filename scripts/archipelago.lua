require("objects/chapter_info")

ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

CUR_INDEX = -1
--SLOT_DATA = nil

-- Setup for auto map switching
local map_table = {
    hub_spaceship = "Spaceship",
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
    timerift_cave_birdbasement = "Dead Bird Studio",
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

    -- Reset completed entrances
    completed_entrances = {}

    for _, v in pairs(chapter_act_info) do
        v:clearCompletion()
    end

    -- reset locations
    for _, v in pairs(LOCATION_MAPPING) do
        local obj = Tracker:FindObjectForCode(v)
        if obj then
            obj.AvailableChestCount = obj.ChestCount
        else
            print(string.format("onClear: Could not find location '%s'", v))
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

    -- Enable DLC relics depending on which DLCs are enabled.
    -- The DLC relics have an extra initial stage that displays a lock icon. Increase the stage to show the default icon
    -- for relics that have not been acquired yet.
    if Tracker:FindObjectForCode("dlc1").Active then
        local cake_relic = Tracker:FindObjectForCode("cakerelic")
        cake_relic.CurrentStage = cake_relic.CurrentStage + 1
    end
    if Tracker:FindObjectForCode("dlc2").Active then
        local jewelry_relic = Tracker:FindObjectForCode("jewelryrelic")
        jewelry_relic.CurrentStage = jewelry_relic.CurrentStage + 1
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
    -- should start disabled?
    -- add button to disable auto switching
    internal_map_name = map_table[current_map]
    
    if internal_map_name == nil then
        print(string.format("Could not find map name %s; Setting to Spaceship", current_map))
        internal_map_name = "Spaceship"
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
            else
                -- Most likely, it is an act within a free roam act, so has no chapter_act_info entry.
                -- Clear the entrance that has a free roam act if all of the free roam's acts have been completed.
                if nyakuza_free_roam_act_names[entrance_name] then
                    tryCompleteEntranceWithFreeRoamAct("MetroFreeRoam", nyakuza_free_roam_act_names)
                elseif alpine_free_roam_act_names[entrance_name] then
                    tryCompleteEntranceWithFreeRoamAct("AlpineFreeRoam", alpine_free_roam_act_names)
                end
                --print("Player has completed the act at entrance '" .. entrance_name .. "'")
            end
        else
            --print("Player has re-completed the act at entrance '" .. entrance_name .. "'")
        end
    end

    if new_completions then
        forceUpdate()
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
    end
end

Archipelago:AddClearHandler("clear handler", onClearHandler)
Archipelago:AddRetrievedHandler("event handler", onEvent)
Archipelago:AddSetReplyHandler("event launch handler", onEvent)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
