--------------------------------------------------------------------------------
-- Hurray, it's a game!
--------------------------------------------------------------------------------

-- God damn globals

background_layer = nil
map_layer = nil
person_layer = nil
gui_layer = nil

-- Game Loads
require 'game/input'
require 'game/background'
require 'game/map'
require "game.tiles" 
require 'game/person'

render:init()

local dude = Person:new(nil)

input.registerEventCallback("UP", function() dude:setDirection(Person.MOVE_AWAY) end )
input.registerEventCallback("DOWN", function() dude:setDirection(Person.MOVE_TOWARDS) end )
input.registerEventCallback("LEFT", function() dude:setDirection(Person.MOVE_LEFT) end )
input.registerEventCallback("RIGHT", function() dude:setDirection(Person.MOVE_RIGHT) end )




