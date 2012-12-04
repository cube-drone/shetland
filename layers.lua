module(..., package.seeall)

require "array"

the_layers = Array:new()

function addLayer()
    layer = MOAILayer2D.new()
    the_layers:append( layer )
    log.info( "layers", "Added layer" )
    return the_layers:last()
end

function getLayers()
   return the_layers:getRaw()
end

function removeLayer(layer)
    the_layers:remove(layer)
    log.info( "layers", "Removed layer" )
end

function get(idx)
    return the_layers:get(idx)
end
