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

    local completion_location = Tracker:FindObjectForCode(act_at_entrance.vanilla_act_completion_location_section)
    -- TODO: Can we prefix the function use with "^" and then return an AccessibilityLevel constant directly?
    --       What about when there are other logic conditions to be considered, such as subcon paintings?
    local completion_accessibility = completion_location.AccessibilityLevel
    return completion_accessibility == AccessibilityLevel.Cleared
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

function hasClearedLocation(location_name)
    local loc = Tracker:FindObjectForCode(location_name)
    return loc.AccessibilityLevel == AccessibilityLevel.Cleared
end