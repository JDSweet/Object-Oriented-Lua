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


game_instance = {
  state = nil,
  get_state = function(self)
    if self.state == nil then
      self.state = game_state:new()
    end
    return self.state
  end
}

game_state = {
  factions = {},
  provinces = {},
  ctor = function(self, params)
    self:load_factions()
    self:load_provinces()
  end,
  load_factions = function(self)
    for i = 1, 20 do
      self.factions[i] = faction:new()
    end
  end,
  load_provinces = function(self)
    for i = 1, 1000 do
      table.insert(self.provinces, province:new(i, 1, 1))
    end
  end,
  get_provinces = function(self)
    return self.provinces
  end,
  get_province_by_id = function(self, id)
    return self.provinces[id]
  end
}
oop.classify(game_state)

province = {
  id = 0,
  owner_id = 0,
  controller_id = 0,
  ctor = function(self, params)
    self.id = params[1]
    self.owner_id = params[2]
    self.controller_id = params[3]
  end,
  change_owner = function(self, new_owner_id)
    self.owner = new_owner_id
  end,
  change_controller = function(self, new_controller_id)
    self.controller = new_controller_id
  end,
  tostring = function(self)
    return '{ id = ' .. self.id .. ', owner_id = ' .. self.owner_id .. ', controller_id = ' .. self.controller_id .. '}\n\n'
  end
}
oop.classify(province)

faction = {
  id = -1,
  provinces = {},
  ctor = function(self, params)
    self.id = params[1]
  end,
  add_province = function(self, prov)
    table.insert(self.provinces, prov)
  end
}
oop.classify(faction)

state = game_instance:get_state()
provinces = state:get_provinces()
for k, v in pairs(provinces) do
  print(v:tostring())
end
