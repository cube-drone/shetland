require "config"
require "layers"
-- require "tiles"
require "util"

-- Window configuration

local window__width = MOAIEnvironment.screenWidth
local window_height = MOAIEnvironment.screenHeight

if window_width ~= nil then
   config.window_width = window_width
end
if window_height ~= nil then
   config.window_height = window_height
end

MOAISim.openWindow(config.window_name, config.window_width, config.window_height)

-- Need a viewport list

viewport = MOAIViewport.new()
viewport:setSize(config.window_width, config.window_height)
viewport:setScale(config.window_width, config.window_height)

-- From layer list

layer = layers:add()
layer:setViewport(viewport)

-- From tile sheet list

-- local tiles_1 = tiles.add("art/tiles_1.png", 5, 5)
-- local tiles_2 = tiles.add("art/tiles_2.png", 5, 5)

-- Need render manager
local clr = config.window_clear_color
MOAIGfxDevice.setClearColor(1, 1, 1, 1)
MOAIRenderMgr:pushRenderPass(layer)

util:repl()