local tabAlert = require('libs.util.TabAlert')
local windows = require('libs.util.Window')

local function getTabName(bundleID)
    return 'winKey-' .. bundleID
end

local function initOrNext(bundleID)
    local tabName = getTabName(bundleID)
    local currentTabName = tabAlert.getTabName()
    if tabName == currentTabName then
        tabAlert.nextTab()
        return ;
    end

    local windowList = windows.getList(bundleID)
    if windowList == nil or #windowList == 0 then
        hs.application.launchOrFocusByBundleID(bundleID)
        return ;
    end

    local title = hs.application.nameForBundleID(bundleID) or bundleID
    tabAlert.startTab(tabName, title, windowList, 1)
end

local function before(bundleID)
    local tabName = getTabName(bundleID)
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
