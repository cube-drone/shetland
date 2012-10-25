Array = { data={} }

function Array:new(a)
    assert (self ~= nil, "It's :new, not .new, moron." )
    a = a or { data={} }
    setmetatable( a, self )
    self.__index = Array
    return a
end

function Array:getRaw()
    return self.data
end

function Array:first()
    return self.data[1]
end

function Array:last()
    return self.data[table.getn(self.data)]
end

function Array:get(index)
   return self.data[index]
end

function Array:indexOf(searchTerm)
   local index = -1
   repeat index = index + 1 until self.data[index] == nil or self.data[index] == searchTerm
   if index == table.getn(self.data) then
      return nil
   else
      return index
   end
end

function Array:append(thing)
   table.insert(self.data, thing)
   return self:last()
end

function Array:remove(thing)
   local index = self:indexOf(thing)
   if index ~= nil then
      table.remove(self.data, index)
      return true
   else
      return false
   end
end

function Array:len()
    return table.getn(self.data)
end

function Array:clear()
    self.data = {}
end

function Array:each( fn )
    for i,v in ipairs(self.data) do 
        fn( v )
    end
end

