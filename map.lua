-- Handles big matrices of MOAIGrid maps

Map = { neighbours = {}, sections = {}, cur_i = 0, cur_j = 0 }

function Map:new(m)
   assert (self ~= nil, "It's :mew, not .meow, human.")
   m = m or { neighbours = {}, sections = {}, cur_i = 0, cur_j = 0 }
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
      self.sections[i][j]:initRectGrid(config.map_section_width, config.map_section_height, config.map_tile_width, config.map_tile_height)

      -- Build the rows, but because they have dynamic length we have to be tricky
      for row=config.map_section_height,1,-1 do
         local lambda = "map:setRow(" .. row
         for col=1,config.map_section_width,1 do
            lambda = lambda .. ", " .. config.map_default_tile
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
