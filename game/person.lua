person_layer = layers.addLayer()

local person_tiles = tiles.add(MOAITileDeck2D, "art/person.png", 4, 4)
person_tiles:setRect(-16, -16, 16, 16)

person_layer:setViewport(config.viewport)
MOAIRenderMgr.pushRenderPass(person_layer)

Person = { prop = nil, tiles = person_tiles, data = {}, direction = 0, animation = nil, actions = nil, thread = nil, index = 1 }

Person.MOVE_TOWARDS = 0
Person.MOVE_AWAY = 1
Person.MOVE_RIGHT = 2
Person.MOVE_LEFT = 3

local walk_towards = { 1, 5, 9, 13 }
local walk_away = { 2, 6, 10, 14 }
local walk_right = { 3, 7, 11, 15 }
local walk_left = { 4, 8, 12, 16 }

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
            p.index = p.index + (4 * direction)
            if p.direction == Person.MOVE_TOWARDS then
                if p.index > 13 then
                    p.index = 9
                    direction = direction * -1
                elseif p.index < 1 then
                    p.index = 5
                    direction = direction * -1
                end 
            elseif p.direction == Person.MOVE_AWAY then
                if p.index > 14 then
                    p.index = 10
                    direction = direction * -1
                elseif p.index < 2 then
                    p.index = 6
                    direction = direction * -1
                end 
            elseif p.direction == Person.MOVE_RIGHT then
                if p.index > 15 then
                    p.index = 11
                    direction = direction * -1
                elseif p.index < 3 then
                    p.index = 7
                    direction = direction * -1
                end 
            elseif p.direction == Person.MOVE_LEFT then
                if p.index > 16 then
                    p.index = 12
                    direction = direction * -1
                elseif p.index < 4 then
                    p.index = 8
                    direction = direction * -1
                end 
            end
            p.prop:setIndex(p.index)
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

