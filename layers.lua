module(..., package.seeall)

local layers = {}

function getLayers()
   return layers
end

function getBottom() 
   return layers[1]
end

function getTop()
   return layers[table.getn(layers)]
end

function get(l)
   return layers[l]
end

function indexOf(layer)
   local idx = -1
   repeat idx = idx + 1 until layers[idx] == nil or layers[idx] == layer
   if idx == table.getn(layers) then
      return nil
   else
      return idx
   end
end

function add()
   layer = MOAILayer2D.new()
   table.insert(layers, layer)
   return getTop()
end

function remove(layer)
   local idx = indexOf(layer)
   if idx ~= nil then
      table.remove(layers, idx)
      return true
   else
      return false
   end
end
