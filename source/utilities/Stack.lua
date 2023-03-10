-- Stack Table
function Stack()
  return setmetatable({
    _stack = {},
    count = 0,

    clear = function(self)
      self._stack = {}
      self.count = 0
    end,

    push = function(self, obj)
      self.count = self.count + 1
      rawset(self._stack, self.count, obj)
    end,

    pop = function(self)
      self.count = self.count - 1
      return table.remove(self._stack)
    end,

    shift = function(self)
      self.count = self.count - 1
      return table.remove(self._stack, 1)
    end,

    each = function(self, callback)
      for i = 1, self.count do
        callback(rawget(self._stack, i), i)
      end
    end,

    map = function(self, callback)
      for i = 1, self.count do
        rawset(self._stack, i, callback(rawget(self._stack, i)))
      end
    end,

    where = function(self, callback)
      local stack = Stack()
      for i = 1, self.count do
        local value = rawget(self._stack, i)
        local r = callback(value, i)
        if r then
          stack:push(value)
        end
      end
      return stack
    end
  }, {
    __index = function(self, index)
      return rawget(self._stack, index)
    end,
  })
end

HeroStack = {}

function HeroStack:Create()
  local heroStack = Stack()
  local maxSize <const> = 1000

  function heroStack:addCoords(x, y)
      if(heroStack.count > maxSize) then
          heroStack:shift()
      end

      heroStack:push({x = x, y = y})
  end

  function heroStack:getCoords()
      return heroStack:pop()
  end

  return heroStack
end
