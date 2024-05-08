local Act = require("objects/act")

act_rando_enabled = false

-- Set up the default chapter information
chapter_act_info = {
    Spaceship_WaterRift_Gallery = Act.new(0, "Spaceship_WaterRift_Gallery", "The Gallery Entrances/Time Rifts", "Time Rifts/The Gallery/Time Rift"),
    Spaceship_WaterRift_MailRoom = Act.new(0, "Spaceship_WaterRift_MailRoom", "The Lab Entrances/Time Rifts", "Time Rifts/The Lab/Time Rift"),

    chapter1_tutorial = Act.new(1, "chapter1_tutorial", "Chapter1 Entrances/Acts", "Mafia Town/Welcome to Mafia Town/Time Piece"),
    chapter1_barrelboss = Act.new(1, "chapter1_barrelboss", "Chapter1 Entrances/Acts", "Mafia Town/Barrel Battle/Time Piece"),
    chapter1_cannon_repair = Act.new(1, "chapter1_cannon_repair", "Chapter1 Entrances/Acts", "Mafia Town (HUMT)/Mafia Geek/She Came from Outer Space"),
    chapter1_boss = Act.new(1, "chapter1_boss", "Chapter1 Entrances/Acts", "Mafia Town (HUMT)/Mafia HQ/Time Piece"),
    harbor_impossible_race = Act.new(1, "harbor_impossible_race", "Chapter1 Entrances/Acts", "Mafia Town (HUMT)/Beach Alcove/Cheating the Race"),
    mafiatown_lava = Act.new(1, "mafiatown_lava", "Chapter1 Entrances/Acts", "Mafia Town (HUMT)/Mafia Geek/Heating Up Mafia Town"),
    mafiatown_goldenvault = Act.new(1, "mafiatown_goldenvault", "Chapter1 Entrances/Acts", "Mafia Town/The Golden Vault/Time Piece"),
    TimeRift_Cave_Mafia = Act.new(-1, "TimeRift_Cave_Mafia", "Chapter Time Rift Entrances/Chapter1", "Mafia Town - Time Rifts/Mafia of Cooks/Time Rift"),
    TimeRift_Water_Mafia_Easy = Act.new(-1,"TimeRift_Water_Mafia_Easy", "Chapter Time Rift Entrances/Chapter1", "Mafia Town - Time Rifts/Sewers/Time Rift"),
    TimeRift_Water_Mafia_Hard = Act.new(-1,"TimeRift_Water_Mafia_Hard", "Chapter Time Rift Entrances/Chapter1", "Mafia Town - Time Rifts/Bazaar/Time Rift"),

    DeadBirdStudio = Act.new(2, "DeadBirdStudio", "Chapter2 Entrances/Acts", "Act Completions/Act Completion/Dead Bird Studio"),
    chapter3_murder = Act.new(2, "chapter3_murder", "Chapter2 Entrances/Acts", "Films/The Conductor's Films/Murder on the Owl Express"),
    moon_camerasnap = Act.new(2, "moon_camerasnap", "Chapter2 Entrances/Acts", "Films/DJ Groove's Films/Picture Perfect"),
    trainwreck_selfdestruct = Act.new(2, "trainwreck_selfdestruct", "Chapter2 Entrances/Acts", "Films/The Conductor's Films/Train Rush"),
    moon_parade = Act.new(2, "moon_parade", "Chapter2 Entrances/Acts", "Films/DJ Groove's Films/The Big Parade"),
    award_ceremony = Act.new(2, "award_ceremony", "Chapter2 Entrances/Acts", "Act Completions/Act Completion/Award Ceremony"),
    chapter3_secret_finale = Act.new(2, "chapter3_secret_finale", "Chapter2 Entrances/Acts", "Dead Bird Basement/Act Completion/Time Piece"),
    TimeRift_Cave_BirdBasement = Act.new(-2, "TimeRift_Cave_BirdBasement", "Chapter Time Rift Entrances/Chapter2 - Dead Bird Studio", "Dead Bird Studio (Rift)/Time Piece"),
    TimeRift_Water_TWreck_Panels = Act.new(-2, "TimeRift_Water_TWreck_Panels", "Chapter Time Rift Entrances/Chapter2 - Murder on the Owl Express", "Films/The Conductor's Films/Time Rift"),
    TimeRift_Water_TWreck_Parade = Act.new(-2, "TimeRift_Water_TWreck_Parade", "Chapter Time Rift Entrances/Chapter2 - The Moon", "Films/DJ Groove's Films/Time Rift"),

    subcon_village_icewall = Act.new(3, "subcon_village_icewall", "Chapter3 Entrances/Acts", "Yellow Firewall/Contractual Obligations/Time Piece"),
    subcon_cave = Act.new(3, "subcon_cave", "Chapter3 Entrances/Acts", "Yellow Firewall/Subcon Well/Time Piece"),
    chapter2_toiletboss = Act.new(3, "chapter2_toiletboss", "Chapter3 Entrances/Acts", "Boss Arena Area/Boss Arena/Toilet of Doom"),
    vanessa_manor_attic = Act.new(3, "vanessa_manor_attic", "Chapter3 Entrances/Acts", "Yellow Firewall/Queen Vanessa's Manor/Time Piece"),
    subcon_maildelivery = Act.new(3, "subcon_maildelivery", "Chapter3 Entrances/Acts", "Subcon Forest/Snatcher/Mail Delivery Service"),
    snatcher_boss = Act.new(3, "snatcher_boss", "Chapter3 Entrances/Boss", "Boss Arena Area/Boss Arena/Your Contract has Expired"),
    TimeRift_Cave_Raccoon = Act.new(-3, "TimeRift_Cave_Raccoon", "Chapter Time Rift Entrances/Chapter3", "Subcon Time Rifts/Sleepy Subcon/Time Rift"),
    TimeRift_Water_Subcon_Hookshot = Act.new(-3, "TimeRift_Water_Subcon_Hookshot", "Chapter Time Rift Entrances/Chapter3", "Subcon Time Rifts/Pipe/Time Rift"),
    TimeRift_Water_Subcon_Dwellers = Act.new(-3, "TimeRift_Water_Subcon_Dwellers", "Chapter Time Rift Entrances/Chapter3", "Subcon Time Rifts/Village/Time Rift"),

    AlpineFreeRoam = Act.new(4, "AlpineFreeRoam", "Chapter4 Entrances/Acts", nil),
    AlpineSkyline_Finale = Act.new(4, "AlpineSkyline_Finale", "Chapter4 Entrances/Boss", "Alpine Skyline/The Illness has Spread/Time Piece"),
    TimeRift_Cave_Alps = Act.new(-4, "TimeRift_Cave_Alps", "Chapter Time Rift Entrances/Chapter4", "Alpine Skyline - Time Rifts/Alpine Skyline (Rift)/Time Rift"),
    TimeRift_Water_Alp_Goats = Act.new(-4, "TimeRift_Water_Alp_Goats", "Chapter Time Rift Entrances/Chapter4", "Alpine Skyline - Time Rifts/The Twilight Bell (Rift)/Time Rift"),
    TimeRift_Water_AlpineSkyline_Cats = Act.new(-4, "TimeRift_Water_AlpineSkyline_Cats", "Chapter Time Rift Entrances/Chapter4", "Alpine Skyline - Time Rifts/Curly Tail Trail/Time Rift"),

    TheFinale_FinalBoss = Act.new(5, "TheFinale_FinalBoss", "Chapter5 Entrances/Acts", "Spaceship/Time's End/Time Piece"),
    TimeRift_Cave_Tour = Act.new(-5, "TimeRift_Cave_Tour", "The Attic Entrances/Time Rifts", "Spaceship/Tour/Time Rift"),

    Cruise_Boarding = Act.new(6, "Cruise_Boarding", "Chapter6 Entrances/Acts", "The Arctic Cruise/Bon Voyage!/Time Piece"),
    Cruise_Working = Act.new(6, "Cruise_Working", "Chapter6 Entrances/Acts", "The Arctic Cruise/Ship Shape/Time Piece"),
    Cruise_Sinking = Act.new(6, "Cruise_Sinking", "Chapter6 Entrances/Acts", "The Arctic Cruise/Rock the Boat/Time Piece"),
    Cruise_CaveRift_Aquarium = Act.new(-6, "Cruise_CaveRift_Aquarium", "Chapter Time Rift Entrances/Chapter6", "The Arctic Cruise - Time Rifts/Deep Sea/Time Rift"),
    Cruise_WaterRift_Slide = Act.new(-6, "Cruise_WaterRift_Slide", "Chapter Time Rift Entrances/Chapter6", "The Arctic Cruise - Time Rifts/Balcony/Time Rift"),

    MetroFreeRoam = Act.new(7, "MetroFreeRoam", "Chapter7 Entrances/Acts", nil),
    Metro_Escape = Act.new(7, "Metro_Escape", "Chapter7 Entrances/Boss", "Finale/Rush Hour/Time Piece"),
    Metro_CaveRift_RumbiFactory = Act.new(-7, "Metro_CaveRift_RumbiFactory", "Chapter Time Rift Entrances/Chapter7", "Nyakuza Metro - Time Rifts/Rumbi Factory/Time Rift")
}

