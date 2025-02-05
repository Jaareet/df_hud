local QBCore = exports['qb-core']:GetCoreObject()
local isHUDVisible = false
local blackMoneyAmount = 0

Citizen.CreateThread(function()
    local weaponNames = {
         -- Melee
         [`WEAPON_UNARMED`] = "Desarmado",
         [`WEAPON_DAGGER`] = "Daga",
         [`WEAPON_BAT`] = "Bate",
         [`WEAPON_BOTTLE`] = "Botella",
         [`WEAPON_CROWBAR`] = "Palanca",
         [`WEAPON_FLASHLIGHT`] = "Linterna",
         [`WEAPON_GOLFCLUB`] = "Palo de Golf",
         [`WEAPON_HAMMER`] = "Martillo",
         [`WEAPON_HATCHET`] = "Hacha",
         [`WEAPON_KNUCKLE`] = "Puño Americano",
         [`WEAPON_KNIFE`] = "Cuchillo",
         [`WEAPON_MACHETE`] = "Machete",
         [`WEAPON_SWITCHBLADE`] = "Navaja",
         [`WEAPON_NIGHTSTICK`] = "Porra",
         [`WEAPON_WRENCH`] = "Llave Inglesa",
         [`WEAPON_BATTLEAXE`] = "Hacha de Batalla",
         [`WEAPON_POOLCUE`] = "Taco de Billar",
         [`WEAPON_STONE_HATCHET`] = "Hacha de Piedra",
 
         -- Pistolas
         [`WEAPON_PISTOL`] = "Pistola",
         [`WEAPON_PISTOL_MK2`] = "Pistola MK2",
         [`WEAPON_COMBATPISTOL`] = "Pistola de Combate",
         [`WEAPON_APPISTOL`] = "Pistola AP",
         [`WEAPON_STUNGUN`] = "Táser",
         [`WEAPON_PISTOL50`] = "Pistola .50",
         [`WEAPON_SNSPISTOL`] = "Pistola SNS",
         [`WEAPON_SNSPISTOL_MK2`] = "Pistola SNS MK2",
         [`WEAPON_HEAVYPISTOL`] = "Pistola Pesada",
         [`WEAPON_VINTAGEPISTOL`] = "Pistola Vintage",
         [`WEAPON_FLAREGUN`] = "Pistola de Bengalas",
         [`WEAPON_MARKSMANPISTOL`] = "Pistola de Tirador",
         [`WEAPON_REVOLVER`] = "Revólver",
         [`WEAPON_REVOLVER_MK2`] = "Revólver MK2",
         [`WEAPON_DOUBLEACTION`] = "Revólver Doble Acción",
         [`WEAPON_RAYPISTOL`] = "Pistola de Rayos",
 
         -- SMGs
         [`WEAPON_MICROSMG`] = "Micro SMG",
         [`WEAPON_SMG`] = "SMG",
         [`WEAPON_SMG_MK2`] = "SMG MK2",
         [`WEAPON_ASSAULTSMG`] = "SMG de Asalto",
         [`WEAPON_COMBATPDW`] = "PDW de Combate",
         [`WEAPON_MACHINEPISTOL`] = "Pistola Ametralladora",
         [`WEAPON_MINISMG`] = "Mini SMG",
         [`WEAPON_RAYCARBINE`] = "Carabina de Rayos",
 
         -- Escopetas
         [`WEAPON_PUMPSHOTGUN`] = "Escopeta de Bombeo",
         [`WEAPON_PUMPSHOTGUN_MK2`] = "Escopeta de Bombeo MK2",
         [`WEAPON_SAWNOFFSHOTGUN`] = "Escopeta Recortada",
         [`WEAPON_ASSAULTSHOTGUN`] = "Escopeta de Asalto",
         [`WEAPON_BULLPUPSHOTGUN`] = "Escopeta Bullpup",
         [`WEAPON_MUSKET`] = "Mosquete",
         [`WEAPON_HEAVYSHOTGUN`] = "Escopeta Pesada",
         [`WEAPON_DBSHOTGUN`] = "Escopeta de Doble Cañón",
         [`WEAPON_AUTOSHOTGUN`] = "Escopeta Automática",
 
         -- Rifles de Asalto
         [`WEAPON_ASSAULTRIFLE`] = "Rifle de Asalto",
         [`WEAPON_ASSAULTRIFLE_MK2`] = "Rifle de Asalto MK2",
         [`WEAPON_CARBINERIFLE`] = "Rifle Carabina",
         [`WEAPON_CARBINERIFLE_MK2`] = "Rifle Carabina MK2",
         [`WEAPON_ADVANCEDRIFLE`] = "Rifle Avanzado",
         [`WEAPON_SPECIALCARBINE`] = "Carabina Especial",
         [`WEAPON_SPECIALCARBINE_MK2`] = "Carabina Especial MK2",
         [`WEAPON_BULLPUPRIFLE`] = "Rifle Bullpup",
         [`WEAPON_BULLPUPRIFLE_MK2`] = "Rifle Bullpup MK2",
         [`WEAPON_COMPACTRIFLE`] = "Rifle Compacto",
 
         -- Ametralladoras
         [`WEAPON_MG`] = "Ametralladora",
         [`WEAPON_COMBATMG`] = "Ametralladora de Combate",
         [`WEAPON_COMBATMG_MK2`] = "Ametralladora de Combate MK2",
         [`WEAPON_GUSENBERG`] = "Gusenberg",
 
         -- Rifles de Francotirador
         [`WEAPON_SNIPERRIFLE`] = "Rifle de Francotirador",
         [`WEAPON_HEAVYSNIPER`] = "Francotirador Pesado",
         [`WEAPON_HEAVYSNIPER_MK2`] = "Francotirador Pesado MK2",
         [`WEAPON_MARKSMANRIFLE`] = "Rifle de Tirador",
         [`WEAPON_MARKSMANRIFLE_MK2`] = "Rifle de Tirador MK2",
 
         -- Armas Pesadas
         [`WEAPON_RPG`] = "Lanzacohetes",
         [`WEAPON_GRENADELAUNCHER`] = "Lanzagranadas",
         [`WEAPON_GRENADELAUNCHER_SMOKE`] = "Lanzagranadas de Humo",
         [`WEAPON_MINIGUN`] = "Minigun",
         [`WEAPON_FIREWORK`] = "Lanzador de Fuegos Artificiales",
         [`WEAPON_RAILGUN`] = "Cañón de Riel",
         [`WEAPON_HOMINGLAUNCHER`] = "Lanzador Teledirigido",
         [`WEAPON_COMPACTLAUNCHER`] = "Lanzador Compacto",
         [`WEAPON_RAYMINIGUN`] = "Minigun de Rayos",
 
         -- Armas Arrojadizas
         [`WEAPON_GRENADE`] = "Granada",
         [`WEAPON_BZGAS`] = "Gas BZ",
         [`WEAPON_SMOKEGRENADE`] = "Granada de Humo",
         [`WEAPON_FLARE`] = "Bengala",
         [`WEAPON_MOLOTOV`] = "Cóctel Molotov",
         [`WEAPON_STICKYBOMB`] = "Bomba Lapa",
         [`WEAPON_PROXMINE`] = "Mina de Proximidad",
         [`WEAPON_SNOWBALL`] = "Bola de Nieve",
         [`WEAPON_PIPEBOMB`] = "Bomba de Tubo",
         [`WEAPON_BALL`] = "Pelota",
 
         -- Otros
         [`WEAPON_PETROLCAN`] = "Bidón de Gasolina",
         [`WEAPON_FIREEXTINGUISHER`] = "Extintor",
         [`WEAPON_PARACHUTE`] = "Paracaídas"
    }
    while true do
        local ped = PlayerPedId()
        local currentWeapon = GetSelectedPedWeapon(ped)
        local weaponName = weaponNames[currentWeapon] or "Desconocido"
        local ammoCount = 0

        if currentWeapon ~= `WEAPON_UNARMED` then
            ammoCount = GetAmmoInPedWeapon(ped, currentWeapon)
        end

        SendNUIMessage({
            action = 'updateWeapon',
            data = {
                weapon = weaponName,
                ammo = ammoCount
            }
        })

        Wait(200)
    end
end)

