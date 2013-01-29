--------------------------------------------------------------------------------
-- Hurray, it's a game!
--------------------------------------------------------------------------------

-- God damn globals

background_layer = nil
map_layer = nil
person_layer = nil
gui_layer = nil

-- Game Loads
require 'game.input'
require 'game.background'
require 'game.person'
require 'game.simulation'

render:init()

local simulation_grid = SimulationGrid:new()
simulation_grid:mainLoop()

local dude = Person:new(nil)
dude:setMap(simulation_grid.grid)
dude:setPosition(5, 5)

local dude2 = Person:new(nil)
dude2:setMap(simulation_grid.grid)
dude2:setPosition(4, 5)

local function moveDude()
    dude:randomWalk()
    dude2:randomWalk()
end
simulation_grid:addTick(moveDude)

input.registerEventCallback("UP", function() dude:setDirection(Person.MOVE_AWAY) end )
input.registerEventCallback("DOWN", function() dude:setDirection(Person.MOVE_TOWARDS) end )
input.registerEventCallback("LEFT", function() dude:setDirection(Person.MOVE_LEFT) end )
input.registerEventCallback("RIGHT", function() dude:setDirection(Person.MOVE_RIGHT) end )
input.registerEventCallback( 'PRIMARY_POINTER_DOWN', simulation_grid:handleClicks() );
