Integrations = Integrations or {}

Integrations.Voice = {
  resource = nil,
  state = { level = 'normal', proximity = 8.0, talking = false }
}

function Integrations.Voice:Detect()
  if not Config.Integrations.voice.enabled then return false end
  for _, provider in ipairs(Config.Integrations.voice.providers) do
    if GetResourceState(provider) == 'started' then
      self.resource = provider
      return true
    end
  end
  return false
end

function Integrations.Voice:GetState()
  if not self.resource then return self.state end

  if self.resource == 'pma-voice' then
    local prox = LocalPlayer and LocalPlayer.state and LocalPlayer.state.proximity and LocalPlayer.state.proximity.distance or 8.0
    local talking = NetworkIsPlayerTalking(PlayerId())
    local level = prox <= 3.0 and 'whisper' or (prox >= 15.0 and 'shout' or 'normal')
    self.state = { level = level, proximity = prox, talking = talking }
  else
    self.state.talking = NetworkIsPlayerTalking(PlayerId())
  end

  return self.state
end
