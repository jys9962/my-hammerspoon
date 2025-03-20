local tabAlert = require('libs.util.TabAlert')
local windows = require('libs.util.Window')

local function getTabName(appName)
    return 'winKey-' .. appName
end

local function getSortedWindows(name)
    return windows.getList(name)
end

local function initOrNext(appName, launchName)
    local tabName = getTabName(appName)
    local currentTabName = tabAlert.getTabName()
    if tabName == currentTabName then
        tabAlert.nextTab()
        return ;
    end

    local windowList = getSortedWindows(appName)
    if windowList == nil or #windowList == 0 then
        hs.application.launchOrFocus(launchName or appName)
        return ;
    end

    local title = appName
    tabAlert.startTab(tabName, title, windowList, 1)
end

local function before(appName)
    local tabName = getTabName(appName)
    local currentTabName = tabAlert.getTabName()

    if (tabName ~= currentTabName) then
        return ;
    end

    tabAlert.beforeTab()
end

return {
    initOrNext = initOrNext,
    before = before,
}
