---@Vars
PlayerData = {
    money = {
        cash = 0,
        bank = 0
    },
    job = {
        label = '',
        grade = {
            name = ''
        }
    },
    metadata = {
        hunger = 0,
        thirst = 0
    },
    items = {}
}

local firstTime = true

---@Funcs
function Notify(...)
    if GetResourceState('es_extended'):match('start') and ESX then
        ESX.ShowNotification(...)
    elseif GetResourceState('qb-core'):match('start') and QBCore then
        QBCore.Functions.Notify(...)
    else
        AddTextEntry('CHAR_SOCIAL_CLUB', 'DF_HUD')
        BeginTextCommandThefeedPost('CHAR_SOCIAL_CLUB')
        AddTextComponentSubstringPlayerName(...)
        EndTextCommandThefeedPostTicker(false, false)
    end
end

function GetFuel(vehicle)
    if GetResourceState('LegacyFuel'):match('start') then
        return exports['LegacyFuel']:GetFuel(vehicle)
    elseif GetResourceState('ox_fuel'):match('start') then
        return Entity(vehicle).state.fuel
    else
        return GetVehicleFuelLevel(vehicle)
    end
end

function GetPlayerData()
    local forced = firstTime

    if firstTime then
        firstTime = false
    end

    if GetResourceState('es_extended'):match('start') then
        if forced then
            local playerData = ESX.GetPlayerData()
            local accounts = {}
            local hunger, thirst

            TriggerEvent('esx_status:getStatus', 'hunger', function(status)
                hunger = math.floor(status.percent)
            end)

            TriggerEvent('esx_status:getStatus', 'thirst', function(status)
                thirst = math.floor(status.percent)
            end)

            for k, v in pairs(playerData.accounts) do
                accounts[v.name] = v.money
            end

            PlayerData.metadata = {
                hunger = hunger,
                thirst = thirst
            }
            PlayerData.job = {
                label = playerData.job.label,
                grade = {
                    name = playerData.job.grade_label,
                }
            }
            PlayerData.money = accounts
        end

        return PlayerData
    elseif GetResourceState('qb-core'):match('start') then
        local playerData = QBCore.Functions.GetPlayerData()
        if forced then
            PlayerData.metadata = {
                hunger = playerData.metadata.hunger,
                thirst = playerData.metadata.thirst
            }
            PlayerData.job = {
                label = playerData.job.label,
                grade = {
                    name = playerData.job.grade.name,
                }
            }
            PlayerData.money = playerData.money
        end
        PlayerData.items = playerData.items
        return PlayerData
    else
        return PlayerData
    end
end

function GetWeaponData(currentWeapon)
    if GetResourceState('es_extended'):match('start') then
        return { label = ESX.GetWeaponLabel(currentWeapon) }
    elseif GetResourceState('qb-core'):match('start') then
        return QBCore.Shared.Weapons[currentWeapon]
    else
        return nil
    end
end

function IsPlayerLoaded()
    if GetResourceState('es_extended'):match('start') then
        return ESX.PlayerLoaded or ESX.IsPlayerLoaded()
    elseif GetResourceState('qb-core'):match('start') then
        return LocalPlayer.state.isLoggedIn
    else
        return true
    end
end

function CustomGetBlackMoney(items)
    if GetResourceState('qb-core') ~= "started" then
        return 0
    end
end

---@Events
RegisterNetEvent('esx_status:onTick', function(data)
    for i = 1, #data do
        PlayerData.metadata[data[i].name] = math.floor(data[i].percent)
    end
end)


RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
    PlayerData.metadata.hunger = math.floor(newHunger)
    PlayerData.metadata.thirst = math.floor(newThirst)
end)

if GetResourceState('qbx_core'):match('start') then
    for _, key in ipairs({ "hunger", "thirst", "stress" }) do
        AddStateBagChangeHandler(key, ('player:%s'):format(GetPlayerServerId()), function(_, _, value)
            if PlayerData.metadata[key] then PlayerData.metadata[key] = math.floor(value) end
        end)

        if GetResourceState('qbx_core'):match('start') then
            PlayerData.metadata[key] = math.floor(LocalPlayer.state[key])
        end
    end
end


RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = {
        label = job.label,
        grade = {
            name = job.grade_name,
        }
    }
end)

RegisterNetEvent('esx:setAccountMoney', function(account)
    PlayerData.money[(account.name == "money" and "cash" or account.name)] = account.money
end)

RegisterNetEvent('QBCore:Client:OnMoneyChange', function(account, amount)
    if not PlayerData.money[account] then
        return
    end

    PlayerData.money[account] = amount
end)
