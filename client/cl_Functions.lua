ESX = exports["es_extended"]:getSharedObject()

-- This code is taken from https://github.com/Mexalucard0/fivem-thiefmenu --

RegisterNetEvent('sm_rpmenu:getarrested')
AddEventHandler('sm_rpmenu:getarrested', function(playerheading, playercoords, playerlocation)
	playerPed = GetPlayerPed(-1)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(100)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	IsHandcuffed = true
	TriggerEvent('sm_rpmenu:handcuff')
end)

RegisterNetEvent('sm_rpmenu:doarrested')
AddEventHandler('sm_rpmenu:doarrested', function()
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Citizen.Wait(3000)
end) 

function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
		RemoveAnimDict(dictname)
	end
end

RegisterNetEvent('sm_rpmenu:unrestrain')
AddEventHandler('sm_rpmenu:unrestrain', function()
	if IsHandcuffed then
		local playerPed = PlayerPedId()
		IsHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)

		if Config.EnableHandcuffTimer and HandcuffTimer.active then
			ESX.ClearTimeout(HandcuffTimer.task)
		end
	end
end)

RegisterNetEvent('sm_rpmenu:douncuffing')
AddEventHandler('sm_rpmenu:douncuffing', function()
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('sm_rpmenu:getuncuffed')
AddEventHandler('sm_rpmenu:getuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	IsHandcuffed = false
	TriggerEvent('sm_rpmenu:handcuff')
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('sm_rpmenu:drag')
AddEventHandler('sm_rpmenu:drag', function(copId)
	if not IsHandcuffed then
		return
	end

	dragStatus.isDragged = not dragStatus.isDragged
	dragStatus.CopId = copId
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		Citizen.Wait(1)

		if IsHandcuffed then
			playerPed = PlayerPedId()

			if dragStatus.isDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end

				if IsPedDeadOrDying(targetPed, true) then
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end

			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('sm_rpmenu:putInVehicle')
AddEventHandler('sm_rpmenu:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if not IsHandcuffed then
		return
	end

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				dragStatus.isDragged = false
			end
		end
	end
end)

RegisterNetEvent('sm_rpmenu:OutVehicle')
AddEventHandler('sm_rpmenu:OutVehicle', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)

searchPlayer = function(player)
    if Config.Inventory == 'ox' then
		-- https://github.com/nwvh/wx_steal --
		lib.progressCircle({
			duration = 2500,
			label = "Searching Person...",
			position = 'bottom',
			useWhileDead = false,
			canCancel = true,
			disable = {
				car = true,
				move = true,
				combat = true,
			},
			anim = {
				dict = 'anim@gangops@facility@servers@bodysearch@',
				clip = 'player_search'
			},

		})
			exports.ox_inventory:openNearbyInventory()
    elseif Config.Inventory == 'qs' then
        TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", GetPlayerServerId(player))
    elseif Config.Inventory == 'custom' then
        -- INSERT CUSTOM SEARCH PLAYER FOR YOUR INVENTORY --
    end
end

exports('searchPlayer', searchPlayer)


AddEventHandler('sm_rpmenu:openperson', function(society)
	OpenPersonRP()
end)

AddEventHandler('sm_rpmenu:info', function(society)
	lib.callback('sm_rpmenu:getinfo') 
end)

AddEventHandler('sm_rpmenu:search', function(society)
	searchPlayer()
end)

AddEventHandler('sm_rpmenu:cuff', function(society)
	CuffPerson()
end)

AddEventHandler('sm_rpmenu:uncuff', function(society)
	UncuffPerson()
end)

AddEventHandler('sm_rpmenu:drag', function(society)
	DragPerson()
end)

AddEventHandler('sm_rpmenu:putin', function(society)
	PutInPerson()
end)

AddEventHandler('sm_rpmenu:putout', function(society)
	PutOutPerson()
end)

AddEventHandler('sm_rpmenu:carmenu', function(society)
	OpenCarMenu()
end)

function DragPerson()
  lib.callback('sm_rpmenu:drag', GetPlayerServerId(closestPlayer))
end

function PutInPerson()
  lib.callback('sm_rpmenu:putInVehicle', GetPlayerServerId(closestPlayer))
end

function PutOutPerson()
  lib.callback('sm_rpmenu:OutVehicle', GetPlayerServerId(closestPlayer))
end

function UncuffPerson()

  local target, distance = ESX.Game.GetClosestPlayer()
  playerheading = GetEntityHeading(GetPlayerPed(-1))
  playerlocation = GetEntityForwardVector(PlayerPedId())
  playerCoords = GetEntityCoords(GetPlayerPed(-1))
  local target_id = GetPlayerServerId(target)
  if distance <= 2.0 then
    lib.callback('sm_rpmenu:requestrelease', target_id, playerheading, playerCoords, playerlocation)
  end
end

function CuffPerson()

  local target, distance = ESX.Game.GetClosestPlayer()
  playerheading = GetEntityHeading(GetPlayerPed(-1))
  playerlocation = GetEntityForwardVector(PlayerPedId())
  playerCoords = GetEntityCoords(GetPlayerPed(-1))
  local target_id = GetPlayerServerId(target)
  if distance <= 2.0 then
    lib.callback('sm_rpmenu:requestarrest', target_id, playerheading, playerCoords, playerlocation)
  end
end
