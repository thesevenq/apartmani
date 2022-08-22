fx_version 'cerulean'
game 'gta5'

ui_page "html/index.html"

shared_scripts {
  '@es_extended/imports.lua',
  'shared.lua',
}

files {
  "html/index.html",
  "html/index.js",
  "html/css/style.css",
  "html/fonts/*",
  "html/img/*",
}

client_scripts {
  'client.lua',
}
 server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server.lua',
 }
