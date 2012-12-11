person_layer = layers.addLayer()

require "game.generated.mans"

local person_tiles = tiles.addTileset( game.generated.mans ) 
person_tiles:setRect(-16, -16, 16, 16)

person_layer:setViewport(config.viewport)
MOAIRenderMgr.pushRenderPass(person_layer)

Person = { prop = nil, tiles = person_tiles, data = {}, direction = 0, animation = nil, actions = nil, thread = nil, index = 1 }

Person.MOVE_TOWARDS = 0
Person.MOVE_AWAY = 1
Person.MOVE_RIGHT = 2
Person.MOVE_LEFT = 3

local walk_towards = { game.generated.mans.tiles.down_1, game.generated.mans.tiles.down_2 }
local walk_away = { game.generated.mans.tiles.up_1, game.generated.mans.tiles.up_2 }
local walk_right = { game.generated.mans.tiles.right_1, game.generated.mans.tiles.right_2 }
local walk_left = { game.generated.mans.tiles.left_1, game.generated.mans.tiles.left_2 }

local function initProp(p)
    p.prop = MOAIProp2D.new()
    p.prop:setDeck(p.tiles)

    p.prop:setIndex(p.index)

    p.prop:setPiv(0, 0)

    person_layer:insertProp(p.prop)
end

local function initAnimation(p)
    local animFunc = function()
        local direction = 1
        while true do
            local action = MOAITimer.new()
            action:setMode(MOAITimer.NORMAL)
            action:setSpeed(10)
            action:start()

            while action:isBusy() do
                coroutine:yield()
            end 

            local frame_list = nil
            if p.direction == Person.MOVE_TOWARDS then
                frame_list = walk_towards 
            elseif p.direction == Person.MOVE_AWAY then
                frame_list = walk_away 
            elseif p.direction == Person.MOVE_RIGHT then
                frame_list = walk_right
            elseif p.direction == Person.MOVE_LEFT then
                frame_list = walk_left
            end

            local next_index = p.index + direction
            if frame_list[next_index] ~= nil then
                p.index = next_index
            else 
                direction = direction * -1
                p.index = p.index + direction
            end 

            p.prop:setIndex(frame_list[p.index])

            coroutine:yield()
        end
    end
    p.thread = MOAICoroutine.new()
    p.thread:run(animFunc)
end

function Person:new(p)
    assert (self ~= nil, "It's :new, not .new, moron.")
    p = p or Person
    setmetatable( p, self )
    self.__index = Person

    initProp(p)
    initAnimation(p)

    return p
end

function Person:getThread()
    return self.thread
end

function Person:getDirection()
    return self.direction
end

function Person:setDirection(d)
    self.direction = d
end

function Person:getData()
    return self.data
end

function Person:setData(d)
    self.data = d
end

function Person:getActions()
    return self.actions
end

function Person:setActions(a)
    self.actions = a
end

