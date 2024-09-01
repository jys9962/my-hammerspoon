local WindowFilter = require('hs.window.filter')
local Application = require('hs.application')
local WindowChooser = require('libs/WindowChooser')

Controller = {}
Controller.__index = Controller
function Controller.new()
    local self = setmetatable({}, Controller)
    self.data = {}
    self.selector = WindowChooser.new()

    return self
end

function Controller:setApp(num, appName)
    self.data[num] = appName
end

function Controller:clickNumberWithOption(num)
    local selector = self.selector
    local appName = self.data[num]
    local windowList = self:getSortedWindows(appName)
    if windowList == nil or #windowList == 1 then
        hs.application.launchOrFocus(appName)
        return;
    end

    --if selector:isShow() then
    --    selector:select(num)
    --else
    --    selector:showList(windowList)
    --end
    selector:showList(windowList)
end

function Controller:getSortedWindows(name)
    return WindowFilter.new(name)
        :setSortOrder(WindowFilter.sortByCreated)
        :getWindows()
end

return Controller
