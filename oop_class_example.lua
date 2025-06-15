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
