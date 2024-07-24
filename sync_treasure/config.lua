SYNC = {}

-- CORE SETTINGS
SYNC.Notify = "okok" -- (qb/okok)
SYNC.Target = "drawtext" -- (adding qbtarget/oxtarget soon)

-- DEBUG SETTINGS
SYNC.EnableCommand = false
SYNC.TestCommand = "forcetreasure"

-- RADIUS SETTINGS
SYNC.RadiusSize = 100.0
SYNC.RadiusColour = 46

-- MODEL SETTINGS
SYNC.TreasureModel = "sm_prop_smug_crate_s_jewellery"

-- LOCATION SETTINGS
SYNC.TreasureLocations = {
    vector3(640.25, 3017.22, 43.26),
    vector3(1216.54, -1288.09, 35.23),
}

-- LOOT SETTINGS (Set the loot a player will get from the Crate.)
SYNC.LootItems = {
    {item = "diamond_ring", min = 1, max = 3},
    {item = "goldbar", min = 2, max = 5},
    {item = "goldchain", min = 1, max = 2}
}

-- CHANCE SETTINGS
SYNC.MinSpawnChance = 30 -- Minimum chance
SYNC.MaxSpawnChance = 50 -- Maximum chance

-- DELAY SETTINGS
SYNC.MinSpawnDelay = 120 -- minutes
SYNC.MaxSpawnDelay = 240 -- minutes
