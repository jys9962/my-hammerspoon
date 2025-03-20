local watcher = require('libs.util.EventWatcher')
local Str = require('libs.util.StringUtil')

local data = {
    tabName = nil,
    title = nil,
    windowList = {},
    currentIndex = nil,
}

local function init()
    data.windowList = {}
    data.currentIndex = nil
    data.tabName = nil
    data.title = nil
end

local function focusCurrentIndex()
    data.windowList[data.currentIndex]:focus()
end

local function getTabName()
    return data.tabName
end

local function getMessage()
    title = data.title
    windowList = data.windowList
    selectedIndex = data.currentIndex

    local result = '_______________________________________________________________\n\n'
    if title ~= nil then
        local fullLength = 120
        local titleSize = Str.utf8Len(title)
        local leftPad = (fullLength - titleSize) // 2
        local rightPad = fullLength - titleSize - leftPad
        result = result .. Str.repeatStr(' ', leftPad) .. data.title .. Str.repeatStr(' ', rightPad) .. '\n'
    end
    for index, value in ipairs(windowList) do
        if index == selectedIndex then
            result = result .. '\n  ●  '
        else
            result = result .. '\n  ○  '
        end

        local title = value:title()
        result = result .. Str.truncateString(title, 50)
    end

    result = result .. '\n\n_______________________________________________________________\n'
    return result
end

local function showAlert()
    hs.alert.closeAll()
    local message = getMessage()
    hs.alert.show(message, {
        strokeWidth = 0,
        strokeColor = { red = 0.2, green = 0.4, blue = 0.6, alpha = 1 },
        fillColor = { red = 0.12, green = 0.12, blue = 0.12, alpha = 1 },
        textColor = { white = 1 },
        textFont = ".AppleSystemUIFont",
        textSize = 20,
        radius = 12,
        atScreenEdge = 0,
        fadeInDuration = 0,
        fadeOutDuration = 0,
        padding = 0
    }, 3600)
end

local function getMessage()
    title = data.title
    windowList = data.windowList
    selectedIndex = data.currentIndex

    local result = '----------------------------------------------------------------\n'
    if title ~= nil then
        local fullLength = 90
        local titleSize = Str.utf8Len(title)
        local leftPad = (fullLength - titleSize) // 2
        local rightPad = fullLength - titleSize - leftPad
        result = result .. Str.repeatStr(' ', leftPad) .. data.title .. Str.repeatStr(' ', rightPad) .. '\n'
    end
    for index, value in ipairs(windowList) do
        if index == selectedIndex then
            result = result .. '\n ●  '
        else
            result = result .. '\n ○  '
        end

        local title = value:title()
        result = result .. Str.truncateString(title, 50)
    end

    result = result .. '\n\n----------------------------------------------------------------'
    return result
end

local function startTab(tabName, title, windowList, currentIndex)
    data.tabName = tabName
    data.title = title
    data.windowList = windowList
    data.currentIndex = currentIndex

    showAlert()
end

local function nextTab()
    data.currentIndex = (data.currentIndex % #data.windowList) + 1
    showAlert()
end

local function beforeTab()
    data.currentIndex = (data.currentIndex - 1) == 0 and #data.windowList or (data.currentIndex - 1)
    showAlert()
end

watcher.listen(function()
    if data.tabName == nil then
        return ;
    end

    focusCurrentIndex()
    init()
    hs.alert.closeAll()
end)

return {
    toMessage = getMessage,
    startTab = startTab,
    getTabName = getTabName,
    showAlert = showAlert,
    nextTab = nextTab,
    beforeTab = beforeTab,
    focusCurrentIndex = focusCurrentIndex,
}
