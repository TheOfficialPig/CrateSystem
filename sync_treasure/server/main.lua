local QBCore = exports['qb-core']:GetCoreObject()
local spawnedChests = {}

-- Function to delete all chests
local function deleteAllChests()
    for chestID, _ in pairs(spawnedChests) do
        TriggerClientEvent('sync_treasure:removeChest', -1, chestID)
    end
    spawnedChests = {}
end

-- Function to spawn a treasure chest at a random location
local function spawnTreasureChest()
    deleteAllChests()

    -- Choose a random location from the config
    local location = SYNC.TreasureLocations[math.random(#SYNC.TreasureLocations)]

    -- Generate a unique ID for the chest
    local chestID = math.random(10000, 99999)

    -- Store the chest data
    spawnedChests[chestID] = {
        coords = location,
        isLooted = false
    }

    -- Notify clients to spawn the chest
    TriggerClientEvent('sync_treasure:spawnChest', -1, chestID, location)
end


local function getRandomLoot()
    local lootItems = SYNC.LootItems
    local selectedItem = lootItems[math.random(1, #lootItems)]
    local lootAmount = math.random(selectedItem.min, selectedItem.max)
    return selectedItem.item, lootAmount
end

RegisterNetEvent('sync_treasure:lootChest')
AddEventHandler('sync_treasure:lootChest', function(chestID)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local lootItem, lootAmount = getRandomLoot()

    if spawnedChests[chestID] and not spawnedChests[chestID].isLooted then
        spawnedChests[chestID].isLooted = true

        -- Reward the player (you can customize the reward)
        Player.Functions.AddItem(lootItem, lootAmount)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[lootItem], "add", lootAmount)

        -- Notify clients to remove the chest, blips, and radius markers
        TriggerClientEvent('sync_treasure:removeChest', -1, chestID)
    end
end)

Citizen.CreateThread(function()
    while true do
        local spawnDelay = math.random(SYNC.MinSpawnDelay, SYNC.MaxSpawnDelay)
        Citizen.Wait(spawnDelay * 1000)
        local spawnChance = math.random(SYNC.MinSpawnChance, SYNC.MaxSpawnChance)
        local randomChance = math.random(1, 100)

        if randomChance <= spawnChance then
            spawnTreasureChest()
        end
    end
end)

if SYNC.EnableCommand then
    RegisterCommand(SYNC.TestCommand, function(source, args, rawCommand)
        spawnTreasureChest()
    end, true)
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        deleteAllChests()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        deleteAllChests()
    end
end)

print("Sync Treasure has been loaded successfully. Made by: SYNC")