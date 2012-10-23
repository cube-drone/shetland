module(..., package.seeall)

local tiles = {}

function get(file_name)
   return tiles[file_name]
end

function add(file_name, size_w, size_h)
   if tiles[file_name] == nil then
      tiles[file_name] = MOAITileDeck2D.new()
      tiles[file_name]:setTexture(file_name)
      tiles[file_name]:setSize(size_w, size_h)
      print("[tiles] Loaded tilesheet " .. file_name .. " (" .. size_w .. ", " .. size_h .. ")")
   end
   return tiles[file_name]
end

function remove(sheet)
   if tiles[sheet] ~= nil then
      tiles[sheet] = nil
      print("[tiles] Removed tilesheet " .. sheet)
   end
   return true
end
