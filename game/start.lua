--------------------------------------------------------------------------------
-- Hurray, it's a game!
--------------------------------------------------------------------------------

-- God damn globals

background_layer = nil
map_layer = nil
person_layer = nil
gui_layer = nil

primary_map = nil

-- Game Loads
require 'game.input'
require 'game.background'
require "game.tiles" 
require 'game.person'
require 'game.simulation'

render:init()

local simulation_grid = SimulationGrid:new()
simulation_grid:mainLoop()

local dude = Person:new(nil)
dude:setMap(primary_map)
dude:setPosition(0, 0)

local function moveDude()
    dir = math.random(4)

    log.info("game", "Moving")

    local last_i, last_j = dude:getLastMapPosition()
    local i = last_i
    local j = last_j

    if dir == 1 then
        j = j- 1
    elseif dir == 2 then
        j = j + 1
    elseif dir == 3 then
        i = i - 1
    elseif dir == 4 then
        i = i + 1
    end

    dude:moveTo(i, j)
end

input.registerEventCallback("UP", function() dude:setDirection(Person.MOVE_AWAY) end )
input.registerEventCallback("DOWN", function() dude:setDirection(Person.MOVE_TOWARDS) end )
input.registerEventCallback("LEFT", function() dude:setDirection(Person.MOVE_LEFT) end )
input.registerEventCallback("RIGHT", function() dude:setDirection(Person.MOVE_RIGHT) end )
input.registerEventCallback( 'PRIMARY_POINTER_DOWN', simulation_grid:handleClicks() );
input.registerEventCallback("PEW", moveDude)
