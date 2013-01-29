Map = { prop = nil, tile_width = tile_width, tile_height = tile_height, grid_width = config.map_grid_width, grid_height = config.map_grid_height, states = {} }

-- Recover from the cache or build a new entry
local function initGrid(m)
    -- Create a new grid entry
    m.grid = MOAIGrid.new()
    m.grid:initRectGrid(m.grid_width, m.grid_height, m.tile_width, m.tile_height)

    -- Build the rows, but because they have dynamic length we have to be tricky
    for row=m.grid_height,1,-1 do
        local lambda = "map:setRow(" .. row
        for col=1,m.grid_width,1 do
            lambda = lambda .. ", " .. m.default_tile
        end 
        lambda = lambda .. ")"

        log.info("map", lambda)

        local context = { map = m.grid }
        lambda = loadstring(lambda)
        setfenv(lambda, context)
        lambda()
    end
end

function Map:new(m, prop, tile_width, tile_height, _default_tile)
    assert (self ~= nil, "It's :mew, not .meow, human.")
    m = m or { prop = nil, tile_width = tile_width, tile_height = tile_height, grid_width = config.map_grid_width, grid_height = config.map_grid_height, default_tile = _default_tile, grid = nil }
    m.prop = prop

    initGrid(m);

    setmetatable(m, self)
    self.__index = Map
    return m
end

function Map:isValid(i, j)
    return i > 0 and j > 0 and i < self.grid_width and j < self.grid_height
end

-- Converts world coordinates to Map coordinates
function Map:stageToMap(x, y)
    -- Get the base location, in stage coordinates, of the map prop
    local prop_x, prop_y = self.prop:getLoc()

    -- Get the relative location in stage coordinates
    x = x - prop_x
    y = y - prop_y

    -- Get the total width and height of this portion of the grid (maps to a MOAIGrid object dimensions)
    local grid_world_width = self.grid_width * self.tile_width
    local grid_world_height = self.grid_height * self.tile_height

    -- We now have enough to compute the grid i,j; part 1:
    local grid_i = (x - (x % grid_world_width)) / grid_world_width
    local grid_j = (y - (y % grid_world_height)) / grid_world_height

    -- The value needs to be 'bucketed' in order to complete the i,j; part 2:
    local tile_x = (x - (grid_i * grid_world_width) - (x % self.tile_width)) / self.tile_width + 1
    local tile_y = (y - (grid_j * grid_world_height) - (y % self.tile_height)) / self.tile_height + 1

    -- Done!
    return grid_i, grid_j, tile_x, tile_y
end

function Map:mapToStage(i, j)
    local prop_x, prop_y = self.prop:getLoc()

    local x = prop_x + (i * self.tile_width)
    local y = prop_y + (j * self.tile_height)

    return x, y
end

-- Sets tilemap index for tile x,y on the active tile
function Map:setTile(x, y, value)
   return self.grid:setTile(x, y, value)
end

-- Sets flags for tile x,y on the active tile
function Map:setTileFlags(x, y, mask)
   return self.grid:setTileFlags(x, y, mask)
end

-- Sets state for the position i,j on the map
function Map:setState(i, j, state)
    if self.states[i] == nil then
        self.states[i] = {}
    end
    self.states[i][j] = state
end

-- Gets the state for the position i,j on the map
function Map:getState(i, j)
    if self.states[i] == nil then
        self.states[i] = {}
    end
    if self.states[i][j] == nil then
        self.states[i][j] = {}
    end
    return self.states[i][j]
end
