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

function isApConnected()
  if AutoTracker:GetConnectionState("AP") == 3 then
    return true
  else
    return false
  end
end

function canAccessMainSubcon()
  if not isApConnected() then
    return true
  end

  local difficulty = Tracker:FindObjectForCode("difficulty")

  for vanilla_act_name, act_info in pairs(chapter_act_info) do
    -- Expert difficult can Cherry Hover out of the boss area.
    if act_info.chapter == 3 and (vanilla_act_name ~= "snatcher_boss" or difficulty.CurrentStage == 3) and canAccessAct(vanilla_act_name) then
        return true
    end
  end

  return false
end


function canAccessChapter(chapter_to_access, exception)
  if not isApConnected() then
    return true
  end

  if not exception then
    exception = ""
  end

  local chapter = tonumber(chapter_to_access)
  for vanilla_act_name, act_info in pairs(chapter_act_info) do
    if act_info.chapter == chapter and canAccessAct(vanilla_act_name) then
        return true
    end
  end

  return false
end

function canAccessAct(act_to_access)
  if not isApConnected() then
    return true
  end

  local act_info = getActInfo(act_to_access)
  local location = Tracker:FindObjectForCode(act_info.entrance_location_section)
  local entrance_accessibility = location.AccessibilityLevel
  return entrance_accessibility == AccessibilityLevel.Normal or entrance_accessibility == AccessibilityLevel.Cleared
end

function canAccessAnyAct(...)
    for _, v in ipairs(arg) do
        if canAccessAct(v) then
            return true
        end
    end
    return false
end

function hasTimePiecesForChapter(chapter_to_access)
    local timePieces = Tracker:FindObjectForCode("timepiece")
    return timePieces.AcquiredCount >= chapter_costs[tonumber(chapter_to_access)]
end

function completedActAt(entrance)
    if not act_rando_enabled then
        -- The player knows which acts are where in advance when there is no act rando, so the tracker should know too.
        return canCompleteActAt(entrance)
    end
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

-- Boss chapters don't show up until an act in the chapter has been beaten.
function completedAnyActsAt(...)
    for _, v in ipairs(arg) do
        if completedActAt(v) then
            return true
        end
    end
    return false
end

-- Some act entrances requiring beating multiple other acts to show up.
function completedAllActsAt(...)
    for _, v in ipairs(arg) do
        if not completedActAt(v) then
            return false
        end
    end
    return true
end

-- TODO: Instead of *can* beat act, keep a table of beaten acts as the messages for beating acts are received from AP,
--       that way, the accessible locations should open up more naturally.
--       ALTERNATIVE: (temporarily enabled) Only return `entrance_accessibility == AccessibilityLevel.Cleared` and not `AccessibilityLevel.Normal`?
function canCompleteActAt(entrance)
--     if act_rando_enabled then
--         return completedActAt(entrance)
--     end
    local entrance_info = chapter_act_info[entrance]

    -- TODO: When act rando is enabled, only check beaten acts, when act rando is disabled, instead check if the act
    --       can be beaten. Even with act rando, boss acts should check if the act at the chapter intro *has* been
    --       beaten and that the acts at the other entrances *can* be beaten (that the entrances are accessible and that
    --       the acts can be beaten) because Boss entrances show up after beating the a single act in that chapter
    --       (usually the intro act because that's the only initially accessible act, but Subcon can occur in any order
    --       due to contract shuffle)
    -- TODO: Instead of checking the entrance accessibility here, we could instead include the checks in the .json:
    --   `$canBeatActsAt|chapter3_murder|moon_camerasnap`
    -- becomes
    --   `"@Chapter2 Entrances/Acts/chapter3_murder,@Chapter2 Entrances/Acts/moon_camerasnap,$canBeatActsAt|chapter3_murder|moon_camerasnap"`
    -- Which would be more performant?
    -- First check if the entrance is accessible.
    local entrance_location = Tracker:FindObjectForCode(entrance_info.entrance_location_section)
    local entrance_accessibility = entrance_location.AccessibilityLevel
    if entrance_accessibility ~= AccessibilityLevel.Normal or entrance_accessibility ~= AccessibilityLevel.Cleared then
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
--     return completion_accessibility == AccessibilityLevel.Cleared
end

function canCompleteActsAt(...)
    for _, v in ipairs(arg) do
        if not canCompleteActAt(v) then
            return false
        end
    end
    return true
end

function canBeatActsAtWithMinCompletionCount(min_completion_count, ...)
    -- With act rando enabled, the player sometimes won't know what a level is if a minimum number of acts haven't been
    -- completed. E.g. Boss acts don't show up until 1 act is completed.
    -- With act rando disabled, then the acts are known in advance, so there's only a need to check whether acts *can*
    -- be completed.
    local completion_count = 0
    for _, v in ipairs(arg) do
        if act_rando_enabled and completedActAt(v) then
            completion_count = completion_count + 1
        elseif not canBeatActAt(v) then
            return false
        end
    end
    return not act_rando_enabled or completion_count >= min_completion_count
end

function clearedAnyLocationIfActRando(...)
    if not act_rando_enabled then
        return true
    end

    for _, v in ipairs(args) do
        local loc = Tracker:FindObjectForCode(v)
        if loc.AccessibilityLevel == AccessibilityLevel.Cleared then
            return true
        end
    end
end