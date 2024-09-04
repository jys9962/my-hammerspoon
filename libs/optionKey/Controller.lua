local WindowFilter = require('hs.window.filter')
local EventWatcher = require('libs/util/EventWatcher')
local TabAlert = require('libs/util/Alert')

Controller = {}
Controller.__index = Controller
function Controller.new()
    local self = setmetatable({}, Controller)
    self.data = {
        currentAppName = nil
    }
    watcher = EventWatcher.new()

    -- 알트탭 종료
    watcher:listen(function()
        self.data.currentAppName = nil
        TabAlert.close()
    end)

    return self
end

function Controller:next(appName, launchName)
    local windowList = self:getSortedWindows(appName)

    -- 앱이 실행되지 않은 상태
    if windowList == nil or #windowList == 0 then
        self.data.currentAppName = appName
        hs.application.launchOrFocus(launchName or appName)
        TabAlert.show(appName, {}, 1)
        return
    end

    -- 알트탭 시작
    if (self.data.currentAppName ~= appName) then
        self.data.currentAppName = appName
        windowList[1]:focus()
        TabAlert.show(appName, windowList, 1)
        return
    end

    -- 다음탭 이동
    local currentWindow = hs.window.focusedWindow()
    for index, aWindow in ipairs(windowList) do
        if (aWindow:id() == currentWindow:id()) then
            local selectedIndex = (index % #windowList) + 1
            windowList[selectedIndex]:focus()
            TabAlert.show(appName, windowList, selectedIndex)
        end
    end
end

function Controller:before(appName, launchName)
    local windowList = self:getSortedWindows(appName)

    -- 앱이 실행되지 않은 상태
    if windowList == nil or #windowList == 0 then
        return
    end

    -- 알트탭 시작
    if (self.data.currentAppName ~= appName) then
        return
    end

    -- 다음탭 이동
    local currentWindow = hs.window.focusedWindow()
    for index, aWindow in ipairs(windowList) do
        if (aWindow:id() == currentWindow:id()) then
            local selectedIndex = (index - 1) == 0 and #windowList or (index - 1)
            windowList[selectedIndex]:focus()
            TabAlert.show(appName, windowList, selectedIndex)
        end
    end
end

function Controller:getSortedWindows(name)
    return WindowFilter.new(name)
                       :setSortOrder(WindowFilter.sortByCreated)
                       :getWindows()
end

return Controller
