require("objects/chapter_info")

ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

CUR_INDEX = -1
--SLOT_DATA = nil

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

    -- Reset completed entrances
    completed_entrances = {}

    for _, v in pairs(chapter_act_info) do
        local entrance_location = Tracker:FindObjectForCode(v.entrance_location_section)
        if entrance_location then
            entrance_location.AvailableChestCount = entrance_location.ChestCount
        else
            print(string.format("onClear: Could not find entrance location '%s'", v.entrance_location_section))
        end
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

    forceUpdate()
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
    -- should start disabled?
    -- add button to disable auto switching
    internal_map_name = map_table[current_map]
    
    if internal_map_name == nil then
        print("Could not find map name; Setting to Spaceship")
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

    -- Clear the location of the entrance whose act is `act_name`.
    local entrance_with_free_roam_act = getActInfo(act_name)
    local entrance_loc = Tracker:FindObjectForCode(entrance_with_free_roam_act.entrance_location_section)
    entrance_loc.AvailableChestCount = entrance_loc.AvailableChestCount - 1
end

function changedCompletedEntrances(current, previous)
    local new_completions = false

    -- todo: Find out if `current` is guaranteed to be the same as `previous` but with extra elements. Then the
    --       iteration could skip immediately to the new elements. Note that `previous` is initially `nil` at the start.
    for _, entrance_name in ipairs(current) do
        if completed_entrances[entrance_name] == nil then
            new_completions = true
            completed_entrances[entrance_name] = true
            entrance = chapter_act_info[entrance_name]
            if entrance then
                local entrance_loc = Tracker:FindObjectForCode(entrance.entrance_location_section)
                entrance_loc.AvailableChestCount = entrance_loc.AvailableChestCount - 1
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
    if not v then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
        return
    end
    local obj = Tracker:FindObjectForCode(v)

    if obj then
        if v:sub(1, 1) == "@" then
            obj.AvailableChestCount = obj.AvailableChestCount - 1
        else
            obj.Active = true
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

Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddRetrievedHandler("event handler", onEvent)
Archipelago:AddSetReplyHandler("event launch handler", onEvent)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
