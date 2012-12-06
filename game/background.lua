local background_tile = tiles.add(MOAITileDeck2D, "art/background.png", 1, 1)
local background_layer = layers.addLayer()

background_layer:setViewport(config.viewport)
MOAIRenderMgr.pushRenderPass(background_layer)

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
