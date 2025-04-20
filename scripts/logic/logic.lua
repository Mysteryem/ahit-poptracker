require("scripts/objects/chapter_info")

-- function has(item, amount)
--   local count = Tracker:ProviderCountForCode(item)
--   amount = tonumber(amount)
--   if not amount then
--     return count > 0
--   else
--     return count >= amount
--   end
-- end

function isApConnected()
  if AutoTracker:GetConnectionState("AP") == 3 then
    return true
  else
    return false
  end
end

-- Currently unused. May be needed for no-act-rando in the future.
local ACCESSIBILITY_VALUES = {
    [AccessibilityLevel.None] = 0,
    [AccessibilityLevel.Inspect] = 1,
    [AccessibilityLevel.Partial] = 2, -- Not really useful
    [AccessibilityLevel.SequenceBreak] = 3,
    [AccessibilityLevel.Normal] = 4,
    [AccessibilityLevel.Cleared] = 5, -- Not really useful
}
local ACCESSIBILITY_VALUES_REVERSE = {}
for accessibility_level, value in pairs(ACCESSIBILITY_VALUES) do
    ACCESSIBILITY_VALUES_REVERSE[value] = accessibility_level
end

-- Currently unused. May be needed for no-act-rando in the future.
function combineAccessibility(...)
    -- Start at 'Normal'
    local current_accessibility_value = 4
    for _, accessibility_level in ipairs(arg) do
        local accessibility_value = ACCESSIBILITY_VALUES[v]
        if accessibility_value == 0 then
            -- Can't get lower than 'None', so return early.
            return AccessibilityLevel.None
        elseif accessibility_value < current_accessibility_value then
            current_accessibility_value = accessibility_value
        end
    end
    return ACCESSIBILITY_VALUES_REVERSE[current_accessibility_value]
end

function canAccessAct(act_to_access)
    local act_info = getActInfo(act_to_access)
    return act_info:getEntranceAccessibility()
end

function hasTimePiecesForChapter(chapter_to_access)
    local timePieces = Tracker:FindObjectForCode("timepiece")
    return timePieces.AcquiredCount >= chapter_costs[tonumber(chapter_to_access)]
end

-- Only used when there is no AP connection, mainly for debugging logic.
free_roam_act_to_time_piece = {
    Metro_RouteA = "@Nyakuza Metro/Yellow Overpass Station/Time Piece",
    Metro_RouteB = "@Nyakuza Metro/Green Clean Station/Time Piece",
    Metro_RouteC = "@Nyakuza Metro/Bluefin Tunnel/Time Piece",
    Metro_RouteD = "@Nyakuza Metro/Pink Paw Station/Time Piece",
    Metro_ManholeA = "@Nyakuza Metro/Yellow Overpass Manhole/Time Piece",
    Metro_ManholeB = "@Nyakuza Metro/Green Clean Manhole/Time Piece",
    Metro_ManholeC = "@Nyakuza Metro/Pink Paw Manhole/Time Piece",
    Alpine_Twilight = "@Twilight Bell Zipline/The Twilight Bell/Time Piece",
    Alps_Birdhouse = "@Birdhouse Zipline/Bird House/Time Piece",
    AlpineSkyline_Windmill = "@Windmill Zipline/The Windmill/Time Piece",
    AlpineSkyline_WeddingCake = "@Lava Cake Zipline/Lava Cake/Time Piece",
}

function completedNyakuzaFreeRoamActs()
    local ap_connected = isApConnected()
    for act_name, _ in pairs(nyakuza_free_roam_act_names) do
        if not completedFreeRoamAct(act_name, ap_connected) then
            return false
        end
    end

    return true
end

function completedAlpineFreeRoamActs()
    local ap_connected = isApConnected()
    for act_name, _ in pairs(alpine_free_roam_act_names) do
        if not completedFreeRoamAct(act_name, ap_connected) then
            return false
        end
    end

    return true
end

function completedFreeRoamAct(act_name, ap_connected)
    if ap_connected == nil then
        ap_connected = isApConnected()
    end
    if not ap_connected then
        -- With no AP connection, check the Time Piece location. Note that checking locations manually does not update
        -- logic and that if any Time Pieces were !collect-ed then the logic may end up incorrect if the act has not
        -- actually been completed.
        local time_piece_location = Tracker:FindObjectForCode(free_roam_act_to_time_piece[act_name])
        return time_piece_location.AccessibilityLevel == AccessibilityLevel.Cleared
    end
    return completed_entrances[act_name] ~= nil
end

