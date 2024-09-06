local tabAlert = require('libs/util/TabAlert')

local function getTabName(appName)
    return 'winKey-' .. appName
end

local function getSortedWindows(name)
    return hs.window.filter.new(name)
             :setSortOrder(hs.window.filter.sortByCreated)
             :getWindows()
end

local function getCurrentAppName()
    local theWindow = hs.window.focusedWindow()
    if (theWindow == nil) then
        return nil;
    end

    return theWindow:application():name()
end

local function initOrNext()
    local appName = getCurrentAppName()
    if appName == nil then
        return ;
    end

    local tabName = getTabName(appName)
    local currentTabName = tabAlert.getTabName()
    if tabName == currentTabName then
        tabAlert.nextTab()
        return ;
    end

    local windowList = getSortedWindows(appName)
    local title = '[[' .. appName .. ']]'
    tabAlert.startTab(tabName, title, windowList, 1)
end

local function before()
    local appName = getCurrentAppName()
    if appName == nil then
        return ;
    end

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
