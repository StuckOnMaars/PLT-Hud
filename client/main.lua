local isHudVisible = true
local cached = {}
local seatbelt = false
local integrationsReady = false

local function clamp(n, min, max)
  if n < min then return min end
  if n > max then return max end
  return n
end

local function getLayoutPosition()
  if Config.Layout.positionPreset == 'custom' then
    return Config.Layout.custom
  end
  return Config.Presets[Config.Layout.positionPreset] or Config.Presets['bottom-left']
end

local function send(type, payload)
  SendNUIMessage({ action = type, data = payload })
end

local function safeDetect(ad)
  if not ad or not ad.Detect then return false end
  local ok, detected = pcall(function() return ad:Detect() end)
  return ok and detected
end

CreateThread(function()
  Wait(500)
  local voiceDetected = safeDetect(Integrations and Integrations.Voice)
  local fuelDetected = safeDetect(Integrations and Integrations.Fuel)
  local postalDetected = safeDetect(Integrations and Integrations.Postal)

  integrationsReady = true

  send('init', {
    components = Config.Components,
    layout = Config.Layout,
    position = getLayoutPosition(),
    theme = Config.Themes.palettes[Config.Themes.active],
    integrations = {
      voice = voiceDetected,
      fuel = fuelDetected,
      postal = postalDetected
    }
  })
end)

RegisterCommand('hudreload', function()
  if Config.AllowLiveReload then
    send('reloadConfig', {
      components = Config.Components,
      layout = Config.Layout,
      position = getLayoutPosition(),
      theme = Config.Themes.palettes[Config.Themes.active]
    })
  end
end, false)

RegisterCommand('hudcinematic', function()
  if not Config.Components.cinematic then return end
  isHudVisible = not isHudVisible
  DisplayRadar(isHudVisible)
  send('visibility', { visible = isHudVisible })
end, false)

RegisterCommand('seatbelt', function()
  seatbelt = not seatbelt
end, false)

CreateThread(function()
  while true do
    local sleep = Config.UpdateIntervals.hud
    local ped = PlayerPedId()
    local hp = clamp(GetEntityHealth(ped) - 100, 0, 100)
    local armor = clamp(GetPedArmour(ped), 0, 100)
    local stamina = clamp(100.0 - GetPlayerSprintStaminaRemaining(PlayerId()), 0.0, 100.0)

    send('stats', {
      health = hp,
      armor = armor,
      stamina = stamina,
      hunger = 0,
      thirst = 0
    })

    Wait(sleep)
  end
end)

CreateThread(function()
  while true do
    local sleep = Config.UpdateIntervals.street
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local street = GetStreetNameFromHashKey(streetHash)
    local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
    local postal = Config.Components.postal and integrationsReady and Integrations.Postal and Integrations.Postal:GetPostal(coords) or '----'

    send('location', {
      street = street,
      zone = zone,
      postal = postal
    })

    Wait(sleep)
  end
end)

CreateThread(function()
  while true do
    Wait(Config.UpdateIntervals.compass)
    local heading = math.floor(GetGameplayCamRot(0).z % 360)
    if heading < 0 then heading = heading + 360 end
    local dirs = { 'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW' }
    local idx = math.floor((heading + 22.5) / 45) % 8 + 1
    send('compass', { heading = heading, cardinal = dirs[idx] })
  end
end)

CreateThread(function()
  while true do
    Wait(Config.UpdateIntervals.voice)
    local voice = (Config.Components.voice and Integrations.Voice and Integrations.Voice:GetState()) or { level = 'normal', talking = false }
    send('voice', voice)
  end
end)

CreateThread(function()
  while true do
    Wait(Config.UpdateIntervals.vehicle)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
      local vehicle = GetVehiclePedIsIn(ped, false)
      local speed = GetEntitySpeed(vehicle) * (Config.Vehicle.mph and 2.236936 or 3.6)
      local gear = GetVehicleCurrentGear(vehicle)
      local rpm = GetVehicleCurrentRpm(vehicle)
      local fuel = (Config.Components.fuel and Integrations.Fuel and Integrations.Fuel:GetFuel(vehicle)) or GetVehicleFuelLevel(vehicle)

      send('vehicle', {
        show = true,
        speed = math.floor(speed + 0.5),
        gear = gear,
        rpm = rpm,
        fuel = clamp(fuel, 0, 100),
        seatbelt = seatbelt
      })
    else
      send('vehicle', { show = false })
      Wait(400)
    end
  end
end)
