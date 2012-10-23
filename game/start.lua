--------------------------------------------------------------------------------
-- Hurray, it's a game!
--------------------------------------------------------------------------------

-- From tile sheet list
local tiles_1 = tiles.add("art/tiles_1.png", 5, 5)
local tiles_2 = tiles.add("art/tiles_2.png", 5, 5)

-- From layer list
layer = layers:add()
layer:setViewport(config.viewport)

render:init()