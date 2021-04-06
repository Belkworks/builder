
# builder
*A table builder in MoonScript*

**Importing with [Neon](https://github.com/Belkworks/NEON)**:
```lua
Builder = NEON:github('belkworks', 'builder')
```

## API

### Creating a Builder

To create a builder, call **Builder**.  
`Builder(defaults = {}, transformers = {}) -> Builder`
```lua
Person = Builder({isPerson = true}) -- function
```

### Using a Builder

```lua
Frank = Person({job='plumber'}).name('frank').something().age(32).value()
-- Calling .value() returns the finished table
-- Frank is equivalent to the following:
Frank = {
    isPerson = true, -- from Builder defaults
    job = 'plumber', -- from Person call
    name = 'frank',
    something = true, -- no arguments -> defaults to true
    age = 32
}
```

### Using Transformers

Transformers are functions that are called instead of basic assignment.  
A transformer receives `(state, value)` as parameters.  
The return value is not used (unless it's the `value` transformer)
```lua
Person = Builder({whatever = true}, {
    age = function(state, n)
        state.age = n
        state.birthYear = 2021 - n
    end
})

Frank = Person().age(20).value()
-- Frank is equivalent to the following:
Frank = {
    whatever = true, -- from Builder defaults
    age = 20,
    birthYear = 2001
}
```

### Value Transformer

If a transformer called `value` is defined, it will be called when `.value` is called.  
It will receive the state and whatever parameters are passed to the `.value` call.  
Its return value is the output of the original `.value` call.
```lua
Person = Builder({}, {
    value = function(state, ...)
        JSON.stringify(state)
    end
})

Frank = Person({name="frank"}).age(20).value()
-- Frank is equivalent to the following:
Frank = '{"age": 20, "name": "frank"}'
```
