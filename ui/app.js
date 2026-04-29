const state = { components: {}, theme: {}, layout: {}, stats: {} };

const hud = document.getElementById('hud');
const bars = document.getElementById('bars');
const compass = document.getElementById('compass');
const locationLabel = document.getElementById('location');
const voice = document.getElementById('voice');
const vehicle = document.getElementById('vehicle');

const barOrder = ['health', 'armor', 'stamina', 'hunger', 'thirst'];

function applyTheme(theme) {
  Object.entries(theme).forEach(([k, v]) => {
    document.documentElement.style.setProperty(`--${k}`, v);
  });
}

function renderBars(values = {}) {
  bars.innerHTML = '';
  barOrder.forEach((key) => {
    if (!state.components[key]) return;
    const wrap = document.createElement('div');
    wrap.className = 'bar';
    const fill = document.createElement('div');
    fill.className = 'fill';
    fill.style.background = `var(--${key})`;
    fill.style.width = `${Math.max(0, Math.min(100, values[key] ?? 0))}%`;
    wrap.appendChild(fill);
    bars.appendChild(wrap);
  });
}

function applyLayout(layout, position) {
  hud.classList.toggle('vertical', layout.mode === 'vertical');
  document.documentElement.style.setProperty('--scale', layout.scale || 1);
  hud.style.left = `${position.x}vw`;
  hud.style.top = `${position.y}vh`;
}

window.addEventListener('message', ({ data }) => {
  if (!data || !data.action) return;

  switch (data.action) {
    case 'init':
    case 'reloadConfig':
      state.components = data.data.components;
      state.layout = data.data.layout;
      applyTheme(data.data.theme);
      applyLayout(state.layout, data.data.position);
      renderBars(state.stats);
      hud.classList.remove('hidden');
      break;
    case 'visibility':
      hud.classList.toggle('hidden', !data.data.visible);
      break;
    case 'stats':
      state.stats = data.data;
      renderBars(state.stats);
      break;
    case 'location':
      locationLabel.textContent = `${data.data.street || 'Unknown'} · ${data.data.zone || 'Unknown'} · ${data.data.postal || '----'}`;
      break;
    case 'compass':
      compass.textContent = `${data.data.cardinal} · ${String(data.data.heading).padStart(3, '0')}°`;
      break;
    case 'voice':
      voice.textContent = `VOICE: ${String(data.data.level || 'normal').toUpperCase()}`;
      voice.style.outline = data.data.talking ? '1px solid var(--voice)' : 'none';
      break;
    case 'vehicle':
      if (!data.data.show) {
        vehicle.classList.add('hidden');
        return;
      }
      vehicle.classList.remove('hidden');
      vehicle.textContent = `SPD ${data.data.speed} | GEAR ${data.data.gear} | RPM ${Math.floor((data.data.rpm || 0) * 100)} | FUEL ${Math.floor(data.data.fuel)}%${data.data.seatbelt ? ' | BELT' : ''}`;
      break;
  }
});
