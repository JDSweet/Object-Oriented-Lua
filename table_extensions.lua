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
