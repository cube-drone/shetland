require "game.generated.base"

print( game.generated.base.source )

local tiles_1 = tiles.addTileset( game.generated.base ) 
local map_layer = layers.addLayer()

map_layer:setViewport(config.viewport)
MOAIRenderMgr.pushRenderPass(map_layer)

local map = Map:new(nil, game.generated.base.width, game.generated.base.height, game.generated.base.tiles.empty)
local map_prop = MOAIProp2D.new()

map_prop:setDeck(tiles_1)
map_prop:setGrid(map:activeSection())
map_prop:setLoc(0 - map.tile_width * (map.section_width / 2), 0 - map.tile_height * (map.section_height / 2))
map_layer:insertProp(map_prop)

function handleClicks()
    local pointer = input.getPointer()
    log.info('game', "Got pointer, it's at x=" .. pointer.x .. " y=" .. pointer.y)
    local world_x, world_y = map_layer:wndToWorld(pointer.x, pointer.y)
    log.info('game', "At world coords x=" .. world_x .. " y=" .. world_y)
    local i,j,x,y = map:worldToMap(map_prop, world_x, world_y)
    log.info('game', "At map coords i=" .. i .. " j=" .. j .. " x=" .. x .. " y=" .. y)

    map:setTile(x, y, game.generated.base.tiles.thresher)
end

input.registerEventCallback( 'PRIMARY_POINTER_DOWN', handleClicks );
