local ox_inventory = exports.ox_inventory
GlobalState.registerCooldown = false
GlobalState.safeCooldown = false

if Config.Framework == 'esx' then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
else
    -- Custom framework
end

-- Function to check the players distance to registers/safes/etc
local function checkPlayerDistance(source)
    local ped = GetPlayerPed(source)
    local playerPos = GetEntityCoords(ped)
    for _, locations in pairs(Config.Locations) do
        for _, location in pairs(locations) do
            local distance = #(playerPos - location)
            if distance < 5 then
                return true
            end
        end
    end
    return false
end

-- Function that gets the total number of Police online and returns it
lib.callback.register('lation_247robbery:policeCount', function(source)
    local policeCount = 0
    if Config.Framework == 'esx' then
        for _, player in pairs(ESX.GetExtendedPlayers()) do
            local job = player.getJob()
            for _, jobs in pairs(Config.PoliceJobs) do
                local jobNames = jobs
                if job.name == jobNames then
                    policeCount = policeCount + 1
                end
            end
        end
    elseif Config.Framework == 'qbcore' then
        for _, players in pairs(QBCore.Functions.GetPlayers()) do
            local player = QBCore.Functions.GetPlayer(players)
            local job = player.PlayerData.job
            for _, jobs in pairs(Config.PoliceJobs) do
                local jobNames = jobs
                if job.name == jobNames then
                    policeCount = policeCount + 1
                end
            end
        end
    else
        -- Custom framework
    end
    return policeCount
end)

-- Function that rewards the player upon a successful register robbery
lib.callback.register('lation_247robbery:registerSuccessful', function(source, verifyReward)
    local source = source
    local playerName = GetPlayerName(source)
    local distanceCheck = checkPlayerDistance(source)
    if verifyReward == true then
        if distanceCheck then
            if Config.RegisterRewardRandom then
                local rewardQuantity = math.random(Config.RegisterRewardMinQuantity, Config.RegisterRewardMaxQuantity)
                ox_inventory:AddItem(source, Config.RegisterRewardItem, rewardQuantity)
                -- Reward more/another item here, etc
                registerCooldown()
                return true
            else
                ox_inventory:AddItem(source, Config.RegisterRewardItem, Config.RegisterRewardQuantity)
                -- Reward more/another item here, etc
                registerCooldown()
                return true
            end
        else
            -- Potential cheating if player is not nearby any of the store coords
            print('Player: ' ..playerName.. ' (ID: '..source..') has attempted to get rewarded for a register robbery despite not being within range of any 24/7.')
            return false
        end
    else
        -- Potential cheating if verifyReward is false?
        print('Player: ' ..playerName.. ' (ID: '..source..') has attempted to get rewarded for a register robbery despite verifyReward not being true')
        return false
    end
end)

-- Function that rewards the player upon a successful safe robbery
lib.callback.register('lation_247robbery:safeSuccessful', function(source, verifyReward)
    local source = source
    local playerName = GetPlayerName(source)
    local distanceCheck = checkPlayerDistance(source)
    if verifyReward == true then
        if distanceCheck then
            if Config.SafeRewardRandom then
                local rewardQuantity = math.random(Config.SafeRewardMinQuantity, Config.SafeRewardMaxQuantity)
                ox_inventory:AddItem(source, Config.SafeRewardItem, rewardQuantity)
                -- Reward more/another item here, etc
                safeCooldown()
                return true
            else
                ox_inventory:AddItem(source, Config.SafeRewardItem, Config.SafeRewardQuantity)
                -- Reward more/another item here, etc
                safeCooldown()
                return true
            end
        else
            -- Potential cheating if player is not nearby any of the store coords
            print('Player: ' ..playerName.. ' (ID: '..source..') has attempted to get rewarded for a safe robbery despite not being within range of any 24/7.')
            return false
        end
    else
        -- Potential cheating if verifyReward is false?
        print('Player: ' ..playerName.. ' (ID: '..source..') has attempted to get rewarded for a safe robbery despite verifyReward not being true')
        return false
    end
end)

-- Function that gets the passed item & quantity and removes it
lib.callback.register('lation_247robbery:removeItem', function(source, item, quantity)
    ox_inventory:RemoveItem(source, item, quantity)
end)

-- Function that handles the register cooldowns
function registerCooldown()
    GlobalState.registerCooldown = true
    local cooldown = math.random(Config.RegisterMinCooldown * 60000, Config.RegisterMaxCooldown * 60000)
    local format = cooldown / 1000 / 60
    local cooldownRound = math.floor(format)
    print('24/7 register robbery cooldown now active for ' .. cooldownRound .. ' minutes')
    Wait(cooldown)
    print('24/7 register robbery cooldown now inactive')
    GlobalState.registerCooldown = false
end

-- Function that handles the safe cooldowns
function safeCooldown()
    GlobalState.safeCooldown = true
    local cooldown = math.random(Config.SafeMinCooldown * 60000, Config.SafeMaxCooldown * 60000)
    local format = cooldown / 1000 / 60
    local cooldownRound = math.floor(format)
    print('24/7 safe robbery cooldown now active for ' .. cooldownRound .. ' minutes')
    Wait(cooldown)
    print('24/7 safe robbery cooldown now inactive')
    GlobalState.safeCooldown = false
end