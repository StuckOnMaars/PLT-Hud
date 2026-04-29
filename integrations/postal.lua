Integrations = Integrations or {}

Integrations.Postal = {
  resource = nil,
  code = '----'
}

function Integrations.Postal:Detect()
  if not Config.Integrations.postal.enabled then return false end
  for _, provider in ipairs(Config.Integrations.postal.providers) do
    if GetResourceState(provider) == 'started' then
      self.resource = provider
      return true
    end
  end
  return false
end

function Integrations.Postal:GetPostal(coords)
  if not self.resource then return self.code end

  if self.resource == 'nearest-postal' then
    local ok, nearest = pcall(function()
      return exports['nearest-postal']:getPostal()
    end)
    if ok and nearest then self.code = tostring(nearest) end
  elseif self.resource == 'custom-postal' then
    local ok, nearest = pcall(function()
      return exports['custom-postal']:GetClosestPostal(coords)
    end)
    if ok and nearest then self.code = tostring(nearest) end
  end

  return self.code
end
