require("scripts/objects/chapter_info")

function has(item, amount)
  local count = Tracker:ProviderCountForCode(item)
  amount = tonumber(amount)
  if not amount then
    return count > 0
  else
    return count >= amount
  end
end

function canAccessMainSubcon()
  local difficulty = Tracker:FindObjectForCode("difficulty")

  for vanilla_act_name, act_info in pairs(chapter_act_info) do
    -- Expert difficult can Cherry Hover out of the boss area.
    if act_info.chapter == 3 and (vanilla_act_name ~= "snatcher_boss" or difficulty.CurrentStage == 3) and canAccessAct(vanilla_act_name) then
        return true
    end
  end

  return false
end

-- An optional exception act name can be specified. This is used for the Mafia Geek Platform location, which is present
-- in every Chapter 1 Act except She Came from Outer Space.
function canAccessChapter(chapter_to_access, exception)
  local chapter = tonumber(chapter_to_access)
  for _, vanilla_act_name in ipairs(chapter_entrance_names[chapter]) do
    if vanilla_act_name ~= exception and canAccessAct(vanilla_act_name) then
        return true
    end
  end

  return false
end

function canAccessAct(act_to_access)
  local act_info = getActInfo(act_to_access)
  local location = Tracker:FindObjectForCode(act_info.entrance_location_section)
  local entrance_accessibility = location.AccessibilityLevel
  return entrance_accessibility == AccessibilityLevel.Normal or entrance_accessibility == AccessibilityLevel.Cleared
end

function hasTimePiecesForChapter(chapter_to_access)
    local timePieces = Tracker:FindObjectForCode("timepiece")
    return timePieces.AcquiredCount >= chapter_costs[tonumber(chapter_to_access)]
end

-- todo: If AP is disabled, should we get act completion state from locations instead?
function completedNyakuzaFreeRoamActs()
    for act_name, _ in pairs(nyakuza_free_roam_act_names) do
        if completed_entrances[act_name] == nil then
            return false
        end
    end

    return true
end

-- todo: If AP is disabled, should we get act completion state from locations instead?
function completedAlpineFreeRoamActs()
    for act_name, _ in pairs(alpine_free_roam_act_names) do
        if completed_entrances[act_name] == nil then
            return false
        end
    end

    return true
end

function completedFreeRoamAct(act_name)
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
--         return canCompleteActAt(entrance)
--     end
    local entrance_info = chapter_act_info[entrance]

    local act_at_entrance = chapter_act_info[entrance_info.act_name]
    local completion_location_section = act_at_entrance.vanilla_act_completion_location_section

    -- Free roam acts have no act completion location and are always considered complete.
    if completion_location_section == nil then
        return true
    end

    -- todo: If AP is disabled, should we get act completion state from location instead?
    --
    -- archipelago.lua updates the global set of completed entrances
    if completed_entrances[entrance] ~= nil then
        return true
    else
        -- Note: This workaround is unused because there is currently no reason to check for having completed the act at
        -- either the Alpine Free Roam entrance or the Nyakuza Metro Free Roam entrance.
        -- Workaround for bug in AHIT-APRandomizer Mod:
        -- Free roam entrances receive `""` as the act completion from archipelago, so get the time piece for the act's
        -- location and check if it's been cleared instead.
        if entrance_info.vanilla_act_completion_location_section == nil then
            if completed_entrances[""] == nil then
                -- If no act at a free roam entrance has been completed, then we can be sure that the act at this free
                -- roam entrance has not been completed.
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

function canCompleteActAt(entrance)
    local entrance_info = chapter_act_info[entrance]

    -- TODO: Instead of checking the entrance accessibility here, we could instead include the checks in the .json:
    --   `$canCompleteActAt|chapter3_murder,$canCompleteActAt|moon_camerasnap`
    -- becomes
    --   `"@Chapter2 Entrances/Acts/chapter3_murder,@Chapter2 Entrances/Acts/moon_camerasnap,$canCompleteActAt|chapter3_murder,$canCompleteActAt|moon_camerasnap"`
    -- Which would be more performant?

    -- First check if the entrance is accessible.
    local entrance_location = Tracker:FindObjectForCode(entrance_info.entrance_location_section)
    local entrance_accessibility = entrance_location.AccessibilityLevel
    if entrance_accessibility ~= AccessibilityLevel.Normal and entrance_accessibility ~= AccessibilityLevel.Cleared then
        return false
    end

    -- Now check if the act at the entrance is beatable.
    local act_at_entrance = chapter_act_info[entrance_info.act_name]
    local completion_location_section = act_at_entrance.vanilla_act_completion_location_section

    -- Free roam acts have no act completion location and are always considered complete.
    if completion_location_section == nil then
        return true
    end

    local completion_location = Tracker:FindObjectForCode(act_at_entrance.vanilla_act_completion_location_section)
    -- TODO: Can we prefix the function use with "^" and then return an AccessibilityLevel constant directly?
    --       What about when there is other logic to be considered, such as subcon paintings?
    local completion_accessibility = completion_location.AccessibilityLevel
    return completion_accessibility == AccessibilityLevel.Normal or completion_accessibility == AccessibilityLevel.Cleared
end