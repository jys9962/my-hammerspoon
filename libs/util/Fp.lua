local function map(func)
    return function(tbl)
        local result = {}
        for i, v in ipairs(tbl) do
            result[i] = func(v, i)
        end
        return result
    end
end

local function tap(func)
    return function(tbl)
        for i, v in ipairs(tbl) do
            func(v, i)
        end
        return tbl
    end
end

local function filter(func)
    return function(tbl)
        local result = {}
        for i, v in ipairs(tbl) do
            if func(v, i) then
                table.insert(result, v)
            end
        end
        return result
    end
end

local function reduce(func, initial)
    return function(tbl)
        local acc = initial
        local start_idx = 1

        if initial == nil then
            acc = tbl[1]
            start_idx = 2
        end

        for i = start_idx, #tbl do
            acc = func(acc, tbl[i])
        end

        return acc
    end
end

local function concat(tbl2)
    return function(tbl)
        local result = {}
        for _, v in ipairs(tbl) do
            table.insert(result, v)
        end
        for _, v in ipairs(tbl2) do
            table.insert(result, v)
        end
        return result
    end
end

local function pipe(tbl, ...)
    local funcs = { ... }
    local result = tbl

    for _, func in ipairs(funcs) do
        result = func(result)
    end

    return result
end

return {
    map = map,
    tap = tap,
    filter = filter,
    reduce = reduce,
    concat = concat,
    pipe = pipe,
}
