local watcher = require('libs.util.EventWatcher')
local Str = require('libs.util.StringUtil')
local Fp = require('libs.util.Fp')

local data = {
    tabName = nil,
    title = nil,
    windowList = {},
    currentIndex = nil,
}

-- 팝업이 떠 있는 동안에만 방향키를 가로채기 위한 모달.
-- 전역으로 option+방향키를 잡으면 모든 앱의 단어/문단 이동이 망가지므로,
-- startTab 에서 enter, 확정(EventWatcher 콜백) 시 exit 한다.
local reorderModal = hs.hotkey.modal.new()

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
    alertScreen = Fp.pipe(
            hs.screen.allScreens(),
            Fp.sort(function(t1, t2)
                return t1:frame().x > t2:frame().x;
            end),
            Fp.tap(function(t)
                --print(t:frame().x)
            end)
    )[2]

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
    }, alertScreen, 3600)
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
    reorderModal:enter()
end

local function nextTab()
    data.currentIndex = (data.currentIndex % #data.windowList) + 1
    showAlert()
end

local function beforeTab()
    data.currentIndex = (data.currentIndex - 1) == 0 and #data.windowList or (data.currentIndex - 1)
    showAlert()
end

-- 현재 선택된 창을 순서에서 delta 만큼 옮긴다.
-- data.windowList 는 windows.getList 의 캐시 배열과 동일 객체이므로,
-- 여기서 in-place 로 자리를 바꾸면 순환 순서가 그대로 반영된다. 끝에서는 멈춘다.
local function reorderCurrent(delta)
    if data.currentIndex == nil then
        return ;
    end

    local target = data.currentIndex + delta
    if target < 1 or target > #data.windowList then
        return ;
    end

    local w = table.remove(data.windowList, data.currentIndex)
    table.insert(data.windowList, target, w)
    data.currentIndex = target
    showAlert()
end

-- 팝업은 option 또는 hyper(option+cmd+ctrl)를 누른 채 뜨므로 두 조합을 모두 바인딩한다.
-- ↑/↓ = 커서 이동(nextTab/beforeTab 재사용), ⇧↑/⇧↓ = 선택 창 순서 이동.
for _, mods in ipairs({ { 'option' }, { 'option', 'cmd', 'ctrl' } }) do
    reorderModal:bind(mods, 'up', beforeTab, nil, beforeTab)
    reorderModal:bind(mods, 'down', nextTab, nil, nextTab)
end
for _, mods in ipairs({ { 'option', 'shift' }, { 'option', 'cmd', 'ctrl', 'shift' } }) do
    reorderModal:bind(mods, 'up', function() reorderCurrent(-1) end, nil, function() reorderCurrent(-1) end)
    reorderModal:bind(mods, 'down', function() reorderCurrent(1) end, nil, function() reorderCurrent(1) end)
end

watcher.listen(function()
    if data.tabName == nil then
        return ;
    end

    focusCurrentIndex()
    reorderModal:exit()
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
