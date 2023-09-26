ESX = exports["es_extended"]:getSharedObject()

lib.callback.register('sm_rpmenu:handcuff', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('sm_rpmenu:handcuff', target)
end)

lib.callback.register('sm_rpmenu:drag', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('sm_rpmenu:drag', target, source)
end)

lib.callback.register('sm_rpmenu:putInVehicle', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('sm_rpmenu:putInVehicle', target)
end)

lib.callback.register('sm_rpmenu:OutVehicle', function()
	local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('sm_rpmenu:OutVehicle', target)
end)

lib.callback.register('sm_rpmenu:requestarrest', function()
	_source = source
	TriggerClientEvent('sm_rpmenu:getarrested', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('sm_rpmenu:doarrested', _source)
end)

lib.callback.register('sm_rpmenu:requestrelease', function()
	_source = source
	TriggerClientEvent('sm_rpmenu:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('sm_rpmenu:douncuffing', _source)
end)

lib.callback.register('sm_rpmenu:getinfo', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('ox_lib:notify', -1, {position = 'top', description = '\nName: '..xPlayer.name..'            \nDate Of Birth: '..xPlayer.variables.dateofbirth..''})
end)