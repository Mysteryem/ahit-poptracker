require("objects/chapter_info")

ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

CUR_INDEX = -1
--SLOT_DATA = nil

-- Locations for time pieces that need to be collected to unlock entrances.
-- Clearing these locations must cause the tracker to update its logic.
-- The initial set of locations are accessed through a free roam act, so do not get randomized.
local unlock_timepieces = {
    -- Chapter 4 boss entrance unlock and Chapter 4 Time rift unlocks
    ["@Birdhouse Zipline/Bird House/Time Piece"] = true,
    ["@Lava Cake Zipline/Lava Cake/Time Piece"] = true,
    ["@Twilight Bell Zipline/The Twilight Bell/Time Piece"] = true, -- Also unlocks a Time Rift entrance
    ["@Windmill Zipline/The Windmill/Time Piece"] = true, -- Also unlocks a Time Rift entrance
    -- Chapter 7 boss entrance unlock
    -- The intro is not technically required
    ["@Nyakuza Metro/Nyakuza Metro Intro/Time Piece"] = true,
    ["@Nyakuza Metro/Yellow Overpass Station/Time Piece"] = true,
    ["@Nyakuza Metro/Yellow Overpass Manhole/Time Piece"] = true,
    ["@Nyakuza Metro/Green Clean Station/Time Piece"] = true,
    ["@Nyakuza Metro/Green Clean Manhole/Time Piece"] = true,
    ["@Nyakuza Metro/Bluefin Tunnel/Time Piece"] = true,
    ["@Nyakuza Metro/Pink Paw Station/Time Piece"] = true,
    ["@Nyakuza Metro/Pink Paw Manhole/Time Piece"] = true,
}
-- Add all the act completion locations of acts that can be randomized.
for _, v in pairs(chapter_act_info) do
    local act_completion_location = v.vanilla_act_completion_location_section
    -- Free roam acts have no completion location.
    if act_completion_location ~= nil then
        -- Add the location.
        unlock_timepieces[act_completion_location] = true
    end
end

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
            -- TODO: Are these forceUpdates necessary? Doesn't receiving and toggling/incrementing the item cause an
            --       update?
            if string.find(v[1], "Contract") then
                -- Contracts unlock entrances of Chapter 3 Acts
                forceUpdate()
            elseif v[1] == 'dweller' or v[1] == 'brewer' then
                -- Dweller/brewer may unlock Lab/Gallery entrances
                forceUpdate()
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
                -- Getting timepieces may unlock entrances behind chapter doors
                forceUpdate()
            elseif string.find(v[1], "relic") then
                -- Relics may unlock entrances of Purple Time Rifts
                forceUpdate()
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

    -- Trigger an update if the location is an act completion location because it could result in an entrance becoming
    -- accessible.
    if unlock_timepieces[v] then
        forceUpdate()
    end
end

function onEvent(key, new_value, old_value)
    if key == map_key then
        changedMap(new_value, old_value)
    elseif key == completed_acts_key then
        forceUpdate()
    end
end

Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddRetrievedHandler("event handler", onEvent)
Archipelago:AddSetReplyHandler("event launch handler", onEvent)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
