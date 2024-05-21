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

function canAccessAct(act_to_access)
  local act_info = getActInfo(act_to_access)
  local location = act_info:getCanEnterSection()
  local entrance_accessibility = location.AccessibilityLevel
  return entrance_accessibility == AccessibilityLevel.Normal or entrance_accessibility == AccessibilityLevel.Cleared
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

-- Return if the act at the entrance has been completed (AccessibilityLevel.Cleared).
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
        local entrance_section = entrance_info:getCanEnterSection()
        local entrance_accessibility = entrance_section.AccessibilityLevel
        return entrance_accessibility == AccessibilityLevel.Normal or entrance_accessibility == AccessibilityLevel.Cleared
    end

    if not isApConnected() then
        -- With no AP connection, check the Time Piece location. Note that checking locations manually does not update
        -- logic and that if any Time Pieces were !collect-ed then the logic may end up incorrect if the act has not
        -- actually been completed.
        if act_at_entrance.vanilla_act_completion_location_section == nil then
            -- Free roam act
            return true
        end
        local completion_location = Tracker:FindObjectForCode(act_at_entrance.vanilla_act_completion_location_section)
        return completion_location.AccessibilityLevel == AccessibilityLevel.Cleared
    end

    --
    -- archipelago.lua updates the global set of completed entrances
    if completed_entrances[entrance] ~= nil then
        return true
    else
        -- Note: This workaround is unused because there is currently no reason to check for having completed the act at
        -- either the Alpine Free Roam entrance, the Nyakuza Metro Free Roam entrance or the Rush Hour entrance.
        --
        -- Workaround for bug in AHIT-APRandomizer Mod:
        -- Free roam entrances and the Rush Hour entrance receive `""` as the act completion from archipelago when
        -- completing the act at that location, so get the time piece for the act's location and check if it's been
        -- cleared instead.
        if entrance_info.vanilla_act_completion_location_section == nil or entrance == "Metro_Escape" then
            if completed_entrances[""] == nil then
                -- If no entrance that reports itself as `""` has been completed, then we can be sure that the act at
                -- this entrance has not been completed.
                -- TODO: If DLC2 is disabled then we can be sure that `""` is always completion of the act at Alpine
                --       Skyline free roam.
                return false
            else
                -- Get the act completion time piece for the act at the entrance and return if the time piece location
                -- has been cleared.
                local completion_location = Tracker:FindObjectForCode(act_at_entrance.vanilla_act_completion_location_section)
                return completion_location.AccessibilityLevel == AccessibilityLevel.Cleared
            end
        end

        return false
    end
end

function canCompleteActAt(entrance, check_entrance, skip_free_roam_sub_acts)
    local entrance_info = chapter_act_info[entrance]

    if check_entrance then
        -- Check if the entrance is accessible.
        local entrance_location = entrance_info:getCanEnterSection()
        local entrance_accessibility = entrance_location.AccessibilityLevel
        if entrance_accessibility ~= AccessibilityLevel.Normal and entrance_accessibility ~= AccessibilityLevel.Cleared then
            return false
        end
    end

    -- Now check if the act at the entrance is beatable.
    local act_at_entrance_name = entrance_info.act_name
    local act_at_entrance = chapter_act_info[act_at_entrance_name]
    local completion_location_section = act_at_entrance.vanilla_act_completion_location_section

    -- Free roam acts have no act completion location and are always considered 'complete' even if not all of their Time
    -- Pieces have been acquired.
    if completion_location_section == nil and skip_free_roam_sub_acts then
        return true
    end

    -- Check the accessibility of the location defined in locations/logic/act_completion.json.
    local completion_location_name = "@internal_can_complete_act/" .. act_at_entrance_name
    local completion_location = Tracker:FindObjectForCode(completion_location_name)
    return completion_location.AccessibilityLevel == AccessibilityLevel.Normal
end