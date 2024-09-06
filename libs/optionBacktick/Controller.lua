local tabAlert = require('libs/util/TabAlert')

local function getTabName()
    return 'before'
end

local function getSortedWindows()
    return hs.window.filter.new()
             :setSortOrder(hs.window.filter.sortByFocusedLast)
             :getWindows()
end

local function initOrNext()
    local tabName = getTabName()
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

    local title = ''
    tabAlert.startTab(tabName, title, windowList, 1)
end

local function before()
    local tabName = getTabName()
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
