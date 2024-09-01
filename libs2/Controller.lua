local WindowFilter = require('hs.window.filter')
local EventWatcher = require('libs2/util/EventWatcher')
local TabAlert = require('libs2/Alert')


Controller = {}
Controller.__index = Controller
function Controller.new()
    local self = setmetatable({}, Controller)
    self.data = {
        currentAppName = nil
    }
    watcher = EventWatcher.new()
    watcher:listen(function()
        self.data.currentAppName = nil
        TabAlert.close()
    end)

    return self
end

function Controller:clickAppKey(appName, launchName)
    --local currentAppName = hs.window.focusedWindow():application():name()
    --print('current: ' .. currentAppName)
    local windowList = self:getSortedWindows(appName)
    local targetApp = hs.application.find(appName)
    --local targetApp = hs.application.open(appName)

    -- 앱이 실행되지 않은 상태 or 하나만 켜진 상태
    if windowList == nil or #windowList == 0 then
        print('open1 :', appName)
        self.data.currentAppName = appName
        hs.application.launchOrFocus(launchName or appName)
        TabAlert.show(appName, {}, 1)
        return
    end

    if (self.data.currentAppName ~= appName) then
        print('open2 :', appName)
        self.data.currentAppName = appName
        windowList[1]:focus()
        TabAlert.show(appName, windowList, 1)
        return
    end

    local currentWindow = hs.window.focusedWindow()
    for index, aWindow in ipairs(windowList) do
        if (aWindow:id() == currentWindow:id()) then
            local index = (index % #windowList) + 1
            windowList[index]:focus()
            TabAlert.show(appName, windowList, index)
        end
    end
end

function Controller:getSortedWindows(name)
    return WindowFilter.new(name)
        :setSortOrder(WindowFilter.sortByCreated)
        :getWindows()
end

return Controller
