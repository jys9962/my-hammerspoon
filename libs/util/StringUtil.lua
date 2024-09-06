function utf8Len(str)
    local len = 0
    for _ in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do
        len = len + 1
    end
    return len
end

function utf8Sub(str, startChar, numChars)
    local result = ""
    local currentIndex = 1
    for _, char in utf8.codes(str) do
        if currentIndex >= startChar and currentIndex < startChar + numChars then
            result = result .. utf8.char(char)
        end
        currentIndex = currentIndex + 1
    end
    return result
end

-- 문자열을 30자 이상이면 축약하는 함수
function truncateString(str, maxLength)
    maxLength = maxLength or 30
    local strLength = utf8Len(str)

    if strLength > maxLength then
        return utf8Sub(str, 1, maxLength) .. "..."
    else
        return str
    end
end

function repeatStr(str, length)
    result = ''
    for i = 1, length do
        result = result .. str
    end
    return result
end
