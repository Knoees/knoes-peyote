fx_version 'cerulean'
games { 'gta5' }

lua54 'yes'

client_scripts {
	'client/peyote.lua',
	'client/target.lua',
	'config.lua',
}

server_scripts {
	'server/peyote.lua',
}

shared_scripts {
	'@PolyZone/client.lua',
    '@PolyZone/CircleZone.lua',
	'@qb-core/shared/locale.lua',
	'locales/en.lua',
	'config.lua',
}