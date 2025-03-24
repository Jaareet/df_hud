Config = {}

Config.UpdateInterval = 1000 -- Intervalo de actualización en ms
Config.ShowMinimap = true    -- true | "incar"
Config.UseKMH = true         -- false para MPH


ESX, QBCore = nil, nil

if GetResourceState('es_extended'):match('start') then
    ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qb-core'):match('start') then
    QBCore = exports['qb-core']:GetCoreObject()
end
