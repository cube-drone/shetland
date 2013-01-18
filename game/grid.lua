
require "game.generated.base"

local tiles_outer_grid = tiles.addTileset( game.generated.base ) 
local outer_map_layer = layers.addLayer()
outer_map_layer:setViewport(config.viewport)
MOAIRenderMgr.pushRenderPass(outer_map_layer)
local outer_map = Map:new(nil, game.generated.base.width, game.generated.base.height, game.generated.base.tiles.outer_grid)
local outer_map_prop = MOAIProp2D.new()
outer_map_prop:setDeck(tiles_outer_grid)
outer_map_prop:setGrid(outer_map:activeSection())
outer_map_prop:setLoc(0 - outer_map.tile_width * (outer_map.section_width / 2), 0 - outer_map.tile_height * (outer_map.section_height / 2))
outer_map_layer:insertProp(outer_map_prop)

local tiles_inner_grid = tiles.addTileset( game.generated.base )
local inner_map_layer = layers.addLayer()
inner_map_layer:setViewport(config.viewport)
MOAIRenderMgr.pushRenderPass(inner_map_layer)
local inner_map = Map:new(nil, game.generated.base.width, game.generated.base.height, game.generated.base.tiles.inner_grid)
local inner_map_prop = MOAIProp2D.new()
inner_map_prop:setDeck(tiles_inner_grid)
inner_map_prop:setGrid(inner_map:activeSection())
inner_map_prop:setLoc(0 - inner_map.tile_width * (inner_map.section_width / 2), 0 - inner_map.tile_height * (inner_map.section_height / 2))
inner_map_layer:insertProp(inner_map_prop)
