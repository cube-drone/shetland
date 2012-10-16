module(..., package.seeall)

local layers = {}

function getBottom() 
   return layers[0]
end

function getTop()
   return layers[table.getn(layers)]
end

function get(l)
   return layers[l]
end


function add()
   layer = MOAILayer2D.new()
   table.insert(layers, layer)
   return getTop()
end

function remove(layer)
   local idx = -1
   repeat idx = idx + 1 until layers[idx] == nil or layers[idx] == layer
   if layers[idx] == layer then
      table.remove(layers, idx)
      return true
   else
      return false
   end
end
