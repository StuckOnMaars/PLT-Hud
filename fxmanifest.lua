fx_version 'cerulean'
game 'gta5'

name 'plt-hud'
author 'PLT'
description 'Standalone modular production-ready FiveM HUD'
version '1.0.0'

lua54 'yes'

ui_page 'ui/index.html'

files {
  'ui/index.html',
  'ui/style.css',
  'ui/app.js'
}

shared_scripts {
  'config.lua'
}

client_scripts {
  'integrations/*.lua',
  'client/main.lua'
}
