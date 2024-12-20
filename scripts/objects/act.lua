-- Set up struct for act randomization
-- This is super cool and I'm proud

local Act = {
    chapter = -1,
    -- act_name is set to the act that has been randomized to this entrance, when connecting to AP.
    act_name = "",
    -- Entrance location for logic. Must have "Can Enter" and "Can Complete" sections.
    entrance_location = "",
    -- Vanilla completion logic
    -- `nil` implies a free roam act which is always considered complete
    vanilla_act_completion_location_section = nil
}

Act.__index = Act

function Act.new(chapter, act_name, entrance_location, vanilla_act_completion_location_section)
    local self = setmetatable({}, Act)
    self.chapter = chapter or -1
    self.act_name = act_name or ""
    self.entrance_location = "@" .. entrance_location
    if vanilla_act_completion_location_section == nil then
        self.vanilla_act_completion_location_section = nil
    else
        self.vanilla_act_completion_location_section = "@" .. vanilla_act_completion_location_section
    end
    return self
end

function Act:getChapter()
    return self.chapter
end

function Act:setChapter(chapter)
    self.chapter = chapter
end

function Act:getActName()
    return self.act_name
end

function Act:setActName(act_name)
    self.act_name = act_name
end

function Act:getEntranceLocation()
    if self.entrance_location then
        return Tracker:FindObjectForCode(self.entrance_location)
    else
        print(string.format("Error: Could not find entrance location '%s'", self.entrance_location))
        return nil
    end
end

function Act:getEntranceAccessibility(allow_inspect)
    local entrance_location = self:getEntranceLocation()
    if allow_inspect then
        return entrance_location.AccessibilityLevel
    else
        local entrance_accessibility = entrance_location.AccessibilityLevel
        if entrance_accessibility == AccessibilityLevel.Inspect then
            -- By default, Inspect is not propagated because it is meaningless to logic.
            -- If an entrance is Inspect (checkable), the locations within the act at that entrance are unreachable,
            -- not Inspect.
            return AccessibilityLevel.None
        else
            return entrance_accessibility
        end
    end
end

function Act:getCanEnterSection()
    if self.entrance_location then
        return Tracker:FindObjectForCode(self.entrance_location .. "/Can Enter")
    else
        print(string.format("Error: Could not find 'can enter entrance' section for '%s'", self.entrance_location))
        return nil
    end
end

function Act:getCanCompleteSection()
    if self.entrance_location then
        return Tracker:FindObjectForCode(self.entrance_location .. "/Can Complete")
    else
        print(string.format("Error: Could not find 'can complete entrance' section for '%s'", self.entrance_location))
        return nil
    end
end

function Act:markAsCompleted()
    local can_enter = self:getCanEnterSection()
    if can_enter then
        can_enter.AvailableChestCount = can_enter.AvailableChestCount - 1
    end

    local can_complete = self:getCanCompleteSection()
    if can_complete then
        can_complete.AvailableChestCount = can_complete.AvailableChestCount - 1
    end
end

function Act:clearCompletion()
    local can_enter = self:getCanEnterSection()
    if can_enter then
        can_enter.AvailableChestCount = can_enter.ChestCount
    end

    local can_complete = self:getCanCompleteSection()
    if can_complete then
        can_complete.AvailableChestCount = can_complete.ChestCount
    end
end

return Act