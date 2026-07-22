local watcher = require('libs.util.EventWatcher')
local Str = require('libs.util.StringUtil')
local Fp = require('libs.util.Fp')

local data = {
    selectionName = nil,
    bundleIDs = {},
    currentIndex = nil,
    onSelect = nil,
}

local function init()
    data.selectionName = nil
    data.bundleIDs = {}
    data.currentIndex = nil
    data.onSelect = nil
end

local function getMessage()
    local result = '----------------------------------------------------------------\n'
    local title = '앱 선택'
    local fullLength = 90
    local titleSize = Str.utf8Len(title)
    local leftPad = (fullLength - titleSize) // 2
    local rightPad = fullLength - titleSize - leftPad
    result = result .. Str.repeatStr(' ', leftPad) .. title .. Str.repeatStr(' ', rightPad) .. '\n'

    for index, bundleID in ipairs(data.bundleIDs) do
        if index == data.currentIndex then
            result = result .. '\n ●  '
        else
            result = result .. '\n ○  '
        end

        local appName = hs.application.nameForBundleID(bundleID) or bundleID
        result = result .. Str.truncateString(appName, 50)
    end

    return result .. '\n\n----------------------------------------------------------------'
end

local function showAlert()
    local alertScreen = Fp.pipe(
            hs.screen.allScreens(),
            Fp.sort(function(t1, t2)
                return t1:frame().x > t2:frame().x;
            end)
    )[2]

    hs.alert.closeAll()
    hs.alert.show(getMessage(), {
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
    }, alertScreen, 3600)
end

local function start(selectionName, bundleIDs, currentIndex, onSelect)
    data.selectionName = selectionName
    data.bundleIDs = bundleIDs
    data.currentIndex = currentIndex
    data.onSelect = onSelect
    showAlert()
end

local function nextSelection()
    data.currentIndex = (data.currentIndex % #data.bundleIDs) + 1
    showAlert()
end

local function getSelectionName()
    return data.selectionName
end

watcher.listen(function()
    if data.selectionName == nil then
        return ;
    end

    local bundleID = data.bundleIDs[data.currentIndex]
    local onSelect = data.onSelect
    init()
    hs.alert.closeAll()
    onSelect(bundleID)
end)

return {
    start = start,
    nextSelection = nextSelection,
    getSelectionName = getSelectionName,
}
