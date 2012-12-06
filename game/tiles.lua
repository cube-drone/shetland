module(..., package.seeall)

require "game.generated.overlay"
require "game.generated.base" 

overlay = {  
            source="game/generated/overlay.png",
            height=game.generated.overlay.height,
            width=game.generated.overlay.width,
            length= game.generated.overlay.length,
            automated={  
                title='Automated',
                description='An automated tile cannot be activated by a human. Instead, it activates itself once every 10 years',
                tile=game.generated.overlay.tiles.automated,
            },
            self_powered={
                title='Self-Powered',
                description='A self-powered tile does not need to be powered to operate.',
                tile=game.generated.overlay.tiles.self_powered,
            },
            powered={
                title='Powered',
                description='Only powered tiles can be activated.',
                tile=game.generated.overlay.tiles.powered,
            },
            activated={
                title='Activated',
                description='',
                tile=game.generated.overlay.tiles.activated,
            },
        }

base = {  
            source="game/generated/base.png",
            width=game.generated.base.width,
            height=game.generated.base.height,
            size= game.generated.base.length,
            empty={  
                title='Empty',
                description='There is no tile here.',
                tile=game.generated.base.tiles.empty,
            },
            cafetoriax={
                title='Cafetoriax',
                description='Humans need food badly.',
                cost=5,
                tile=game.generated.base.tiles.cafetoriax,
            },
            power={
                title='Power Plant',
                description='Randomly powers 3 tiles.',
                cost=15,
                tile=game.generated.base.tiles.power,
            },
            auto_power={
                title='Automated Power Plant',
                description='Randomly powers 3 tiles every 10 turns.',
                cost=80,
                tile=game.generated.base.tiles.auto_power,
            },
            thresher={
                title='Thresher',
                description='Kills one human, then clogs until it is powered down and up again.',
                cost=5,
                tile=game.generated.base.tiles.thresher,
            },
            cryo={
                title='Cryo Chamber',
                description='Produces one human.',
                cost=10,
                tile=game.generated.base.tiles.cryo,
            },
            manufactorum={
                title='Manufactorm',
                description='Produces 1 coin when activated.',
                cost=10,
                tile=game.generated.base.tiles.manufactorum,
            },
        }

