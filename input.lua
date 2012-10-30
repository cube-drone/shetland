module(..., package.seeall)

require 'util'

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
    print("[input] Registered event callback " .. callbackFunction .. " to event " .. event)
end

function registerEvent( input, event)
    if( inputMap[input] == nil ) then
        inputMap[input] = Array:new()
    end
    inputMap[input]:append( event )
    print("[input] Registered event " .. event .. " to input " .. input)
end

local function dispatchEvent( input )
   local event = inputMap[input]
   if (event == nil) then
      print("[input] No binding found for " .. input)
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
      print ("[input] Error: " + err.code )
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
      print ("[input] Error: " + err.code )
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
      print ("[input] Error: " + err.code )
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
      print ("[input] Error: " + err.code )
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
      print ("[input] Error: " + err.code )
   end
end

if(MOAIInputMgr.device.keyboard) then
    print("[input] Keyboard Detected")
    MOAIInputMgr.device.keyboard:setCallback( keyPressed )
else
    print("[input] No Keyboard Detected. ");
end

if(MOAIInputMgr.device.pointer) then
   print("[input] Pointer Detected")
   MOAIInputMgr.device.pointer:setCallback(pointerMoved)
else
   print("[input] No Pointer Detected")
end

if(MOAIInputMgr.device.mouseLeft) then
   print("[input] Left Mouse Button Detected")
   MOAIInputMgr.device.mouseLeft:setCallback(mouseLeftPressed)
else
   print("[input] No Left Mouse Button Detected")
end

if(MOAIInputMgr.device.mouseMiddle) then
   print("[input] Middle Mouse Button Detected")
   MOAIInputMgr.device.mouseMiddle:setCallback(mouseMiddlePressed)
else
   print("[input] No Middle Mouse Button Detected")
end

if(MOAIInputMgr.device.mouseRight) then
   print("[input] Right Mouse Button Detected")
   MOAIInputMgr.device.mouseRight:setCallback(mouseRightPressed)
else
   print("[input] No Right Mouse Button Detected")
end

for k,v in pairs(inputMap) do
    print( "[input] registering event callback for " .. v )
    registerEventCallback( v, function() print("[input] "..v) end )
end

