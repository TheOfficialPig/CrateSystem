fx_version 'cerulean'
game 'gta5'

description 'SYNC Advanced Treasure'

server_scripts {
    '@qb-core/shared/locale.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

client_scripts {
    'client/main.lua',
}

shared_scripts {
    'config.lua',
}

dependencies {
    'qb-core',
}

escrow_ignore {
    'config.lua',
}

lua54 'yes'

data_file('DLC_ITYP_REQUEST')('stream/jrbTreasure_Chest.ytyp')

dependency '/assetpacks'