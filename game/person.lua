person_layer = layers.addLayer()

require "game.generated.mans"

local person_tiles = tiles.addTileset( game.generated.mans ) 
person_tiles:setRect(-16, -16, 16, 16)

person_layer:setViewport(config.viewport)
MOAIRenderMgr.pushRenderPass(person_layer)

Person = { prop = nil, tiles = person_tiles, data = {}, direction = 0, animation = nil, actions = nil, thread = nil, index = 1, tick_speed = 10, movement = { map = nil, total_time = 10, current_time = 0, last_x = 0, last_y = 0, next_x = 0, next_y = 0, curve = nil, last_i = 0, last_j = 0, next_i = 0, next_j = 0 } }

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
            action:setSpeed(p.tick_speed)
            action:start()

            while action:isBusy() do
                coroutine:yield()
            end 

            -- Select animation frame

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

            local next_xndex = p.index + direction
            if frame_list[next_xndex] ~= nil then
                p.index = next_xndex
            else 
                direction = direction * -1
                p.index = p.index + direction
            end 

            p.prop:setIndex(frame_list[p.index])

            -- Move to new position if needed

            if p.movement.current_time <= p.movement.total_time then
                p.movement.current_time = p.movement.current_time + p.tick_speed
                if p.movement.current_time > p.movement.total_time then
                    p.movement.current_time = p.movement.total_time

                    p.movement.last_i = p.movement.next_i
                    p.movement.last_j = p.movement.next_j
                    p.movement.last_x = p.movement.next_x
                    p.movement.last_y = p.movement.next_y
                end

                local percent = p.movement.curve:getValueAtTime(p.movement.current_time)

                local x = p.movement.last_x + ((p.movement.next_x - p.movement.last_x) * percent)
                local y = p.movement.last_y + ((p.movement.next_y - p.movement.last_y) * percent)

                p.prop:setPiv(x, y)
            end

            coroutine:yield()
        end
    end
    p.thread = MOAICoroutine.new()
    p.thread:run(animFunc)
end

local function initCurve(p)
    p.movement.curve = MOAIAnimCurve.new()
    p.movement.curve:reserveKeys(2)
    p.movement.curve:setKey(1, 0, 0, MOAIEaseType.SOFT_EASE_IN)
    p.movement.curve:setKey(2, p.movement.total_time, 1.0)
end

function Person:new(p)
    assert (self ~= nil, "It's :new, not .new, moron.")
    p = p or Person
    setmetatable( p, self )
    self.__index = Person

    initProp(p)
    initAnimation(p)
    initCurve(p)

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

function Person:setMap(m)
    self.movement.map = m
end

function Person:moveTo(i, j)
    self.movement.current_time = 0

    x, y = self.movement.map:mapToStage(i, j)

    self.movement.last_x = self.movement.next_x
    self.movement.last_y = self.movement.next_y

    self.movement.last_i = self.movement.next_i
    self.movement.last_j = self.movement.next_j

    self.movement.next_i = i
    self.movement.next_j = j

    self.movement.next_x = x
    self.movement.next_y = y

    self.movement.current_time = 0

    if self.movement.next_x > self.movement.last_x then
        self:setDirection(Person.MOVE_RIGHT)
    elseif self.movement.next_x < self.movement.last_x then
        self:setDirection(Person.MOVE_LEFT)
    elseif self.movement.next_y > self.movement.last_y then
        self:setDirection(Person.MOVE_AWAY)
    else -- if self.movement.next_y < self.movement.last_y then
        self:setDirection(Person.MOVE_TOWARDS)
    end
end

function Person:setPosition(_i, _j)
    x, y = self.movement.map:mapToStage(i, j)

    self.movement.last_x = x
    self.movement.last_y = y
    self.movement.next_x = x
    self.movement.next_y = y

    self.movement.last_i = _i
    self.movement.last_j = _j
    self.movement.next_i = _i
    self.movement.next_j = _j

    self.movement.current_time = self.movement.total_time
end

function Person:getLastPosition()
    return self.movement.last_x, self.movement.last_y
end

function Person:getLastMapPosition()
    return self.movement.last_i, self.movement.last_j
end