CreateThread(function()
    while true do
        local PlayerData = QBCore.Functions.GetPlayerData()
        
        if PlayerData.items then
            for _, item in pairs(PlayerData.items) do
                if item.name == "blackmoney" then
                    blackMoneyAmount = item.amount
                    break
                end
            end
        end

        if PlayerData and PlayerData.citizenid then
            SendNUIMessage({
                action = 'updateHUD',
                data = {
                    health = GetEntityHealth(PlayerPedId()) - 100,
                    armor = GetPedArmour(PlayerPedId()),
                    hunger = PlayerData.metadata['hunger'],
                    thirst = PlayerData.metadata['thirst'],
                    stamina = GetPlayerStamina(PlayerId()),
                    oxygen = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10,
                    cash = PlayerData.money['cash'] or 0,
                    bank = PlayerData.money['bank'] or 0,
                    blackmoney = blackMoneyAmount
                }
            })
        end
        Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle ~= 0 and not IsPedInAnyHeli(playerPed) and not IsPedInAnyPlane(playerPed) then
            local speed = math.floor(GetEntitySpeed(vehicle) * 3.6)
            local fuel = exports['LegacyFuel']:GetFuel(vehicle)
            SendNUIMessage({
                action = 'updateSpeed',
                data = {
                    speed = speed,
                    fuel = fuel,
                    inVehicle = true
                }
            })
        else
            SendNUIMessage({
                action = 'updateSpeed',
                data = {
                    speed = 0,
                    fuel = 0,
                    inVehicle = false
                }
            })
        end
        Wait(500) 
    end
end)

