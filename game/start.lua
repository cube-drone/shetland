--------------------------------------------------------------------------------
-- Hurray, it's a game!
--------------------------------------------------------------------------------

-- Game Loads
local input = assert(loadfile("game/input.lua"))
input()

-- From tile sheet list
local tiles_1 = tiles.add(MOAITileDeck2D, "art/tiles_1.png", 5, 5)
local tiles_2 = tiles.add(MOAITileDeck2D, "art/tiles_2.png", 5, 5)

-- From layer list
local map_layer = layers:addLayer()
map_layer:setViewport(config.viewport)
MOAIRenderMgr.pushRenderPass(map_layer)

render:init()

local map = Map:new(nil)
local map_prop = MOAIProp2D.new()

map_prop:setDeck(tiles_1)
map_prop:setGrid(map:active_section())

-- Binds to upper-left
map_prop:setPiv(config.viewport_width / 2, (config.viewport_height / 2) + (128 * 6.25))
map_layer:insertProp(map_prop)
