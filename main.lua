require "config"
require "layers"

local window__width = MOAIEnvironment.screenWidth
local window_height = MOAIEnvironment.screenHeight

if window_width ~= nil then
   config.window_width = window_width
end
if window_height ~= nil then
   config.window_height = window_height
end

MOAISim.openWindow(config.window_name, config.window_width, config.window_height)

-- Need a viewport list, layer list, et cetera all in system

viewport = MOAIViewport.new()
viewport:setSize(config.window_width, config.window_height)
viewport:setScale(config.window_width, config.window_height)

layer = layers:add()
layer:setViewport(viewport)

-- Need render manager
local clr = config.window_clear_color
MOAIGfxDevice.setClearColor(1, 1, 1, 1)
MOAIRenderMgr:pushRenderPass(layer)