module(..., package.seeall)

local tiles = {}

function get(file_name)
   return tiles[file_name]
end

function add(file_name, size_w, size_h)
   if tiles[file_name] == nil then
      tiles[file_name] = MOAITileDeck2D.new()
      local sheet = tiles[file_name]
      sheet:setTexture(file_name)
      sheet:setSize(size_w, size_h)
   end
   return tables[file_name]
end

function remove(sheet)
   if tiles[sheet] ~= nil then
      tiles[sheet] = nil
   end
   return true
end
