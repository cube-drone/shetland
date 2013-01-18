-- Handles big matrices of MOAIGrid maps
-- A map is a giant grid of MOAIGrids, which aren't instantiated 
--      until they're accessed with section_cache.

Map = { neighbours = {}, sections = {}, cur_i = 0, cur_j = 0 }

function Map:new(m, tile_width, tile_height, default_tile)
    assert (self ~= nil, "It's :mew, not .meow, human.")
    m = m or { neighbours = {}, sections = {}, cur_i = 0, cur_j = 0, tile_width = tile_width, tile_height = tile_height, section_width = config.map_section_width, section_height = config.map_section_height, default_tile = default_tile }
    setmetatable(m, self)
    self.__index = Map
    m:activateSection(0, 0)
    return m
end

-- Recover from the cache or build a new entry
function Map:sectionCache(i, j)
    if self:sectionExists(i, j) then
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
function Map:sectionExists(i, j)
    return self.sections[i] ~= nil and self.sections[i][j] ~= nil
end

-- Get the active section
function Map:activeSection()
    return self:sectionCache(self.cur_i, self.cur_j)
end

-- Recover the an active neighbour
function Map:activeNeighbour(dir)
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
function Map:activateSection(i, j)
    log.info("map", "Activating section (" .. i .. ", " .. j .. ")")
    self.neighbours = {}
    for i2 = -1,1,2 do
        for j2 = -1,1,2 do
            if self.neighbours[i2] == nil then
                self.neighbours[i2] = {}
            end 
            if self:sectionExists(i + i2, j + j2) then
                self.neighbours[i2][j2] = self:sectionCache(i + i2, j + j2)
            else
                self.neighbours[i2][j2] = nil
            end
        end
    end
    self.cur_i = i
    self.cur_j = j
    log.info("map", "Activated section (" .. self.cur_i .. ", " .. self.cur_j .. ")")
    return self:sectionCache(self.cur_i, self.cur_j)
end

-- Activate an adjacent section
function Map:activateAdjacentSection(dir)
    if dir == "left" then
        self:activateSection(cur_i - 1, cur_j)
    elseif dir == "right" then
        self:activateSection(cur_i + 1, cur_j)
    elseif dir == "up" then
        self:activateSection(cur_i, cur_j - 1)
    elseif dir == "down" then
        self:activateSection(cur_i, cur_j + 1)
    elseif dir == "leftup" then
        self:activateSection(cur_i - 1, cur_j - 1)
    elseif dir == "leftdown" then
        self:activateSection(cur_i - 1, cur_j + 1)
    elseif dir == "rightup" then
        self:activateSection(cur_i + 1, cur_j - 1)
    elseif dir == "rightdown" then
        self:activateSection(cur_i + 1, cur_j + 1)
    else
        log.error("map", "Unknown adjacency direction '" .. dir .. "'")
    end
end

-- Converts world coordinates to Map coordinates
-- Returns { i = section i, j = section j, x = tile x, y = tile y }
function Map:stageToMap(map_prop, x, y)
    -- Get the base location, in stage coordinates, of the map prop
    local prop_x, prop_y = map_prop:getLoc()

    -- Get the relative location in stage coordinates
    x = x - prop_x
    y = y - prop_y

    -- Get the total width and height of this portion of the grid (maps to a MOAIGrid object dimensions)
    local section_world_width = self.section_width * self.tile_width
    local section_world_height = self.section_height * self.tile_height

    -- We now have enough to compute the section i,j; part 1:
    local section_i = (x - (x % section_world_width)) / section_world_width
    local section_j = (y - (y % section_world_height)) / section_world_height

    -- The value needs to be 'bucketed' in order to complete the i,j; part 2:
    local tile_x = (x - (section_i * section_world_width) - (x % self.tile_width)) / self.tile_width + 1
    local tile_y = (y - (section_j * section_world_height) - (y % self.tile_height)) / self.tile_height + 1

    -- Done!
    return section_i, section_j, tile_x, tile_y
end

function Map:mapToStage(map_prop, i, j)
    
end

-- Sets tilemap index for tile x,y on the active tile
function Map:setTile(x, y, value)
   return self:activeSection():setTile(x, y, value)
end

-- Sets flags for tile x,y on the active tile
function Map:setTileFlags(x, y, mask)
   return self:activeSection():setTileFlags(x, y, mask)
end
