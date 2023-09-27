fx_version 'adamant'
lua54 'yes'
game 'gta5'

version '1.0.0'

server_scripts {
	'@es_extended/locale.lua',
	'server/*.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'client/*.lua'
}

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'shared/*.lua'
}
