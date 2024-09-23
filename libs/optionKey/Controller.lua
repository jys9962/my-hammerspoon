local tabAlert = require('libs/util/TabAlert')
--local AltTab = require('libs/util/AltTab')

local function getTabName(appName)
    return 'winKey-' .. appName
end

local function getSortedWindows(name)
    return hs.window.filter.new(name)
             :setSortOrder(hs.window.filter.sortByCreated)
             :getWindows()
end

local function initOrNext(appName, launchName)
    local tabName = getTabName(appName)
    --local currentTabName = AltTab.getTabName()
    local currentTabName = tabAlert.getTabName()
    if tabName == currentTabName then
        --AltTab.selectNextWindow()
        tabAlert.nextTab()
        return ;
    end

    local windowList = getSortedWindows(appName)
    if windowList == nil or #windowList == 0 then
        hs.application.launchOrFocus(launchName or appName)
        return ;
    end

    local title = appName
    --local title = '[[ ' .. appName .. ' ]]'
    --    AltTab.startSwitcher(tabName, windowList, 1)
    tabAlert.startTab(tabName, title, windowList, 1)
end

local function before(appName)
    local tabName = getTabName(appName)
    --    local currentTabName = AltTab.getTabName()
    local currentTabName = tabAlert.getTabName()

    if (tabName ~= currentTabName) then
        return ;
    end

    --    AltTab.selectPrevWindow()
    tabAlert.beforeTab()
end

return {
    initOrNext = initOrNext,
    before = before,
}
