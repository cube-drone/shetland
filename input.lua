module(..., package.seeall)

require 'util'

eventCallbacks = {}

-- We should probably... load this from somewhere? 
local inputMap = {}

-- Note that Moai doesn't have native support for 'arrow keys'
-- because Moai is a jerk. 

function registerEventCallback( event, callbackFunction )
    if( eventCallbacks[event] == nil ) then
        eventCallbacks[event] = Array:new()
    end
    eventCallbacks[event]:append( callbackFunction ) 
end

function keyPressed( key, down )
    if down==true then
        local status, err = pcall( function() 
            local event = keyMap[string.upper(string.char(tostring(key)))]
            if (event == nil) then
                event = keyMap[key]
            end
            if (event == nil) then
                return
            end
            if(eventCallbacks[event] ~= nil) then
                eventCallbacks[event]:each( function( item ) item() end )
            end
        end )
        if (not status) then
            print ("[input] Error: " + err.code )
        end
    end
end

if(MOAIInputMgr.device.keyboard) then
    print("[input] Keyboard Detected")
    MOAIInputMgr.device.keyboard:setCallback( keyPressed )
else
    print("[input] No Keyboard Detected. ");
end

for k,v in pairs(keyMap) do
    print( "[input] registering event callback for " .. v )
    registerEventCallback( v, function() print("[input] "..v) end )
end