CreateThread(function()
    while true do
        QBCore.Functions.TriggerCallback('getPlayerJob', function(jobInfo)
            if jobInfo then
                SendNUIMessage({
                    action = 'updateRole',
                    data = {
                        role = jobInfo.job or 'Sin trabajo',
                        grade = jobInfo.grade or '0'
                    }
                })
            end
        end)
        Wait(1000)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    isHUDVisible = true
    SendNUIMessage({
        action = 'toggleHUD',
        data = {
            visible = true
        }
    })
    
    local PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData then
        QBCore.Functions.TriggerCallback('getPlayerJob', function(jobInfo)
            if jobInfo then
                SendNUIMessage({
                    action = 'updateRole',
                    data = {
                        role = jobInfo.job,
                        grade = jobInfo.grade
                    }
                })
            end
        end)
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    SendNUIMessage({
        action = 'updateRole',
        data = {
            role = JobInfo.label,
            grade = JobInfo.grade.name
        }
    })
end)

function showHUD()
    isHUDVisible = true
    SendNUIMessage({
        action = 'toggleHUD',
        data = {
            visible = true
        }
    })
end

function hideHUD()
    isHUDVisible = false
    SendNUIMessage({
        action = 'toggleHUD',
        data = {
            visible = false
        }
    })
end

exports('showHUD', showHUD)
exports('hideHUD', hideHUD)
exports('isHUDVisible', function() return isHUDVisible end)

RegisterCommand('showhud', function(source, args, rawCommand)
    showHUD()
    TriggerEvent('QBCore:Notify', 'HUD Shown')
end, false)

RegisterCommand('hidehud', function(source, args, rawCommand)
    hideHUD()
    TriggerEvent('QBCore:Notify', 'HUD Hidden')
end, false)