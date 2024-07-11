local Act = require("objects/act")

act_rando_enabled = false

-- Set up the default chapter information
chapter_act_info = {
    Spaceship_WaterRift_Gallery = Act.new(0, "Spaceship_WaterRift_Gallery", "The Gallery Entrances/Time Rift - Gallery", "Time Rifts/The Gallery/Time Rift"),
    Spaceship_WaterRift_MailRoom = Act.new(0, "Spaceship_WaterRift_MailRoom", "The Lab Entrances/Time Rift - The Lab", "Time Rifts/The Lab/Time Rift"),

    chapter1_tutorial = Act.new(1, "chapter1_tutorial", "Chapter 1 Entrances/Act 1 - Welcome to Mafia Town", "Mafia Town/Welcome to Mafia Town/Time Piece"),
    chapter1_barrelboss = Act.new(1, "chapter1_barrelboss", "Chapter 1 Entrances/Act 2 - Barrel Battle", "Mafia Town/Barrel Battle/Time Piece"),
    chapter1_cannon_repair = Act.new(1, "chapter1_cannon_repair", "Chapter 1 Entrances/Act 3 - She Came from Outer Space", "Mafia Town (HUMT)/Mafia Geek/She Came from Outer Space"),
    chapter1_boss = Act.new(1, "chapter1_boss", "Chapter 1 Entrances/Act 4 - Down with the Mafia!", "Mafia Town (HUMT)/Mafia HQ/Time Piece"),
    harbor_impossible_race = Act.new(1, "harbor_impossible_race", "Chapter 1 Entrances/Act 5 - Cheating the Race", "Mafia Town (HUMT)/Beach Alcove/Cheating the Race"),
    mafiatown_lava = Act.new(1, "mafiatown_lava", "Chapter 1 Entrances/Act 6 - Heating up Mafia Town", "Mafia Town (HUMT)/Mafia Geek/Heating Up Mafia Town"),
    mafiatown_goldenvault = Act.new(1, "mafiatown_goldenvault", "Chapter 1 Entrances/Act 7 - The Golden Vault", "Mafia Town/The Golden Vault/Time Piece"),
    TimeRift_Cave_Mafia = Act.new(-1, "TimeRift_Cave_Mafia", "Chapter Time Rift Entrances/Chapter 1/Time Rift - Mafia of Cooks", "Mafia Town - Time Rifts/Mafia of Cooks/Time Rift"),
    TimeRift_Water_Mafia_Easy = Act.new(-1,"TimeRift_Water_Mafia_Easy", "Chapter Time Rift Entrances/Chapter 1/Time Rift - Sewers", "Mafia Town - Time Rifts/Sewers/Time Rift"),
    TimeRift_Water_Mafia_Hard = Act.new(-1,"TimeRift_Water_Mafia_Hard", "Chapter Time Rift Entrances/Chapter 1/Time Rift - Bazaar", "Mafia Town - Time Rifts/Bazaar/Time Rift"),

    DeadBirdStudio = Act.new(2, "DeadBirdStudio", "Chapter 2 Entrances/Act 1 - Dead Bird Studio", "Act Completions/Act Completion/Dead Bird Studio"),
    chapter3_murder = Act.new(2, "chapter3_murder", "Chapter 2 Entrances/Act 2 - Murder on the Owl Express", "Films/The Conductor's Films/Murder on the Owl Express"),
    moon_camerasnap = Act.new(2, "moon_camerasnap", "Chapter 2 Entrances/Act 3 - Picture Perfect", "Films/DJ Groove's Films/Picture Perfect"),
    trainwreck_selfdestruct = Act.new(2, "trainwreck_selfdestruct", "Chapter 2 Entrances/Act 4 - Train Rush", "Films/The Conductor's Films/Train Rush"),
    moon_parade = Act.new(2, "moon_parade", "Chapter 2 Entrances/Act 5 - The Big Parade", "Films/DJ Groove's Films/The Big Parade"),
    award_ceremony = Act.new(2, "award_ceremony", "Chapter 2 Entrances/Finale - Award Ceremony", "Act Completions/Act Completion/Award Ceremony"),
    chapter3_secret_finale = Act.new(2, "chapter3_secret_finale", "Chapter 2 Entrances/Secret Finale - Dead Bird Basement", "Dead Bird Basement/Act Completion/Time Piece"),
    TimeRift_Cave_BirdBasement = Act.new(-2, "TimeRift_Cave_BirdBasement", "Chapter Time Rift Entrances/Chapter 2/Time Rift - Dead Bird Studio", "Dead Bird Studio (Rift)/Time Piece"),
    TimeRift_Water_TWreck_Panels = Act.new(-2, "TimeRift_Water_TWreck_Panels", "Chapter Time Rift Entrances/Chapter 2/Time Rift - The Owl Express", "Films/The Conductor's Films/Time Rift"),
    TimeRift_Water_TWreck_Parade = Act.new(-2, "TimeRift_Water_TWreck_Parade", "Chapter Time Rift Entrances/Chapter 2/Time Rift - The Moon", "Films/DJ Groove's Films/Time Rift"),

    subcon_village_icewall = Act.new(3, "subcon_village_icewall", "Chapter 3 Entrances/Act 1 - Contractual Obligations", "Yellow Firewall/Contractual Obligations/Time Piece"),
    subcon_cave = Act.new(3, "subcon_cave", "Chapter 3 Entrances/Act 2 - The Subcon Well", "Yellow Firewall/Subcon Well/Time Piece"),
    chapter2_toiletboss = Act.new(3, "chapter2_toiletboss", "Chapter 3 Entrances/Act 3 - Toilet of Doom", "Boss Arena Area/Boss Arena/Toilet of Doom"),
    vanessa_manor_attic = Act.new(3, "vanessa_manor_attic", "Chapter 3 Entrances/Act 4 - Queen Vanessa's Manor", "Yellow Firewall/Queen Vanessa's Manor/Time Piece"),
    subcon_maildelivery = Act.new(3, "subcon_maildelivery", "Chapter 3 Entrances/Act 5 - Mail Delivery Service", "Subcon Forest/Snatcher/Mail Delivery Service"),
    snatcher_boss = Act.new(3, "snatcher_boss", "Chapter 3 Entrances/Finale - Your Contract has Expired", "Boss Arena Area/Boss Arena/Your Contract has Expired"),
    TimeRift_Cave_Raccoon = Act.new(-3, "TimeRift_Cave_Raccoon", "Chapter Time Rift Entrances/Chapter 3/Time Rift - Sleepy Subcon", "Subcon Time Rifts/Sleepy Subcon/Time Rift"),
    TimeRift_Water_Subcon_Hookshot = Act.new(-3, "TimeRift_Water_Subcon_Hookshot", "Chapter Time Rift Entrances/Chapter 3/Time Rift - Pipe", "Subcon Time Rifts/Pipe/Time Rift"),
    TimeRift_Water_Subcon_Dwellers = Act.new(-3, "TimeRift_Water_Subcon_Dwellers", "Chapter Time Rift Entrances/Chapter 3/Time Rift - Village", "Subcon Time Rifts/Village/Time Rift"),

    AlpineFreeRoam = Act.new(4, "AlpineFreeRoam", "Chapter 4 Entrances/Alpine Skyline Free Roam", nil),
    AlpineSkyline_Finale = Act.new(4, "AlpineSkyline_Finale", "Chapter 4 Entrances/Finale - The Illness has Spread", "Alpine Skyline/The Illness has Spread/Time Piece"),
    TimeRift_Cave_Alps = Act.new(-4, "TimeRift_Cave_Alps", "Chapter Time Rift Entrances/Chapter 4/Time Rift - Alpine Skyline", "Alpine Skyline - Time Rifts/Alpine Skyline (Rift)/Time Rift"),
    TimeRift_Water_Alp_Goats = Act.new(-4, "TimeRift_Water_Alp_Goats", "Chapter Time Rift Entrances/Chapter 4/Time Rift - Twilight Bell", "Alpine Skyline - Time Rifts/The Twilight Bell (Rift)/Time Rift"),
    TimeRift_Water_AlpineSkyline_Cats = Act.new(-4, "TimeRift_Water_AlpineSkyline_Cats", "Chapter Time Rift Entrances/Chapter 4/Time Rift - Curly Tail Trail", "Alpine Skyline - Time Rifts/Curly Tail Trail/Time Rift"),

    TheFinale_FinalBoss = Act.new(5, "TheFinale_FinalBoss", "Chapter 5 Entrances/Act 1 - The Finale", "Spaceship/Time's End/Time Piece"),
    TimeRift_Cave_Tour = Act.new(-5, "TimeRift_Cave_Tour", "The Attic Entrances/Time Rift - Tour", "Spaceship/Tour/Time Rift"),

    Cruise_Boarding = Act.new(6, "Cruise_Boarding", "Chapter 6 Entrances/Act 1 - Bon Voyage!", "Bon Voyage!/Control Room/Bon Voyage!"),
    Cruise_Working = Act.new(6, "Cruise_Working", "Chapter 6 Entrances/Act 2 - Ship Shape", "The Arctic Cruise/Lost and Found/Ship Shape"),
    Cruise_Sinking = Act.new(6, "Cruise_Sinking", "Chapter 6 Entrances/Finale - Rock the Boat", "Rock the Boat/Post Captain Rescue/Time Piece"),
    Cruise_CaveRift_Aquarium = Act.new(-6, "Cruise_CaveRift_Aquarium", "Chapter Time Rift Entrances/Chapter 6/Time Rift - Deep Sea", "The Arctic Cruise - Time Rifts/Deep Sea/Time Rift"),
    Cruise_WaterRift_Slide = Act.new(-6, "Cruise_WaterRift_Slide", "Chapter Time Rift Entrances/Chapter 6/Time Rift - Balcony", "The Arctic Cruise - Time Rifts/Balcony/Time Rift"),

    MetroFreeRoam = Act.new(7, "MetroFreeRoam", "Chapter 7 Entrances/Nyakuza Metro Free Roam", nil),
    Metro_Escape = Act.new(7, "Metro_Escape", "Chapter 7 Entrances/Finale - Rush Hour", "Finale/Rush Hour/Time Piece"),
    Metro_CaveRift_RumbiFactory = Act.new(-7, "Metro_CaveRift_RumbiFactory", "Chapter Time Rift Entrances/Chapter 7/Time Rift - Rumbi Factory", "Nyakuza Metro - Time Rifts/Rumbi Factory/Time Rift")
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

-- To be updated by archipelago.
completed_entrances = {}