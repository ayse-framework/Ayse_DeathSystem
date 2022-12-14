IsDown = false
IsDead = false
secondsRemaining = Config.BleedoutTimer
local ReviveTimer = Config.ReviveTime
local RespawnTimer = Config.RespawnTime
local ReviveTimerShow = false
local RespawnTimerShow = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if secondsRemaining > 0 and IsDown or IsDead == true then
            secondsRemaining = secondsRemaining -1
		end
    end
end)

Citizen.CreateThread(function()
    while true do
    	local health = GetEntityHealth(PlayerPedId(-1))
        Citizen.Wait(0)
		if health > Config.DeadHealth and health < Config.DownHealth then
			IsDown = true
			IsDead = false
	    end
	end
end)

Citizen.CreateThread(function()
    while true do
    	local health = GetEntityHealth(PlayerPedId(-1))
        Citizen.Wait(0)
		if health < Config.DeadHealth then
			IsDown = false
			IsDead = true
	    end
	end
end)

Citizen.CreateThread(function()
    while true do
    	local ped = PlayerPedId(-1)
        Citizen.Wait(0)
        if IsDown == true then
			SetEnableHandcuffs(ped, true)
    		exports.spawnmanager:setAutoSpawn(false)        
        	DownText()
        	SetEntityHealth(ped, 200)
			loadAnimDict( "random@dealgonewrong" )
			TaskPlayAnim(PlayerPedId(-1), "random@dealgonewrong", "idle_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
    	local ped = PlayerPedId(-1)
        Citizen.Wait(0)
        if IsDead == true then
			SetEnableHandcuffs(ped, true)
    		exports.spawnmanager:setAutoSpawn(false)
        	DeadText()
        	SetEntityHealth(ped, 200)
			loadAnimDict( "dead" )
			TaskPlayAnim(PlayerPedId(-1), "dead", "dead_a", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
		end
	end
end)

RegisterCommand("down", function(source, args, rawCommand)
	IsDead = false
	IsDown = true
end)

RegisterCommand("die", function(source, args, rawCommand)
	IsDown = false
	IsDead = true
end)

RegisterCommand("revive", function(source, args, rawCommand)   
    if IsDown or IsDead == true then
		RevivePlayer()
    end     
end)

RegisterCommand("respawn", function(source, args, rawCommand)   
    if IsDown or IsDead == true then
		RespawnPlayer()
    end     
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)

		if IsDead or IsDown == true then
			if IsControlPressed(0, 51) then
				ReviveTimerShow = true
				text("~n~~w~You will be revived in ~r~" .. ReviveTimer .. " ~w~seconds")
			elseif IsControlReleased(0, 51) then
				ReviveTimerShow = false
				ReviveTimer = Config.ReviveTime
			end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)

		if IsDead or IsDown == true then
			if IsControlPressed(0, 45) then
				RespawnTimerShow = true
				text("~n~~w~You will respawn in ~r~" .. RespawnTimer .. " ~w~seconds")
			elseif IsControlReleased(0, 45) then
				RespawnTimerShow = false
				RespawnTimer = Config.RespawnTime
			end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1000)

		if ReviveTimerShow == true then
			if ReviveTimer > 0 then
				ReviveTimer = ReviveTimer -1
			elseif ReviveTimer == 0 then
				ReviveTimer = Config.ReviveTime
				RevivePlayer()
				ReviveTimerShow = false
			end
		elseif RespawnTimerShow == true then
			if RespawnTimer > 0 then
				RespawnTimer = RespawnTimer -1
			elseif RespawnTimer == 0 then
				RespawnTimer = Config.RespawnTime
				RespawnPlayer()
				RespawnTimerShow = false
			end
		end
	end
end)
