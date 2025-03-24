local isHUDVisible = false
local blackMoneyAmount = 0

local function sendNuiMessage(action, data)
    SendNUIMessage({ action = action, data = data })
end

local function getBlackMoney(items)
    if GetResourceState('qb-core'):match('start') then
        for _, item in pairs(items or {}) do
            if item.name == "blackmoney" then
                return item.amount
            end
        end
    else
        return CustomGetBlackMoney(items)
    end
end

local function updateWeaponHUD(ped)
    local currentWeapon = GetSelectedPedWeapon(ped)
    local hasWeapon = currentWeapon and currentWeapon ~= `WEAPON_UNARMED`
    if hasWeapon then
        local weaponData = GetWeaponData(currentWeapon)
        if weaponData then
            sendNuiMessage('updateWeapon', {
                weapon = weaponData.label or "Desconocido",
                ammo = GetAmmoInPedWeapon(ped, currentWeapon)
            })
        end
    end
    return hasWeapon
end

local function updatePlayerHUD(ped, playerData)
    sendNuiMessage('updateHUD', {
        health = math.abs(math.floor(GetEntityHealth(ped) - 100)),
        armor = GetPedArmour(ped),
        hunger = playerData.metadata.hunger,
        thirst = playerData.metadata.thirst,
        cash = playerData.money.cash or 0,
        bank = playerData.money.bank or 0,
        stamina = GetPlayerStamina(PlayerId()),
        oxygen = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10,
        blackmoney = blackMoneyAmount
    })
end

Citizen.CreateThread(function()
    while true do
        local sleep = Config.UpdateInterval
        if IsPlayerLoaded() then
            local ped = PlayerPedId()
            local playerData = GetPlayerData()

            updatePlayerHUD(ped, playerData)

            if updateWeaponHUD(ped) then
                sleep = 0
            end

            blackMoneyAmount = getBlackMoney(playerData.items)

            DisplayRadar(Config.ShowMinimap == "incar" and IsPedInAnyVehicle(PlayerPedId(), false) or Config.ShowMinimap)
        end
        Wait(sleep)
    end
end)

local function startCarLoop(vehicle)
    Citizen.CreateThread(function()
        while vehicle > 0 do
            local factor = Config.UseKMH and 3.6 or 2.236936

            sendNuiMessage('updateSpeed', {
                speed = math.floor(GetEntitySpeed(vehicle) * factor),
                fuel = GetFuel(vehicle),
                inVehicle = true
            })

            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                break
            end

            Wait(500)
        end

        sendNuiMessage('updateSpeed', {
            speed = 0,
            fuel = 0,
            inVehicle = false
        })
    end)
end

AddEventHandler('gameEventTriggered', function(name, args)
    if name == "CEventNetworkPlayerEnteredVehicle" then
        startCarLoop(args[2])
    end
end)

function OnPlayerLoaded()
    Citizen.Wait(0)
    local playerData = GetPlayerData()
    isHUDVisible = true

    sendNuiMessage('toggleHUD', { visible = true })
    sendNuiMessage('updateRole', {
        role = playerData.job.label,
        grade = playerData.job.grade.name
    })
end

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(jobInfo)
    sendNuiMessage('updateRole', {
        role = jobInfo.label,
        grade = jobInfo.grade.name
    })

    PlayerData.job = { label = jobInfo.label, grade = { name = jobInfo.grade.name } }
end)

function toggleHUD(state)
    isHUDVisible = state or not isHUDVisible
    sendNuiMessage('toggleHUD', { visible = isHUDVisible })
end

function showHUD()
    toggleHUD(true)
end

function hideHUD()
    toggleHUD(false)
end

exports('showHUD', showHUD)
exports('hideHUD', hideHUD)
exports('toggleHUD', toggleHUD)
exports('isHUDVisible', function() return isHUDVisible end)

RegisterCommand('togglehud', function()
    toggleHUD()
    Notify('HUD ' .. (isHUDVisible and 'showed' or 'hidden'))
end, false)

Citizen.CreateThread(function()
    while not IsPlayerLoaded() do
        Wait(500)
    end
    Citizen.Wait(1000)
    OnPlayerLoaded()
end)
