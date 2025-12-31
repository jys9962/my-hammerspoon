local function findIndex(list, finder)
    for i, v in ipairs(list) do
        if finder(v, i) then
            return i
        end
    end

    return nil
end

local function some(list, func)
    for i, v in ipairs(list) do
        if func(v, i) then
            return true
        end
    end
    return false
end

local function every(list, func)
    for i, v in ipairs(list) do
        if not func(v, i) then
            return false
        end
    end
    return true
end

local function forEach(list, func)
    for i, v in ipairs(list) do
        func(v, i)
    end
end

return {
    findIndex = findIndex,
    some = some,
    every = every,
    forEach = forEach,
}
