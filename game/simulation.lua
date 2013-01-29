require "game.generated.base"

SimulationGrid = { }

function SimulationGrid:new(m)
    assert (self ~= nil, "It's :new, not .new, Newman.")
    m = m or {}
    setmetatable(m, self)

    -- Fetch a tileset for this grid
    self.tileset = tiles.addTileset( game.generated.base ) 

    -- Create a view layer for this grid
    self.map_layer = layers.addLayer()
    self.map_layer:setViewport(config.viewport)
    MOAIRenderMgr.pushRenderPass(self.map_layer)

    -- Create a logical grid
    self.grid = Map:new(nil, nil, game.generated.base.width, game.generated.base.height, game.generated.base.tiles.outer_grid)

    -- Create display tiles for this grid
    self.tiles = MOAIProp2D.new()
    self.tiles:setDeck(self.tileset)
    self.tiles:setGrid(self.grid.grid)

    self.grid.prop = self.tiles

    local tiles_x = 0 - self.grid.tile_width * (self.grid.grid_width / 2) 
    local tiles_y = 0 - self.grid.tile_height * (self.grid.grid_height / 2)
    self.tiles:setLoc( tiles_x, tiles_y ) 

    self.map_layer:insertProp( self.tiles )
    self.__index = SimulationGrid

    -- Initialize dudes
    self.dudes = Array:new()

    self.tick_functions = Array:new()
    
    return m
end

function SimulationGrid:handleClicks()
    local function returnFunction()
        local pointer = input.getPointer()
        log.info('game', "Got pointer, it's at x=" .. pointer.x .. " y=" .. pointer.y)
        local world_x, world_y = self.map_layer:wndToWorld(pointer.x, pointer.y)
        log.info('game', "At world coords x=" .. world_x .. " y=" .. world_y)
        local i,j,x,y = self.grid:worldToMap(self.tiles, world_x, world_y)
        log.info('game', "At map coords i=" .. i .. " j=" .. j .. " x=" .. x .. " y=" .. y)

        self.grid:setTile(x, y, game.generated.base.tiles.outer_grid)
    end
    return returnFunction
end

function SimulationGrid:addDude(dude)
    self.dudes:append( dude )
end

function SimulationGrid:addTick(func)
    self.tick_functions:append( func )
end

function SimulationGrid:mainLoop()
    self.counter = 0
    local loop = function()
        while true do
            local action = MOAITimer.new()
            action:setMode(MOAITimer.NORMAL)
            action:setSpeed(1)
            action:start()

            while action:isBusy() do
                coroutine:yield()
            end

            self:tick()

            coroutine:yield()
        end
    end
    self.thread = MOAICoroutine.new()
    self.thread:run(loop)
end

function SimulationGrid:tick()
    log.info('grid', "tick " .. self.counter)
    self.tick_functions:each( function( fn ) fn() end )
    self.counter = self.counter + 1
end
