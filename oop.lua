oop = {
  init = function()
    oop.classify(oop.object)
  end,
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
    oop.extend(class, oop.object)
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
      if type(v) == 'function' then
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
    ctor = function(self)
    end,
    tostring = function(self)
      return tostring(self)
    end
  }
}
oop.init()
