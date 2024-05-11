-- Set up struct for act randomization
-- This is super cool and I'm proud

local Act = {
    chapter = -1,
    -- act_name is set to the act that has been randomized to this entrance, when connecting to AP.
    act_name = "",
    -- Entrance location for logic
    entrance_location_section = "",
    -- Vanilla completion logic
    -- `nil` implies a free roam act which is always considered complete
    vanilla_act_completion_location_section = nil
}

Act.__index = Act

function Act.new(chapter, act_name, entrance_location, vanilla_act_completion_location_section)
    local self = setmetatable({}, Act)
    self.chapter = chapter or -1
    self.act_name = act_name or ""
    self.entrance_location_section = "@" .. entrance_location
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

return Act