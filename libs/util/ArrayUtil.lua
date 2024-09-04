local ArrayUtil = {}
function ArrayUtil.findIndex(list, finder)
    for i, v in ipairs(list) do
        if finder(v, i) then
            return i
        end
    end

    return nil
end
return ArrayUtil
