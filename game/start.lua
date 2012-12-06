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
