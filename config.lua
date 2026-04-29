Config = {}

Config.Debug = false
Config.UpdateIntervals = {
  hud = 150,
  compass = 200,
  street = 350,
  stamina = 120,
  voice = 200,
  vehicle = 120,
  integrations = 1000
}

Config.Layout = {
  mode = 'horizontal', -- horizontal | vertical
  scale = 1.0,
  positionPreset = 'bottom-left', -- bottom-left | bottom-center | custom
  custom = { x = 2.5, y = 78.0 },
  minimapAnchor = { x = 2.5, y = 71.0 }
}

Config.Components = {
  health = true,
  armor = true,
  stamina = true,
  hunger = false,
  thirst = false,
  minimap = true,
  compass = true,
  streetZone = true,
  voice = true,
  postal = true,
  fuel = true,
  vehicle = true,
  seatbelt = true,
  cinematic = true
}

Config.Themes = {
  active = 'dark',
  palettes = {
    dark = {
      background = '#111827CC',
      panel = '#1F2937D9',
      text = '#F9FAFB',
      muted = '#9CA3AF',
      health = '#EF4444',
      armor = '#60A5FA',
      stamina = '#10B981',
      hunger = '#F59E0B',
      thirst = '#06B6D4',
      voice = '#8B5CF6',
      fuel = '#22C55E',
      speed = '#E5E7EB',
      accent = '#38BDF8'
    },
    light = {
      background = '#FFFFFFD9',
      panel = '#F3F4F6E0',
      text = '#111827',
      muted = '#4B5563',
      health = '#DC2626',
      armor = '#2563EB',
      stamina = '#059669',
      hunger = '#D97706',
      thirst = '#0891B2',
      voice = '#7C3AED',
      fuel = '#16A34A',
      speed = '#1F2937',
      accent = '#0284C7'
    }
  }
}

Config.Presets = {
  ['bottom-left'] = { x = 2.5, y = 78.0 },
  ['bottom-center'] = { x = 38.0, y = 83.0 }
}

Config.Integrations = {
  voice = {
    enabled = true,
    providers = { 'pma-voice', 'saltychat' }
  },
  fuel = {
    enabled = true,
    providers = { 'LegacyFuel', 'ps-fuel', 'cdn-fuel' }
  },
  postal = {
    enabled = true,
    providers = { 'nearest-postal', 'custom-postal' }
  }
}

Config.Vehicle = {
  mph = true,
  showRpm = true,
  showGear = true
}

Config.AllowLiveReload = true
