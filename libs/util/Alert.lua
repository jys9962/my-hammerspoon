local function utf8Len(str)
    local len = 0
    for _ in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do
        len = len + 1
    end
    return len
end

local function utf8Sub(str, startChar, numChars)
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
local function truncateString(str, maxLength)
    maxLength = maxLength or 30
    local strLength = utf8Len(str)

    if strLength > maxLength then
        return utf8Sub(str, 1, maxLength) .. "..."
    else
        return str
    end
end

local function repeatStr(str, length)
    result = ''
    for i = 1, length do
        result = result .. str
    end
    return result
end

local function toMessage(appName, windowList, selectedIndex)
    local result = '----------------------------------------------------------------\n'
    if appName ~= nil then
        local fullLength = 90
        local titleSize = utf8Len(appName)
        local leftPad = (fullLength - titleSize) // 2
        local rightPad = fullLength - titleSize - leftPad
        result = result .. repeatStr(' ', leftPad) .. '[[ ' .. appName .. ' ]]' .. repeatStr(' ', rightPad) .. '\n'
    end
    for index, value in ipairs(windowList) do
        if index == selectedIndex then
            result = result .. '\n ●  '
        else
            result = result .. '\n ○  '
        end

        local title = value:title()
        local indexedAppName = appName .. ' - (' .. index .. ')'
        result = result .. truncateString(title ~= '' and title or indexedAppName, 50)
    end

    result = result .. '\n\n----------------------------------------------------------------'
    return result
end

TabAlert = {
    show = function(appName, windowList, index)
        hs.alert.closeAll()

        local message = toMessage(appName, windowList, index)
        hs.alert.show(message, {
            strokeWidth = 0,
            strokeColor = { red = 0.2, green = 0.4, blue = 0.6, alpha = 1 },
            fillColor = { red = 0.27, green = 0.47, blue = 0.7, alpha = 1 },
            textColor = { white = 1 },
            textFont = ".AppleSystemUIFont",
            textSize = 18,
            radius = 12,
            atScreenEdge = 0,
            fadeInDuration = 0,
            fadeOutDuration = 0,
            padding = 0
        })
    end,
    close = function()
        hs.alert.closeAll()
    end
}

return TabAlert
