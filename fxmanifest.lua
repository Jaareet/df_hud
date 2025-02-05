shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield

fx_version 'cerulean'
game 'gta5'

description 'DF-HUD'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
 --   '@oxmysql/lib/MySQL.lua',
    'locales/es.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/minimap.lua'
}

server_scripts {
    'server/main.lua',
    '@oxmysql/lib/MySQL.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js'
}