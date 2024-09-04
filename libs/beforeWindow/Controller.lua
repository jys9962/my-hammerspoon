local WindowFilter = require('hs.window.filter')
local EventWatcher = require('libs/util/EventWatcher')
local TabAlert = require('libs/util/Alert')
local WindowUtil = require('libs/util/WindowUtil')
local ArrayUtil = require('libs/util/ArrayUtil')

Controller = {}
Controller.__index = Controller
function Controller.new()
    local self = setmetatable({}, Controller)
    self.data = {
        isRunning = false,
        currentIndex = nil,
        windowList = {}
    }
    watcher = EventWatcher.new()
    watcher:listen(function()
        self.data.isRunning = false
        self.data.currentIndex = nil
        self.data.windowList = {}
        TabAlert.close()
    end)

    return self
end

function Controller:setRunning()
    local windowList = hs.window.filter.new(nil)
                         :setSortOrder(hs.window.filter.sortByFocused)
                         :getWindows()

    self.data.isRunning = true
    self.data.windowList = windowList
    self.data.currentIndex = 1
end

function Controller:next()
    if not self.data.isRunning then
        local currentWindow = hs.window.focusedWindow()
        if (currentWindow == nil) then
            print('not running app')
            return ;
        end
        local windowList = hs.window.filter.new(nil)
                             :setSortOrder(hs.window.filter.sortByFocusedLast)
                             :getWindows()
        self.data.isRunning = true
        self.data.windowList = windowList
        self.data.currentIndex = 1

        self:next()
    else
        self.data.currentIndex = (self.data.currentIndex % #self.data.windowList) + 1

        print(self.data.currentIndex)

        local targetWindow = self.data.windowList[self.data.currentIndex]
        targetWindow:focus()
        TabAlert.show(targetWindow:application():name(), self.data.windowList, self.data.currentIndex)
    end
end

function Controller:before()
    if not self.data.isRunning then
        local currentWindow = hs.window.focusedWindow()
        if (currentWindow == nil) then
            print('not running app')
            return ;
        end
        local windowList = hs.window.filter.new(nil)
                             :setSortOrder(hs.window.filter.sortByFocusedLast)
                             :getWindows()
        self.data.isRunning = true
        self.data.windowList = windowList
        self.data.currentIndex = ArrayUtil.findIndex(windowList, function(aWindow, i)
            return aWindow:id() == currentWindow:id()
        end)

        self:before()
    else
        self.data.currentIndex = (self.data.currentIndex - 1) == 0 and #self.data.windowList or (self.data.currentIndex - 1)
        local targetWindow = self.data.windowList[self.data.currentIndex]

        targetWindow:focus()
        TabAlert.show(targetWindow:application():name(), self.data.windowList, self.data.currentIndex)

    end
end

return Controller
