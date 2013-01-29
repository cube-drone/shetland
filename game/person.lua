person_layer = layers.addLayer()

require "game.generated.mans"

local person_tiles = tiles.addTileset( game.generated.mans ) 
person_tiles:setRect(-16, -16, 16, 16)

person_layer:setViewport(config.viewport)
MOAIRenderMgr.pushRenderPass(person_layer)

Person = { prop = nil, tiles = person_tiles, data = {}, direction = 0, animation = nil, actions = nil, thread = nil, index = 1, tick_speed = 100, anim_skip = 3, movement = { map = nil, total_time = 1000, current_time = 0, last_x = 0, last_y = 0, next_x = 0, next_y = 0, curve = nil, last_i = 0, last_j = 0, next_i = 0, next_j = 0 } }

Person.MOVE_TOWARDS = 0
Person.MOVE_AWAY = 1
Person.MOVE_RIGHT = 2
Person.MOVE_LEFT = 3

local walk_towards = { game.generated.mans.tiles.down_1, game.generated.mans.tiles.down_2 }
local walk_away = { game.generated.mans.tiles.up_1, game.generated.mans.tiles.up_2 }
local walk_right = { game.generated.mans.tiles.right_1, game.generated.mans.tiles.right_2 }
local walk_left = { game.generated.mans.tiles.left_1, game.generated.mans.tiles.left_2 }

local function removeFromList(list, person)
    local i = 1
    while list[i] do
        if p == person then
            break
        end
        i = i + 1
    end
    if list[i] then 
        table.remove(list, i)
        return true
    else 
        return false
    end 
end

local function addToList(list, person)
    table.insert(list, person)
end

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
        local anim_buffer = 0
        while true do
            local action = MOAITimer.new()
            action:setMode(MOAITimer.NORMAL)
            action:setSpeed(p.tick_speed)
            action:start()

            while action:isBusy() do
                coroutine:yield()
            end 

            -- Select animation frame
            anim_buffer = anim_buffer + 1
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

            if anim_buffer % p.anim_skip == 0 then
                local next_index = p.index + direction
                if frame_list[next_index] ~= nil then
                    p.index = next_index
                else 
                    direction = direction * -1
                    p.index = p.index + direction
                end 
            end

            p.prop:setIndex(frame_list[p.index])

            -- Move to new position if needed
            local next_state = p.movement.map:getState(p.movement.next_i, p.movement.next_j)
            local last_state = p.movement.map:getState(p.movement.last_i, p.movement.last_j)

            if p.movement.current_time <= p.movement.total_time then
                p.movement.current_time = p.movement.current_time + p.tick_speed
                if p.movement.current_time > p.movement.total_time then
                    p.movement.current_time = p.movement.total_time

                    if last_state.persons == nil then last_state.persons = {} end
                    if next_state.persons == nil then next_state.persons = {} end

                    removeFromList(last_state.persons, self)
                    addToList(next_state.persons, self)

                    p.movement.last_i = p.movement.next_i
                    p.movement.last_j = p.movement.next_j
                    p.movement.last_x = p.movement.next_x
                    p.movement.last_y = p.movement.next_y
                end

                local percent = p.movement.curve:getValueAtTime(p.movement.current_time)

                local x = p.movement.last_x + ((p.movement.next_x - p.movement.last_x) * percent) + (0.5 * p.movement.map.tile_width)
                local y = p.movement.last_y + ((p.movement.next_y - p.movement.last_y) * percent) + (0.5 * p.movement.map.tile_height)

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
    if map == nil then
        log.error("Person", "setMap provided a nil value")
    end
    self.movement.map = m
end

function Person:moveTo(i, j)
    if not self.movement.map:isValid(i, j) then
        log.error("Person", "Attempted to move to an invalid map position")
    end

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
        self:setDirection(Person.MOVE_LEFT)
    elseif self.movement.next_x < self.movement.last_x then
        self:setDirection(Person.MOVE_RIGHT)
    elseif self.movement.next_y > self.movement.last_y then
        self:setDirection(Person.MOVE_TOWARDS)
    else -- if self.movement.next_y < self.movement.last_y then
        self:setDirection(Person.MOVE_AWAY)
    end
end

function Person:setPosition(_i, _j)
    x, y = self.movement.map:mapToStage(_i, _j)

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

function Person:atPosition()
    return self.movement.next_x == self.movement.last_x and self.movement.next_y == self.movement.last_y
end

function Person:getPosition()
    return self.movement.next_x, self.movement.next_y
end

function Person:getMapPosition()
    return self.movement.next_i, self.movement.next_j
end
