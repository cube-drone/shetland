require "array"

layers = Array:new()

function layers:addLayer()
    layer = MOAILayer2D.new()
    self:append( layer )
    log.info( "layers", "Added layer" )
    return self:last()
end

function layers:getLayers()
   return self:getRaw()
end

function layers:removeLayer(layer)
    self:remove(layer)
    log.info( "layers", "Removed layer" )
end
