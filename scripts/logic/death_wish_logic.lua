-- Helper function for checking if a certain number of locations are accessible.
-- May return AccessibilityLevel.SequenceBreak if the locations are only accessible via sequence break.
local function has_count_accessible_locations(locations, required_count)
    local sequence_break_count = 0
    local accessible_count = 0
    for _, loc_path in ipairs(locations) do
        local location = Tracker:FindObjectForCode(loc_path)
        if location then
            local location_accessibility = location.AccessibilityLevel
            if location_accessibility == AccessibilityLevel.Normal then
                accessible_count = accessible_count + 1
                if accessible_count == required_count then
                    -- Return early.
                    return AccessibilityLevel.Normal
                end
            elseif location_accessibility == AccessibilityLevel.SequenceBreak then
                sequence_break_count = sequence_break_count + 1
            end
        end
    end
    if (sequence_break_count + accessible_count) >= required_count then
        -- There are enough that are accessible when including locations accessible via sequence break.
        return AccessibilityLevel.SequenceBreak
    else
        return AccessibilityLevel.None
    end
end

function hasTimePiecesForDeathWish()
    local timePieces = Tracker:FindObjectForCode("timepiece")
    local timePiecesRequired = Tracker:FindObjectForCode("dw_timepiece_requirement")
    return timePieces.AcquiredCount >= timePiecesRequired.AcquiredCount
end

function isContractMainObjectiveComplete(name)
    local completions = death_wish_completions or {}
    local completion = completions[name]
    if not completion then
        return false
    end

    -- 0: Main Objective
    -- 1: First Bonus
    -- 2: Second Bonus
    return completion[0] == true
end

function isShuffleContractPresent(name)
    local shuffle_number_lookup = death_wish_class_to_shuffle_number or {}
    return shuffle_number_lookup[name] ~= nil
end

function isShuffleContractUnlocked(name)
    local shuffle_number_lookup = death_wish_class_to_shuffle_number or {}

    local shuffle_number = shuffle_number_lookup[name]
    if shuffle_number == nil then
        return
    end

--     -- The initially unlocked shuffle contract is not known until death wish is unlocked.
--     if shuffle_number == 0 and not hasTimePiecesForDeathWish() then
--         return false
--     end

    local completion_count = death_wish_shuffle_completion_count or 0
    -- TODO
    -- A contract may not exist in the shuffle sequence, but if it does, then it is only visible once the preceding
    -- contract has been completed.
    return completion_count >= shuffle_number
end

local zero_jumps_locations = {
  "@Death Wish Logic/Zero Jumps/Welcome to Mafia Town",
  "@Death Wish Logic/Zero Jumps/Down with the Mafia!",
  "@Death Wish Logic/Zero Jumps/Cheating the Race",
  "@Death Wish Logic/Zero Jumps/The Golden Vault",
  "@Death Wish Logic/Zero Jumps/Dead Bird Studio",
  "@Death Wish Logic/Zero Jumps/Murder on the Owl Express",
  "@Death Wish Logic/Zero Jumps/Picture Perfect",
  "@Death Wish Logic/Zero Jumps/Train Rush",
  "@Death Wish Logic/Zero Jumps/Contractual Obligations",
  "@Death Wish Logic/Zero Jumps/Your Contract has Expired",
  "@Death Wish Logic/Zero Jumps/Toilet of Doom",
  "@Death Wish Logic/Zero Jumps/Mail Delivery Service",
  "@Death Wish Logic/Zero Jumps/Time Rift - Alpine Skyline",
  "@Death Wish Logic/Zero Jumps/Time Rift - The Lab",
  "@Death Wish Logic/Zero Jumps/Yellow Overpass Station",
  "@Death Wish Logic/Zero Jumps/Green Clean Station",
  "@Death Wish Logic/Zero Jumps Hard/Time Rift - Sewers",
  "@Death Wish Logic/Zero Jumps Hard/Time Rift - Bazaar",
  "@Death Wish Logic/Zero Jumps Hard/The Big Parade",
  "@Death Wish Logic/Zero Jumps Hard/Time Rift - Pipe",
  "@Death Wish Logic/Zero Jumps Hard/Time Rift - Curly Tail Trail",
  "@Death Wish Logic/Zero Jumps Hard/Time Rift - The Twilight Bell",
  "@Death Wish Logic/Zero Jumps Hard/The Illness has Spread",
  "@Death Wish Logic/Zero Jumps Hard/The Finale",
  "@Death Wish Logic/Zero Jumps Hard/Pink Paw Station",
  "@Death Wish Logic/Zero Jumps Expert/The Birdhouse",
  "@Death Wish Logic/Zero Jumps Expert/The Lava Cake",
  "@Death Wish Logic/Zero Jumps Expert/The Windmill",
  "@Death Wish Logic/Zero Jumps Expert/The Twilight Bell",
  "@Death Wish Logic/Zero Jumps Expert/Time Rift - Sleepy Subcon",
  "@Death Wish Logic/Zero Jumps Expert/Ship Shape"
}

function canCompleteFourZeroJumps()
    return has_count_accessible_locations(zero_jumps_locations, 4)
end

local camera_tourist_enemy_locations = {
    "@Death Wish Logic/Enemy Locations/Mafia Goon",
    "@Death Wish Logic/Enemy Locations/Sleepy Raccoon",
    "@Death Wish Logic/Enemy Locations/UFO",
    "@Death Wish Logic/Enemy Locations/Rat",
    "@Death Wish Logic/Enemy Locations/Shock Squid",
    "@Death Wish Logic/Enemy Locations/Shromb Egg",
    "@Death Wish Logic/Enemy Locations/Spider",
    "@Death Wish Logic/Enemy Locations/Crow",
    "@Death Wish Logic/Enemy Locations/Pompous Crow",
    "@Death Wish Logic/Enemy Locations/Fiery Crow",
    "@Death Wish Logic/Enemy Locations/Ninja Cat",
    -- Includes non-killable enemy versions of Express Owls that are never in logic.
    "@Death Wish Logic/Enemy Locations - Camera Tourist Extras/Express Owl",

    -- Every enemy below this point is never in logic.

    -- The logic counts both types of Ninja Cat as a single enemy for Camera Tourist even though they count separately.
    "@Death Wish Logic/Enemy Locations/Other Ninja Cat",
    "@Death Wish Logic/Enemy Locations - Camera Tourist Extras/Alpine Goat",
    "@Death Wish Logic/Enemy Locations - Camera Tourist Extras/Malfunctioning Rumbi",
    "@Death Wish Logic/Enemy Locations - Camera Tourist Extras/Headless Statue",
    "@Death Wish Logic/Enemy Locations - Camera Tourist Extras/CAW Crows",
    "@Death Wish Logic/Enemy Locations - Camera Tourist Extras/Dead Bird Studio Camera",
    "@Death Wish Logic/Enemy Locations - Camera Tourist Extras/Moon Penguin",
    "@Death Wish Logic/Enemy Locations - Camera Tourist Extras/Purple Time Rift",
    -- TODO: Check if Subcon Forest Headless Statues count
}

function canFindEightUniqueEnemiesToTakePicturesOf()
    return has_count_accessible_locations(camera_tourist_enemy_locations, 8)
end