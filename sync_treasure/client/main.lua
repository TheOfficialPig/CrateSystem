local QBCore = exports['qb-core']:GetCoreObject()
local spawnedChests = {}
local lootingChests = false

-- Function to create a treasure chest
local function createTreasureChest(chestID, location)
    
    local model = SYNC.TreasureModel

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local chest = CreateObject(model, location.x, location.y, location.z, true, true, false)
    PlaceObjectOnGroundProperly(chest)

    local radius = AddBlipForRadius(location.x, location.y, location.z, SYNC.RadiusSize)
    SetBlipSprite(radius, 9)
    SetBlipColour(radius, SYNC.RadiusColour)
    SetBlipAlpha(radius, 75)

    spawnedChests[chestID] = { radius = radius,  coords = location, entity = chest }
end

-- Function to remove a treasure chest
local function removeTreasureChest(chestID)
    if spawnedChests[chestID] then
        RemoveBlip(spawnedChests[chestID].radius)
        DeleteObject(spawnedChests[chestID].entity)
        spawnedChests[chestID] = nil
    end
end

RegisterNetEvent('sync_treasure:removeChest')
AddEventHandler('sync_treasure:removeChest', function(chestID)
    removeTreasureChest(chestID)
end)

-- Event to handle spawning a chest
RegisterNetEvent('sync_treasure:spawnChest')
AddEventHandler('sync_treasure:spawnChest', function(chestID, location)

    createTreasureChest(chestID, location)

    if SYNC.Notify == "qb" then
        -- ADD QB NOTIFY
    elseif SYNC.Notify == "okok" then
        exports['okokNotify']:Alert('Treasure', '[SYNC] Treasure Chest has spawned', 3000, 'warning', playSound)
    end
    
end)

-- Function to loot the chest
local function lootChest(chestID)
    lootingChests = true

    QBCore.Functions.Progressbar("loot_treasures", "Looting Treasure Chest..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
     }, {
        animDict = "anim@gangops@facility@servers@bodysearch@",
        anim = "player_search",
        flags = 49,
     }, {}, {}, function()
        TriggerServerEvent('sync_treasure:lootChest', chestID)
        lootingChests = false
     end, function()
        ClearPedTasks(PlayerPedId(-1))
        lootingChests = false
     end)
end

-- Modify the interaction loop to include the progress bar
if SYNC.Target == "drawtext" then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            for chestID, chest in pairs(spawnedChests) do
                local distance = #(playerCoords - vector3(chest.coords.x, chest.coords.y, chest.coords.z))
                if distance < 2.0 then
                    QBCore.Functions.DrawText3D(chest.coords.x, chest.coords.y, chest.coords.z, "[E] Loot Treasure Chest")
                    if IsControlJustReleased(0, 38) then
                        if not lootingChests then
                            lootChest(chestID)
                        else
                            QBCore.Functions.Notify("You are already looting a chest.", "error")
                        end
                    end
                end
            end
        end
    end)
end

-- Ensure all chests are removed when the resource starts
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for chestID, _ in pairs(spawnedChests) do
            removeTreasureChest(chestID)
        end
    end
end)

-- Ensure all chests are removed when the resource stops
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for chestID, _ in pairs(spawnedChests) do
            removeTreasureChest(chestID)
        end
    end
end)