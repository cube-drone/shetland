module(..., package.seeall)

require 'log'

local eventCallbacks = {}

-- We should probably... load this from somewhere? 
local inputMap = {}

local pointer = { x = 0, y = 0 }

function getPointer()
   return pointer
end

function registerEventCallback( event, callbackFunction )
    if( eventCallbacks[event] == nil ) then
        eventCallbacks[event] = Array:new()
    end
    eventCallbacks[event]:append( callbackFunction ) 
    log.info('input', "Registered event callback " .. callbackFunction .. " to event " .. event)
end

function registerEvent( input, event)
    if( inputMap[input] == nil ) then
        inputMap[input] = Array:new()
    end
    inputMap[input]:append( event )
    log.info('input', "Registered event " .. event .. " to input " .. input)
end

local function dispatchEvent( input )
    local event = inputMap[input]
    if (event == nil) then
        log.info('input', "No binding found for " .. input)
        return
    else
        event = inputMap[key]
    end
    if(eventCallbacks[event] ~= nil) then
        eventCallbacks[event]:each( function( item ) item() end )
    end
end
 
function keyPressed( pressed, down )
   local status, err = pcall( 
      function()
         local key = "KEY_"
         if down == true then
            key = key .. "DOWN_"
         else 
            key = key .. "UP_"
         end 
         key = key .. string.upper(string.char(tostring(pressed)))
         dispatchEvent( key )
      end )
   if (not status) then
      log.error( 'input', err.code )
   end
end

function mouseLeftPressed( down )
   local status, err = pcall( 
      function()
         local key = "MOUSE_LEFT_"
         if down==true then
            key = key .. "DOWN"
         else
            key = key .. "UP"
         end 
         dispatchEvent( key )
      end )
   if (not status) then
      log.error( 'input', err.code )
   end
end

function mouseMiddlePressed( down )
   local status, err = pcall( 
      function()
         local key = "MOUSE_MIDDLE_"
         if down==true then
            key = key .. "DOWN"
         else
            key = key .. "UP"
         end 
         dispatchEvent( key )
      end )
   if (not status) then
      log.error( 'input', err.code )
   end
end

function mouseRightPressed( down )
   local status, err = pcall( 
      function()
         local key = "MOUSE_RIGHT_"
         if down==true then
            key = key .. "DOWN"
         else
            key = key .. "UP"
         end 
         dispatchEvent( key )
      end )
   if (not status) then
      log.error( 'input', err.code )
   end
end

function pointerMoved( x, y )
   local status, err = pcall( 
      function()
         local key = "POINTER_MOVED"
         pointer.x = x
         pointer.y = y
         dispatchEvent( key )
      end )
   if (not status) then
      log.error( 'input', err.code )
   end
end

if(MOAIInputMgr.device.keyboard) then
    log.info( 'input', "keyboard detected" )
    MOAIInputMgr.device.keyboard:setCallback( keyPressed )
else
    log.error( 'input', "No keyboard detected." ) 
end

if(MOAIInputMgr.device.pointer) then
    log.info( 'input', "pointer detected" )
    MOAIInputMgr.device.pointer:setCallback(pointerMoved)
else
    log.error( 'input', "No pointer detected." ) 
end

if(MOAIInputMgr.device.mouseLeft) then
    log.info( 'input', "Left Mouse Button detected" )
    MOAIInputMgr.device.mouseLeft:setCallback(mouseLeftPressed)
else
    log.error( 'input', "No Left Moust Button detected" )
end

if(MOAIInputMgr.device.mouseMiddle) then
    log.info( 'input', "Middle Mouse Button Detected")
    MOAIInputMgr.device.mouseMiddle:setCallback(mouseMiddlePressed)
else
    log.error( 'input', "No Middle Mouse Button Detected")
end

if(MOAIInputMgr.device.mouseRight) then
    log.info( 'input', "Right Mouse Button Detected")
    MOAIInputMgr.device.mouseRight:setCallback(mouseRightPressed)
else
    log.error( 'input', "No Right Mouse Button Detected")
end

for k,v in pairs(inputMap) do
    log.info( 'input', "registering event callback for " .. v )
    registerEventCallback( v, function() print("[input] "..v) end )
end

