module(..., package.seeall)

require 'log'

local tiles = {}

function get(file_name)
   return tiles[file_name]
end


function add(type, file_name, size_w, size_h)
   if tiles[file_name] == nil then
      tiles[file_name] = type.new()
      tiles[file_name]:setTexture(file_name)
      tiles[file_name]:setSize(size_w, size_h)
      log.info("tiles", "Loaded tilesheet " .. file_name .. " (" .. size_w .. ", " .. size_h .. ")")
   end
   return tiles[file_name]
end

function addTileset( tileset )
    return add(MOAITileDeck2D, tileset.source, tileset.length, 1)
end

function remove(sheet)
   if tiles[sheet] ~= nil then
      tiles[sheet] = nil
      log.info("tiles",  "Removed tilesheet " .. sheet)
   end
   return true
end
