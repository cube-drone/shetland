package.path = package.path .. ";./?.lua"

-- Our additions to MOAI

require "config"
require "layers"
require "tiles"
require "util"
require "render"

-- Window configuration

local window_width = MOAIEnvironment.screenWidth
local window_height = MOAIEnvironment.screenHeight

if window_width ~= nil then
   config.window_width = window_width
end
if window_height ~= nil then
   config.window_height = window_height
end

MOAISim.openWindow(config.window_name, config.window_width, config.window_height)

-- Need a viewport list?
config.viewport = MOAIViewport.new()
config.viewport:setSize(config.window_width, config.window_height)
config.viewport:setScale(config.window_width, config.window_height)

local game = assert(loadfile("game/start.lua"))
game()
