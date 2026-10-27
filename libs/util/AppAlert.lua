local watcher = require('libs.util.EventWatcher')
local Fp = require('libs.util.Fp')
local ListPanel = require('libs.util.ListPanel')

local data = {
    selectionName = nil,
    bundleIDs = {},
    currentIndex = nil,
    onSelect = nil,
    activeBundleID = nil,
}

local function init()
    data.selectionName = nil
    data.bundleIDs = {}
    data.currentIndex = nil
    data.onSelect = nil
    data.activeBundleID = nil
end

local function showAlert()
    ListPanel.show({
        title = '앱 선택',
        subtitle = '이 단축키에 연결할 앱을 고르세요',
        items = Fp.pipe(data.bundleIDs, Fp.map(function(bundleID)
            return {
                text = hs.application.nameForBundleID(bundleID) or bundleID,
                icon = hs.image.imageFromAppBundle(bundleID),
                subtext = bundleID == data.activeBundleID and '현재' or nil,
            }
        end)),
        selectedIndex = data.currentIndex,
        hints = {
            { key = '같은 키', label = '다음' },
            { label = '키를 놓으면 지정' },
        },
    })
end

-- activeBundleID 는 현재 단축키에 지정된 앱으로, 목록에 '현재' 표시만 한다.
local function start(selectionName, bundleIDs, currentIndex, onSelect, activeBundleID)
    data.selectionName = selectionName
    data.bundleIDs = bundleIDs
    data.currentIndex = currentIndex
    data.onSelect = onSelect
    data.activeBundleID = activeBundleID
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
