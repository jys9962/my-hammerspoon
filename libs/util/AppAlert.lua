local watcher = require('libs.util.EventWatcher')
local Str = require('libs.util.StringUtil')
local Fp = require('libs.util.Fp')
local ListPanel = require('libs.util.ListPanel')

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

local function showAlert()
    ListPanel.show({
        title = '앱 선택',
        items = Fp.pipe(data.bundleIDs, Fp.map(function(bundleID)
            return {
                text = Str.truncateString(hs.application.nameForBundleID(bundleID) or bundleID, 40),
                icon = hs.image.imageFromAppBundle(bundleID),
            }
        end)),
        selectedIndex = data.currentIndex,
        hint = '키를 놓으면 선택한 앱으로 지정됩니다',
    })
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
    ListPanel.hide()
    onSelect(bundleID)
end)

return {
    start = start,
    nextSelection = nextSelection,
    getSelectionName = getSelectionName,
}
