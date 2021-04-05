-- builder.moon
-- SFZILabs 2021

cloneDeep = (List, Explored = {}) -> -- Recursive copy of list
    if 'table' == type List
        return Explored[List] if Explored[List]
        Explored[List] = true
        Result = {cloneDeep(I), cloneDeep(V) for I, V in pairs List}
        Explored[List] = Result
        Result
    else List

mergeDeep = (List, Properties = {}) -> -- Recursive merge of List
	for I, V in pairs Properties
		if 'table' == type V
			List[I] or= {}
			mergeDeep List[I], V
		else List[I] or= V

(DefaultState = {}, Transformers = {}) -> 
	(Merge) ->
		State = cloneDeep DefaultState
		mergeDeep State, Merge if Merge
		
		Writer = __builder: true, __state: State
		setmetatable Writer, __index: (K) =>
			return (V = true, ...) ->
				if K == 'value'
					if T = Transformers.value
						T State

					State
				else
					if Transformers[K]
						Transformers[K] State, V, ...
					else State[K] = V

					Writer
