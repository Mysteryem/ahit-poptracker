local Act = require("objects/act")

act_rando_enabled = false

-- Set up the default chapter information
chapter_act_info = {
    Spaceship_WaterRift_Gallery = Act.new(0, "Spaceship_WaterRift_Gallery", "The Gallery Entrances/Time Rifts", "Time Rifts/The Gallery/Time Rift"),
    Spaceship_WaterRift_MailRoom = Act.new(0, "Spaceship_WaterRift_MailRoom", "The Lab Entrances/Time Rifts", "Time Rifts/The Lab/Time Rift"),

    chapter1_tutorial = Act.new(1, "chapter1_tutorial", "Chapter1 Entrances/Acts", "Mafia Town/Welcome to Mafia Town/Time Piece"),
    chapter1_barrelboss = Act.new(1, "chapter1_barrelboss", "Chapter1 Entrances/Acts", "Mafia Town/Barrel Battle/Time Piece"),
    chapter1_cannon_repair = Act.new(1, "chapter1_cannon_repair", "Chapter1 Entrances/Acts", "Mafia Town/Mafia Geek/She Came from Outer Space"),
    chapter1_boss = Act.new(1, "chapter1_boss", "Chapter1 Entrances/Acts", "Mafia Town/Mafia HQ/Time Piece"),
    harbor_impossible_race = Act.new(1, "harbor_impossible_race", "Chapter1 Entrances/Acts", "Mafia Town/Beach Alcove/Cheating the Race"),
    mafiatown_lava = Act.new(1, "mafiatown_lava", "Chapter1 Entrances/Acts", "Mafia Town/Mafia Geek/Heating Up Mafia Town"),
    mafiatown_goldenvault = Act.new(1, "mafiatown_goldenvault", "Chapter1 Entrances/Acts", "Mafia Town/The Golden Vault/Time Piece"),
    TimeRift_Cave_Mafia = Act.new(-1, "TimeRift_Cave_Mafia", "Chapter Time Rift Entrances/Chapter1", "Mafia Town/Mafia of Cooks/Time Rift"),
    TimeRift_Water_Mafia_Easy = Act.new(-1,"TimeRift_Water_Mafia_Easy", "Chapter Time Rift Entrances/Chapter1", "Mafia Town/Sewers/Time Rift"),
    TimeRift_Water_Mafia_Hard = Act.new(-1,"TimeRift_Water_Mafia_Hard", "Chapter Time Rift Entrances/Chapter1", "Mafia Town/Bazaar/Time Rift"),

    DeadBirdStudio = Act.new(2, "DeadBirdStudio", "Chapter2 Entrances/Acts", "Act Completions/Act Completion/Dead Bird Studio"),
    chapter3_murder = Act.new(2, "chapter3_murder", "Chapter2 Entrances/Acts", "Films/The Conductor's Films/Murder on the Owl Express"),
    moon_camerasnap = Act.new(2, "moon_camerasnap", "Chapter2 Entrances/Acts", "Films/DJ Groove's Films/Picture Perfect"),
    trainwreck_selfdestruct = Act.new(2, "trainwreck_selfdestruct", "Chapter2 Entrances/Acts", "Films/The Conductor's Films/Train Rush"),
    moon_parade = Act.new(2, "moon_parade", "Chapter2 Entrances/Acts", "Films/DJ Groove's Films/The Big Parade"),
    award_ceremony = Act.new(2, "award_ceremony", "Chapter2 Entrances/Acts", "Act Completions/Act Completion/Award Ceremony"),
    chapter3_secret_finale = Act.new(2, "chapter3_secret_finale", "Chapter2 Entrances/Acts", "Dead Bird Basement/Act Completion/Time Piece"),
    TimeRift_Cave_BirdBasement = Act.new(-2, "TimeRift_Cave_BirdBasement", "Chapter Time Rift Entrances/Chapter2", "Before Lever/Dead Bird Studio (Rift)/Time Piece"),
    TimeRift_Water_TWreck_Panels = Act.new(-2, "TimeRift_Water_TWreck_Panels", "Chapter Time Rift Entrances/Chapter2", "Films/The Conductor's Films/Time Rift"),
    TimeRift_Water_TWreck_Parade = Act.new(-2, "TimeRift_Water_TWreck_Parade", "Chapter Time Rift Entrances/Chapter2", "Films/DJ Groove's Films/Time Rift"),

    subcon_village_icewall = Act.new(3, "subcon_village_icewall", "Chapter3 Entrances/Acts", "Yellow Firewall/Contractual Obligations/Time Piece"),
    subcon_cave = Act.new(3, "subcon_cave", "Chapter3 Entrances/Acts", "Yellow Firewall/Subcon Well/Time Piece"),
    chapter2_toiletboss = Act.new(3, "chapter2_toiletboss", "Chapter3 Entrances/Acts", "Boss Arena Area/Boss Arena/Toilet of Doom"),
    vanessa_manor_attic = Act.new(3, "vanessa_manor_attic", "Chapter3 Entrances/Acts", "Yellow Firewall/Queen Vanessa's Manor/Time Piece"),
    subcon_maildelivery = Act.new(3, "subcon_maildelivery", "Chapter3 Entrances/Acts", "Subcon Forest/Snatcher/Mail Delivery Service"),
    snatcher_boss = Act.new(3, "snatcher_boss", "Chapter3 Entrances/Acts", "Boss Arena Area/Boss Arena/Your Contract has Expired"),
    TimeRift_Cave_Raccoon = Act.new(-3, "TimeRift_Cave_Raccoon", "Chapter Time Rift Entrances/Chapter3", "Green Firewall/Sleepy Subcon/Time Rift"),
    TimeRift_Water_Subcon_Hookshot = Act.new(-3, "TimeRift_Water_Subcon_Hookshot", "Chapter Time Rift Entrances/Chapter3", "Blue Firewall/Pipe/Time Rift"),
    TimeRift_Water_Subcon_Dwellers = Act.new(-3, "TimeRift_Water_Subcon_Dwellers", "Chapter Time Rift Entrances/Chapter3", "Blue Firewall/Village/Time Rift"),

    AlpineFreeRoam = Act.new(4, "AlpineFreeRoam", "Chapter4 Entrances/Acts", nil),
    AlpineSkyline_Finale = Act.new(4, "AlpineSkyline_Finale", "Chapter4 Entrances/Acts", "Alpine Skyline/The Illness has Spread/Time Piece"),
    TimeRift_Cave_Alps = Act.new(-4, "TimeRift_Cave_Alps", "Chapter Time Rift Entrances/Chapter4", "Goat Village/Alpine Skyline (Rift)/Time Rift"),
    TimeRift_Water_Alp_Goats = Act.new(-4, "TimeRift_Water_Alp_Goats", "Chapter Time Rift Entrances/Chapter4", "Twilight Bell Zipline/The Twilight Bell (Rift)/Time Rift"),
    TimeRift_Water_AlpineSkyline_Cats = Act.new(-4, "TimeRift_Water_AlpineSkyline_Cats", "Chapter Time Rift Entrances/Chapter4", "Windmill Zipline/Curly Tail Trail/Time Rift"),

    TheFinale_FinalBoss = Act.new(5, "TheFinale_FinalBoss", "Chapter5 Entrances/Acts", "Spaceship/Time's End/Time Piece"),
    TimeRift_Cave_Tour = Act.new(-5, "TimeRift_Cave_Tour", "The Attic Entrances/Time Rifts", "Spaceship/Time's End/Tour"),

    Cruise_Boarding = Act.new(6, "Cruise_Boarding", "Chapter6 Entrances/Acts", "The Arctic Cruise/Bon Voyage!/Time Piece"),
    Cruise_Working = Act.new(6, "Cruise_Working", "Chapter6 Entrances/Acts", "The Arctic Cruise/Ship Shape/Time Piece"),
    Cruise_Sinking = Act.new(6, "Cruise_Sinking", "Chapter6 Entrances/Acts", "The Arctic Cruise/Rock the Boat/Time Piece"),
    Cruise_CaveRift_Aquarium = Act.new(-6, "Cruise_CaveRift_Aquarium", "Chapter Time Rift Entrances/Chapter6", "The Arctic Cruise/Bon Voyage!/Time Rift - Deep Sea"),
    Cruise_WaterRift_Slide = Act.new(-6, "Cruise_WaterRift_Slide", "Chapter Time Rift Entrances/Chapter6", "The Arctic Cruise/Cruise Ship/Time Rift - Balcony"),

    MetroFreeRoam = Act.new(7, "MetroFreeRoam", "Chapter7 Entrances/Acts", nil),
    Metro_Escape = Act.new(7, "Metro_Escape", "Chapter7 Entrances/Acts", "Finale/Rush Hour/Time Piece"),
    Metro_CaveRift_RumbiFactory = Act.new(-7, "Metro_CaveRift_RumbiFactory", "Chapter Time Rift Entrances/Chapter7", "Nyakuza Metro/Rumbi Factory/Time Rift")
}

chapter_to_entrances = {}

for entrance, act in pairs(chapter_act_info) do
    local chapter = act.chapter
    local chapter_entrances = chapter_to_entrances[chapter]
    if chapter_entrances == nil then
        chapter_entrances = {}
        chapter_to_entrances[chapter] = chapter_entrances
    end
    table.insert(chapter_entrances, act)
end

act_to_entrance = {}

-- Should be called after updating the act name of entrances through act:setActName(new_name)
function updateActToEntrance()
    for entrance, act in pairs(chapter_act_info) do
        act_to_entrance[act.act_name] = entrance
    end
end

updateActToEntrance()

function getActInfo(act_name)
    return chapter_act_info[act_to_entrance[act_name]]
end

-- To be updated by archipelago. The default values are for vanilla.
chapter_costs = {0, 4, 7, 14, 25, 35, 20}