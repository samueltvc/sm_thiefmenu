ESX = exports["es_extended"]:getSharedObject()

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

function OpenRPMenu()

  local DataJob = ESX.GetPlayerData()
  local job = DataJob.job.label
  local jobgrade = DataJob.job.grade_labe

lib.registerContext({
  id = 'sm_rpmenu',
  title = "Job - " ..job,
  options = {
    {
      title = Config.Lib.Information,
      icon = 'fa-solid fa-address-card',
      description = '',
      event = 'sm_rpmenu:info',
    },
    {
      title = Config.Lib.Search,
      icon = 'fa-solid fa-magnifying-glass',
      description = '',
      event = 'sm_rpmenu:search',
    },
    {
      title = Config.Lib.Cuff,
      icon = 'fa-solid fa-handcuffs',
      description = '',
      event = 'sm_rpmenu:cuff',
    },
    {
      title = Config.Lib.unCuff,
      icon = 'fa-solid fa-handcuffs',
      description = '',
      event = 'sm_rpmenu:uncuff',
    },
    {
      title = Config.Lib.grabPlayer,
      icon = 'fa-solid fa-user',
      description = '',
      event = 'sm_rpmenu:drag',
    },
    {
      title = Config.Lib.putIn,
      icon = 'fa-solid fa-car',
      description = '',
      event = 'sm_rpmenu:putin',
    },
    {
      title = Config.Lib.putOut,
      icon = 'fa-solid fa-car',
      description = '',
      event = 'sm_rpmenu:putout',
    },
  }
})
lib.showContext('sm_rpmenu')
end

RegisterCommand(Config.Command, function()
	if not isDead and not IsPedCuffed(PlayerPedId()) then
		OpenRPMenu()
	end
end)

RegisterKeyMapping(Config.Command, 'RP MENU', 'keyboard', Config.Hotkey)