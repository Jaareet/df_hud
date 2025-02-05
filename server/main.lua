local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('getPlayerJob', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        cb({
            job = Player.PlayerData.job.label,
            grade = Player.PlayerData.job.grade.name
        })
    else
        cb(nil)
    end
end)
