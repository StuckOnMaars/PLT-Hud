# PLT HUD

Standalone, modular, production-ready FiveM HUD resource with NUI frontend.

## Installation
1. Copy `PLT-Hud` into your server `resources` folder.
2. Add `ensure PLT-Hud` in `server.cfg`.
3. Edit `config.lua` to fit your style and integration stack.

## Features
- Standalone (no ESX/QBCore dependency)
- Health, armor, stamina, optional hunger/thirst
- Minimap-friendly placement (does not replace GTA minimap)
- Compass + heading
- Street + zone + optional postal
- Voice integration adapter (`pma-voice`, extensible)
- Fuel integration adapter (`LegacyFuel`, `ps-fuel`, `cdn-fuel`)
- Vehicle HUD (speed/gear/rpm/fuel), seatbelt state
- Cinematic mode via `/hudcinematic`
- Live reload command `/hudreload` for config/UI refresh

## Commands
- `/hudreload` - reapplies layout/theme/component config at runtime
- `/hudcinematic` - toggles HUD and radar visibility
- `/seatbelt` - toggles seatbelt indicator

## Integrations Architecture
Adapters live in `/integrations`:
- `voice.lua`
- `fuel.lua`
- `postal.lua`

Each adapter pattern:
1. `:Detect()` auto-finds active provider resource.
2. `:Get...()` returns standardized HUD data.
3. Graceful fallback if no provider is found.

To add a new integration provider:
1. Add provider name to `Config.Integrations.<type>.providers`.
2. Extend matching adapter `if` block with export/event call.
3. Return normalized data shape.

## UI/Theming
- Theme colors are hex-based in `Config.Themes.palettes`.
- Position via preset or custom `x/y` vw/vh coordinates.
- Layout mode: horizontal or vertical.
- Component-level toggles in `Config.Components`.
- Resolution-independent CSS with scale multiplier.

## Performance Notes
- Uses split update loops with tuned intervals instead of one hot loop.
- NUI messages are compact and category-based.
- Integration detection runs once on startup.
- Idle usage target: 0.00–0.03 ms (depends on enabled features/server stack).
