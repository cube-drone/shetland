-- Handles big matrices of MOAIGrid maps

Map = { neighbours = {}, sections = {}, cur_i = 0, cur_j = 0 }

function Map:new(m)
    assert (self ~= nil, "It's :mew, not .meow, human.")
    m = m or { neighbours = {}, sections = {}, cur_i = 0, cur_j = 0, tile_width = config.map_tile_width, tile_height = config.map_tile_height, section_width = config.map_section_width, section_height = config.map_section_height, default_tile = config.map_default_tile }
    setmetatable(m, self)
    self.__index = Map
    m:activate_section(0, 0)
    return m
end

-- Recover from the cache or build a new entry
function Map:section_cache(i, j)
    if self:section_exists(i, j) then
        return self.sections[i][j]
    else 
        log.info("map", "Initializing a new map section at (" .. i .. ", " .. j .. ")")

        if self.sections[i] == nil then
            self.sections[i] = {}
        end 

        -- Create a new grid entry
        self.sections[i][j] = MOAIGrid.new()
        self.sections[i][j]:initRectGrid(self.section_width, self.section_height, self.tile_width, self.tile_height)

        -- Build the rows, but because they have dynamic length we have to be tricky
        for row=self.section_height,1,-1 do
            local lambda = "map:setRow(" .. row
            for col=1,self.section_width,1 do
                lambda = lambda .. ", " .. self.default_tile
            end 
            lambda = lambda .. ")"

            log.info("map", lambda)

            local context = { map = self.sections[i][j] }
            lambda = loadstring(lambda)
            setfenv(lambda, context)
            lambda()
        end
    end 
end

-- Check if exists
function Map:section_exists(i, j)
    return self.sections[i] ~= nil and self.sections[i][j] ~= nil
end

-- Get the active section
function Map:active_section()
    return self:section_cache(self.cur_i, self.cur_j)
end

-- Recover the an active neighbour
function Map:active_neighbour(dir)
    if dir == "left" then
        return self.neighbours[cur_i - 1][cur_j]
    elseif dir == "right" then
        return self.neighbours[cur_i + 1][cur_j]
    elseif dir == "up" then
        return self.neighbours[cur_i][cur_j - 1]
    elseif dir == "down" then
        return self.neighbours[cur_i][cur_j + 1]
    elseif dir == "leftup" then
        return self.neighbours[cur_i - 1][cur_j - 1]
    elseif dir == "leftdown" then
        return self.neighbours[cur_i - 1][cur_j + 1]
    elseif dir == "rightup" then
        return self.neighbours[cur_i + 1][cur_j - 1]
    elseif dir == "rightdown" then
        return self.neighbours[cur_i + 1][cur_j + 1]
    else
        log.error("map", "Unknown adjacency direction '" .. dir .. "'")
        return nil
    end
end

-- Activate a section directly
function Map:activate_section(i, j)
    log.info("map", "Activating section (" .. i .. ", " .. j .. ")")
    self.neighbours = {}
    for i2 = -1,1,2 do
        for j2 = -1,1,2 do
            if self.neighbours[i2] == nil then
                self.neighbours[i2] = {}
            end 
            if self:section_exists(i + i2, j + j2) then
                self.neighbours[i2][j2] = self:section_cache(i + i2, j + j2)
            else
                self.neighbours[i2][j2] = nil
            end
        end
    end
    self.cur_i = i
    self.cur_j = j
    log.info("map", "Activated section (" .. self.cur_i .. ", " .. self.cur_j .. ")")
    return self:section_cache(self.cur_i, self.cur_j)
end

-- Activate an adjacent section
function Map:activate_adjacent_section(dir)
    if dir == "left" then
        self:activate_section(cur_i - 1, cur_j)
    elseif dir == "right" then
        self:activate_section(cur_i + 1, cur_j)
    elseif dir == "up" then
        self:activate_section(cur_i, cur_j - 1)
    elseif dir == "down" then
        self:activate_section(cur_i, cur_j + 1)
    elseif dir == "leftup" then
        self:activate_section(cur_i - 1, cur_j - 1)
    elseif dir == "leftdown" then
        self:activate_section(cur_i - 1, cur_j + 1)
    elseif dir == "rightup" then
        self:activate_section(cur_i + 1, cur_j - 1)
    elseif dir == "rightdown" then
        self:activate_section(cur_i + 1, cur_j + 1)
    else
        log.error("map", "Unknown adjacency direction '" .. dir .. "'")
    end
end

-- Converts world coordinates to Map coordinates
-- Returns { i = section i, j = section j, x = tile x, y = tile y }
function Map:worldToMap(map_prop, x, y)
    local prop_x, prop_y = map_prop:getLoc()

    x = x - prop_x
    y = y - prop_y

    local section_world_width = self.section_width * self.tile_width
    local section_world_height = self.section_height * self.tile_height

    local section_i = (x - (x % section_world_width)) / section_world_width
    local section_j = (y - (y % section_world_height)) / section_world_height

    local tile_x = (x - (section_i * section_world_width) - (x % self.tile_width)) / self.tile_width + 1
    local tile_y = (y - (section_j * section_world_height) - (y % self.tile_height)) / self.tile_height + 1

    return section_i, section_j, tile_x, tile_y
end

-- Sets tilemap index for tile x,y on the active tile
function Map:setTile(x, y, value)
   return self:active_section():setTile(x, y, value)
end

-- Sets flags for tile x,y on the active tile
function Map:setTileFlags(x, y, mask)
   return self:active_section():setTileFlags(x, y, mask)
end
