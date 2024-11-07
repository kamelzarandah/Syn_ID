local open = false
local playerid = 0
local tgt = 0
local sexs
local showing = false
RegisterNetEvent('syn_id:open')
AddEventHandler('syn_id:open', function( data, type,sex,playerid )
	showing = true
	sexs = sex
	SendNUIMessage({
		action = "open",
		id = playerid,
		array  = data,
		type   = type,
		sex = sexs
	})
end)
RegisterNUICallback('close', function(data)
	showing = false
end)


RegisterCommand("idcard",function()
	if not showing then
	
        local closestPlayer, closestDistance, playerid, tgt1 = GetClosestPlayer()
		if closestPlayer ~= -1 and closestDistance <= 2.0  then
			if playerid ~= GetPlayerServerId(GetPlayerIndex()) then 
				TriggerServerEvent("syn_id:open",playerid)
			end
		end
	end
end,false)

RegisterCommand("takeid",function()
	if not showing then
        local closestPlayer, closestDistance, playerid, tgt1 = GetClosestPlayer()
		if closestPlayer ~= -1 and closestDistance <= 2.0  then			
			local hogtied =  Citizen.InvokeNative(0x3AA24CCC0D451379, tgt1)
            local handcuffed = Citizen.InvokeNative(0x74E559B3BC910685, tgt1)
			local isDead = IsEntityDead(tgt1)
			local targgt = GetPlayerServerId()

			if hogtied or handcuffed or isDead then 
				TriggerServerEvent("syn_id:open2",targgt)
			else
				TriggerEvent("vorp:TipBottom", "Target is not restrained", 4000)
			end
		end
		showing = true
	else
		SendNUIMessage({
			action = "close"
		})
		showing = false
	end
end,false)

function GetClosestPlayer()
    local players, closestDistance, closestPlayer = GetActivePlayers(), -1, -1
    local playerPed, playerId = PlayerPedId(), PlayerId()
    local coords, usePlayerPed = coords, false
    
    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        usePlayerPed = true
        coords = GetEntityCoords(playerPed)
    end
    
    for i=1, #players, 1 do
        local tgt = GetPlayerPed(players[i])
        if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then

            local targetCoords = GetEntityCoords(tgt)
            local distance = #(coords - targetCoords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = players[i]
                closestDistance = distance
                playerid = GetPlayerServerId(players[i])
                tgt1 = GetPlayerPed(players[i])
            end
        end
    end
    return closestPlayer, closestDistance,  playerid, tgt1
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if showing then 
			if IsControlJustReleased(1, 0x308588E6) then
				SendNUIMessage({
					action = "close"
				})
				open = false
			end
		end
	end
end)