-- There is also a `Metro_Intro` time piece, but it is not actually required to unlock the boss act, nor does it show up
-- as a separate act in the telescope.
nyakuza_free_roam_act_names = {
    Metro_RouteA = true,
    Metro_RouteB = true,
    Metro_RouteC = true,
    Metro_RouteD = true,
    Metro_ManholeA = true,
    Metro_ManholeB = true,
    Metro_ManholeC = true
}

alpine_free_roam_act_names = {
    Alpine_Twilight = true,
    Alps_Birdhouse = true,
    AlpineSkyline_Windmill = true,
    AlpineSkyline_WeddingCake = true
}

time_piece_location_to_vanilla_entrance = {}
for entrance, act in pairs(chapter_act_info) do
    local time_piece_loc = act.vanilla_act_completion_location_section
    -- Free roam acts are considered cleared automatically, though the tracker will show them as accessible and
    -- uncleared.
    if time_piece_loc ~= nil then
        time_piece_location_to_vanilla_entrance[time_piece_loc] = entrance
    end
end

chapter_entrance_names = {}
for entrance, act in pairs(chapter_act_info) do
    local chapter = act.chapter
    local chapter_entrances = chapter_entrance_names[chapter]
    if chapter_entrances == nil then
        chapter_entrances = {}
        chapter_entrance_names[chapter] = chapter_entrances
    end
    table.insert(chapter_entrances, entrance)
end

act_to_entrance = {}

-- Should be called after updating the act name of entrances through act:setActName(new_name)
function updateActToEntrance()
    for entrance, act in pairs(chapter_act_info) do
        act_to_entrance[act.act_name] = entrance
    end
end

updateActToEntrance()

-- Given a time piece location, get the act, get the entrance of the act and return the entrance's location.
function getEntranceFromTimePieceLocation(time_piece_loc)
    local vanilla_act = time_piece_location_to_vanilla_entrance[time_piece_loc]
    if vanilla_act then
        return getActInfo(vanilla_act)
    end

    return nil
end

function getActInfo(act_name)
    return chapter_act_info[act_to_entrance[act_name]]
end

-- To be updated by archipelago. The default values are for vanilla.
chapter_costs = {0, 4, 7, 14, 25, 35, 20}

-- To be updated by archipelago.
completed_entrances = {}