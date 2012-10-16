require "config"

local window__width = MOAIEnvironment.screenWidth
local window_height = MOAIEnvironment.screenHeight
local settings = config.default_settings

if window_width == nil then
   window_width = settings.window_width
end
if window_height == nil then
   window_height = settings.window_height
end

MOAISim.openWindow(settings.window_name, settings.window_width, settings.window_height)

-- Need a viewport list, layer list, et cetera all in system

viewport = MOAIViewport.new()
viewport:setSize(window_width, window_height)
viewport:setScale(window_width, window_height)

layer = MOAILayer2D.new()
layer:setViewport(viewport)

-- Need render manager
local clr = settings.window_clear_color
MOAIGfxDevice.setClearColor(1, 1, 1, 1)
MOAIRenderMgr:pushRenderPass(layer)