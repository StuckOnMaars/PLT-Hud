Integrations = Integrations or {}

Integrations.Fuel = {
  resource = nil
}

function Integrations.Fuel:Detect()
  if not Config.Integrations.fuel.enabled then return false end
  for _, provider in ipairs(Config.Integrations.fuel.providers) do
    if GetResourceState(provider) == 'started' then
      self.resource = provider
      return true
    end
  end
  return false
end

function Integrations.Fuel:GetFuel(vehicle)
  if not vehicle or vehicle == 0 then return 0 end
  if self.resource == 'LegacyFuel' then
    return exports['LegacyFuel']:GetFuel(vehicle)
  elseif self.resource == 'ps-fuel' then
    return exports['ps-fuel']:GetFuel(vehicle)
  elseif self.resource == 'cdn-fuel' then
    return exports['cdn-fuel']:GetFuel(vehicle)
  end
  return GetVehicleFuelLevel(vehicle)
end
