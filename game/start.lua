--------------------------------------------------------------------------------
-- Hurray, it's a game!
--------------------------------------------------------------------------------

-- Game Loads
local input = assert(loadfile("game/input.lua"))
input()

-- From tile sheet list
local background_tile = tiles.add(MOAITileDeck2D, "art/background.png", 1, 1)
local tiles_1 = tiles.add(MOAITileDeck2D, "art/tiles_1.png", 5, 5)
local tiles_2 = tiles.add(MOAITileDeck2D, "art/tiles_2.png", 5, 5)

-- From layer list
local background_layer = layers:addLayer()
background_layer:setViewport(config.viewport)
MOAIRenderMgr.pushRenderPass(background_layer)

local map_layer = layers:addLayer()
map_layer:setViewport(config.viewport)
MOAIRenderMgr.pushRenderPass(map_layer)

render:init()

local map = Map:new(nil)
local map_prop = MOAIProp2D.new()

map_prop:setDeck(tiles_1)
map_prop:setGrid(map:active_section())
map_prop:setPiv(config.viewport_width / 2, (config.viewport_height / 2) + (128 * 6.25))
map_layer:insertProp(map_prop)

local bg_map = MOAIGrid.new()
bg_map:initRectGrid(4, 4, 1200, 1200)
bg_map:setRow(04, 0x01, 0x01, 0x01, 0x01)
bg_map:setRow(03, 0x01, 0x01, 0x01, 0x01)
bg_map:setRow(02, 0x01, 0x01, 0x01, 0x01)
bg_map:setRow(01, 0x01, 0x01, 0x01, 0x01)

local bgmap_prop = MOAIProp2D.new()
bgmap_prop:setDeck(background_tile)
bgmap_prop:setGrid(bg_map)
bgmap_prop:setPiv(config.viewport_width / 2, (config.viewport_height / 2) + (128 * 6.25))
background_layer:insertProp(bgmap_prop)

