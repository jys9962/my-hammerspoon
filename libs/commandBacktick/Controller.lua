local tabAlert = require('libs.util.TabAlert')
local windows = require('libs.util.Window')
local Arr = require('libs.util.ArrayUtil')

local function getTabName(bundleID)
    return 'winKey-' .. bundleID
end

local function getSortedWindows(bundleID)
    return windows.getList(bundleID)
end

local function getCurrentAppName()
    local theWindow = hs.window.focusedWindow()
    if (theWindow == nil) then
        return nil;
    end

    return theWindow:application():name()
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
    local currentIndex = Arr.findIndex(windowList, function(aWindow, i)
        return aWindow:id() == currentWindow:id()
    end)
    tabAlert.startTab(tabName, title, windowList, currentIndex)
    tabAlert.nextTab()
end

local function initOrBefore()
    local currentWindow = hs.window.focusedWindow()
    if (currentWindow == nil) then
        return nil;
    end

    local appName = currentWindow:application():name()
    if appName == nil then
        return ;
    end

    local tabName = getTabName(appName)
    local currentTabName = tabAlert.getTabName()
    if tabName == currentTabName then
        tabAlert.beforeTab()
        return ;
    end

    local windowList = getSortedWindows(appName)
    local title = '[[' .. appName .. ']]'
    local currentIndex = Arr.findIndex(windowList, function(aWindow, i)
        return aWindow:id() == currentWindow:id()
    end)

    tabAlert.startTab(tabName, title, windowList, currentIndex)
    tabAlert.beforeTab()
end

return {
    initOrNext = initOrNext,
    initOrBefore = initOrBefore,
}