-- Return if the act at the entrance has been completed (AccessibilityLevel.Cleared, but accounting for !collect).
-- This is used because a player using act randomization won't know what new act/rift will unlock after they complete an
-- act, so the tracker should not display the act/rift that will unlock as accessible until the player has beaten the
-- act.
-- DISABLED PENDING FEEDBACK
---- When act randomization is disabled, the player knows what act/rift will unlock, so then this function returns whether
---- the act at the entrance can be completed instead.
function completedActAt(entrance)
    -- DISABLED PENDING FEEDBACK
--     if not act_rando_enabled then
--         -- The player knows which acts are where in advance when there is no act rando, so the tracker should know too.
--         return canCompleteActAt(entrance, true, true)
--     end
    local entrance_info = chapter_act_info[entrance]

    local act_at_entrance = chapter_act_info[entrance_info.act_name]
    local completion_location_section = act_at_entrance.vanilla_act_completion_location_section

    -- Free roam acts have no act completion location and are always considered complete when their entrance is
    -- accessible.
    if completion_location_section == nil then
        local entrance_location = entrance_info:getEntranceLocation()
        return entrance_location.AccessibilityLevel
    end

    if not isApConnected() then
        -- With no AP connection, check the Time Piece location. Note that checking locations manually does not update
        -- logic and that if any Time Pieces were !collect-ed then the logic may end up incorrect if the act has not
        -- actually been completed.
        local completion_location = Tracker:FindObjectForCode(act_at_entrance.vanilla_act_completion_location_section)
        return completion_location.AccessibilityLevel
    end

    --
    -- archipelago.lua updates the global set of completed entrances
    if completed_entrances[entrance] ~= nil then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.None
    end
end

-- If a checkable rule resolves to SequenceBreak, then it displays as yellow instead of either red or blue that would
-- normally be expected (there's no color for checkable + sequence break because you cannot have both at the same time).
function checkCompletedActAt(entrance)
    local accessibility = completedActAt(entrance)
    -- SequenceBreak can occur when the act at the entrance is a free roam because then the accessibility is retrieved
    -- from the entrance. If the entrance was unlocked out-of-logic, then it returns SequenceBreak so that all the
    -- locations accessible from the act at the entrance show as yellow instead of green (if there is no alternate
    -- in-logic way to access the locations).
    if accessibility == AccessibilityLevel.SequenceBreak then
        return true
    else
        return accessibility == AccessibilityLevel.Normal
    end
end

-- Note: the check_entrance and skip_free_roam_sub_acts arguments are currently unused.
function canCompleteActAt(entrance, check_entrance, skip_free_roam_sub_acts)
    local entrance_info = chapter_act_info[entrance]

    local entrance_accessibility
    if check_entrance then
        -- Check if the entrance is accessible.
        entrance_accessibility = entrance_info:getEntranceAccessibility()
    end

    -- Now check if the act at the entrance is beatable.
    local act_at_entrance_name = entrance_info.act_name

    -- Free roam acts have no act completion location and are always considered 'complete' even if not all of their Time
    -- Pieces have been acquired.
    if skip_free_roam_sub_acts then
        local act_at_entrance = chapter_act_info[act_at_entrance_name]
        local completion_location_section = act_at_entrance.vanilla_act_completion_location_section
        if completion_location_section == nil then
            -- The act at the entrance is a free roam act if it has no vanilla act completion section.
            if check_entrance then
                return entrance_accessibility
            else
                return AccessibilityLevel.Normal
            end
        end
    end

    -- Check the accessibility of the location defined in locations/logic/act_completion.json.
    local completion_location_name = "@internal_can_complete_act/" .. act_at_entrance_name
    local completion_location = Tracker:FindObjectForCode(completion_location_name)
    if check_entrance then
        return combineAccessibility(completion_location.AccessibilityLevel, entrance_accessibility)
    else
        return completion_location.AccessibilityLevel
    end
end

-- Check whether an act entrance in a telescope can logically be marked as completed.
-- Free Roam acts are automatically marked as completed once unlocked, allowing for later acts within a telescope to be
-- unlocked without having to complete every act within the Free Roam.
-- The exception to this is Time Rift entrances, which are never automatically marked as completed because completed
-- Time Rift entrances can be entered directly from the telescope, without needing to find and enter the Time Rift
-- itself. There are no act entrances that are unlocked after completing an act at a Time Rift, so this exception is
-- irrelevant to the tracker.
function canCompleteActOrIsFreeRoamAt(entrance, check_entrance)
    return canCompleteActAt(entrance, check_entrance, true)
end