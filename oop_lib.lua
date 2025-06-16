table.containsvalue = function(table, value)
  for k,v in pairs(table) do
    if v == value then
      return true;
    end
  end
  return false
end

table.shallowcopyinto = function(table1, table2)
  for k,v in pairs(table1) do
    table2[k] = v
  end
end

table.deepcopyinto = function(table1, table2)
  for k,v in pairs(table1) do
    if type(v) == 'table' then
      table2[k] = table.deepcopy(v)
    else
      table2[k] = v
    end
  end
end

table.shallowcopy = function(other)
  local retval = {}
  for k,v in other do
    retval[k] = v
  end
  return retval
end

table.deepcopy = function(other)
  local retval = {}
  for k,v in other do
    if type(v) == 'table' then
      retval[k] = table.deepcopy(v)
    else
      retval[k] = v
    end
  end
  return retval
end

table.insertall = function(table1, table2)
  for k,v in pairs(table1) do
    table.insert(table2, v)
  end
end

oop = {
  classify = function(class)
    if class.new == nil then
      class.new = oop.new
    end
    if class.extend == nil then
      class.extend = oop.extend
    end
    if class.implement == nil then
      class.implement = oop.implement
    end
    for k,v in pairs(oop.object) do
      if class[k] == nil then
        class[k] = v
      end
    end
  end,
  new = function(class, ...)
    local instance = {}
    for k,v in pairs(class) do
      if k ~= 'extend' and k ~= 'implement' and k ~= 'new' and k ~= 'parent' and k ~= 'children' then
        instance[k] = v
      end
    end
    instance.class = class
    if instance.ctor ~= nil then
      instance:ctor({...})
    end
    return instance
  end,
  implement = function(class, interface)
    if class.interfaces == nil then
      class.interfaces = {}
    end
    table.insert(class.interfaces, interface)
    if interface.inheritors == nil then
      interface.inheritors = {}
    end
    table.insert(interface.inheritors, class)
    for k, v in pairs(interface) do
      if type(v) == 'function' and class[k] == nil then
        class[k] = v
      end
    end
  end,
  extend = function(childClass, parentClass)
    childClass.base = parentClass
    if parentClass.children ~= nil then
      table.insert(parentClass.children, childClass)
    else
      parentClass.children = {}
      table.insert(parentClass.children, childClass)
    end
    for k,v in pairs(parentClass) do
      if childClass[k] == nil then
        childClass[k] = v
      end
    end
    if parentClass.interfaces ~= nil then
      if childClass.interfaces == nil then
        childClass.interfaces = {}
      end
      table.insertall(parentClass.interfaces, childClass.interfaces)
    end
  end,
  inheritsfrom = function(self, interface)
    local interfaces = self.class.interfaces
    if interfaces ~= nil then
      return table.containsvalue(interfaces)
    else
      return false
    end
  end,
  extends = function(self, otherclass)
    if self.class == otherClass then
      return true
    end
    if self.class.base ~= nil then
      if self.class.base == otherClass then
        return true
      end
      return self.class.base:extends(otherclass)
    end
    return false
  end,
  object = {
    tostring = function(self)
      return tostring(self)
    end
  }
}
--oop.init()

function run_tests()
  --Interface example
  i_moveable = {
    getx = function(self)
      return 0
    end,
    gety = function(self)
      return 0
    end,
    translate = function(self, x, y)
    end
  }

  --Class example.
  animal = {
    pos = { x = 0, y = 0 },
    color = 'white',
    ctor = function(self, params)
      self.pos = { x = 0, y = 0 }
      print('Constructor called!')
    end,
    getx = function(self)
      return self.pos.x
    end,
    gety = function(self)
      return self.pos.y
    end,
    translate = function(self, x, y)
      self.pos.x = self.pos.x + x
      self.pos.y = self.pos.y + y
    end
  }
  oop.classify(animal)
  
  --Create an instance of class...
  cow = animal:new()
  cow:translate(-3,2)
  print('Cow x = ' .. cow:getx())

  --Inherit from animal...
  dog = {
    ctor = function(self, params)
      self.base.ctor(self, params)
    end
  }
  oop.classify(dog)
  dog:extend(animal)

  --Create an instance of the child class.
  fido = dog:new()
  for k,v in pairs(fido) do
    print(k)
  end
  print(fido.ctor == oop.object.ctor)
  dog:translate(2,4)
  print('Fido x = ' .. dog:getx())
end
