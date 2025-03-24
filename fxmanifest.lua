fx_version 'cerulean'
game 'gta5'

author 'Tito Gus && Jaareet'
description 'DF-HUD'
version '1.0.0'
lua54 'yes'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/**/*.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js'
}
