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
    for i,v in ipairs(self.data) do 
        if v == searchTerm then
            return i
        end
    end
    return nil
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

function Array:join( char )
    return table.concat(self.data, char) 
end

local a = Array:new( { data={"ONE", "TWO", "THREE"} })
 -- oh god, Lua starts indices at 1. the horror.
assert( a:indexOf("ONE") == 1 )
assert( a:indexOf("TWO") == 2 )
assert( a:indexOf("THREE") == 3 )
