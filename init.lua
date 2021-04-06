local cloneDeep
cloneDeep = function(List, Explored)
  if Explored == nil then
    Explored = { }
  end
  if 'table' == type(List) then
    if Explored[List] then
      return Explored[List]
    end
    Explored[List] = true
    local Result
    do
      local _tbl_0 = { }
      for I, V in pairs(List) do
        _tbl_0[cloneDeep(I)] = cloneDeep(V)
      end
      Result = _tbl_0
    end
    Explored[List] = Result
    return Result
  else
    return List
  end
end
local mergeDeep
mergeDeep = function(List, Properties)
  if Properties == nil then
    Properties = { }
  end
  for I, V in pairs(Properties) do
    if 'table' == type(V) then
      List[I] = List[I] or { }
      mergeDeep(List[I], V)
    else
      List[I] = List[I] or V
    end
  end
end
return function(DefaultState, Transformers)
  if DefaultState == nil then
    DefaultState = { }
  end
  if Transformers == nil then
    Transformers = { }
  end
  return function(Merge)
    local State = cloneDeep(DefaultState)
    if Merge then
      mergeDeep(State, Merge)
    end
    local Writer = {
      __builder = true,
      __state = State
    }
    return setmetatable(Writer, {
      __index = function(self, K)
        local T = Transformers[K]
        if K == 'value' then
          return function(...)
            if T then
              return T(State, ...)
            else
              return State
            end
          end
        end
        return function(V, ...)
          if T then
            T(State, V, ...)
          else
            V = V or true
            State[K] = V
          end
          return Writer
        end
      end
    })
  end
end
