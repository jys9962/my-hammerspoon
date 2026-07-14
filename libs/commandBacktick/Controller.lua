local tabAlert = require('libs.util.TabAlert')
local windows = require('libs.util.Window')

local function getTabName(bundleID)
    return 'winKey-' .. bundleID
end

local function getSortedWindows(bundleID)
    return windows.getList(bundleID)
end

local function initOrNext()
    local currentWindow = hs.window.focusedWindow()
    if (currentWindow == nil) then
        return nil;
    end

    local app = currentWindow:application()
    local bundleID = app:bundleID()
    if bundleID == nil then
        return ;
    end

    local tabName = getTabName(bundleID)
    local currentTabName = tabAlert.getTabName()
    if tabName == currentTabName then
        tabAlert.nextTab()
        return ;
    end

    local windowList = getSortedWindows(bundleID)
    local title = '[[' .. (app:name() or bundleID) .. ']]'
    tabAlert.startTab(tabName, title, windowList, 1)
end

local function initOrBefore()
    local currentWindow = hs.window.focusedWindow()
    if (currentWindow == nil) then
        return nil;
    end

    local app = currentWindow:application()
    local bundleID = app:bundleID()
    if bundleID == nil then
        return ;
    end

    local tabName = getTabName(bundleID)
    local currentTabName = tabAlert.getTabName()
    if tabName == currentTabName then
        tabAlert.beforeTab()
        return ;
    end

    local windowList = getSortedWindows(bundleID)
    local title = '[[' .. (app:name() or bundleID) .. ']]'
    tabAlert.startTab(tabName, title, windowList, 1)
end

return {
    initOrNext = initOrNext,
    initOrBefore = initOrBefore,
}
