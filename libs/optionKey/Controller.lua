local tabAlert = require('libs.util.TabAlert')
local windows = require('libs.util.Window')

local settingKeyPrefix = 'optionKey.selectedApp.'
local appChooser = nil

local function getTabName(appName)
    return 'winKey-' .. appName
end

local function getSortedWindows(name)
    return windows.getList(name)
end

local function isAppList(app)
    return type(app) == 'table' and app[1] ~= nil
end

local function normalizeApp(app, launchName)
    if type(app) == 'string' then
        return {
            appName = app,
            launchName = launchName
        }
    end

    return {
        appName = app.appName or app[1],
        launchName = app.launchName or app[2] or app.appName or app[1]
    }
end

local function getSelectedApp(key, app, launchName)
    if not isAppList(app) then
        return normalizeApp(app, launchName)
    end

    local selectedAppName = hs.settings.get(settingKeyPrefix .. key)
    for _, candidate in ipairs(app) do
        local normalizedCandidate = normalizeApp(candidate)
        if normalizedCandidate.appName == selectedAppName then
            return normalizedCandidate
        end
    end

    return normalizeApp(app[1])
end

local function initOrNext(key, app, launchName)
    local selectedApp = getSelectedApp(key, app, launchName)
    local appName = selectedApp.appName
    local tabName = getTabName(appName)
    local currentTabName = tabAlert.getTabName()
    if tabName == currentTabName then
        tabAlert.nextTab()
        return ;
    end

    local windowList = getSortedWindows(appName)
    if windowList == nil or #windowList == 0 then
        hs.application.launchOrFocus(selectedApp.launchName or appName)
        return ;
    end

    local title = appName
    tabAlert.startTab(tabName, title, windowList, 1)
end

local function before(key, app, launchName)
    local selectedApp = getSelectedApp(key, app, launchName)
    local appName = selectedApp.appName
    local tabName = getTabName(appName)
    local currentTabName = tabAlert.getTabName()

    if (tabName ~= currentTabName) then
        return ;
    end

    tabAlert.beforeTab()
end

local function chooseApp(key, app)
    if not isAppList(app) then
        return ;
    end

    appChooser = hs.chooser.new(function(choice)
        if choice == nil then
            return ;
        end

        hs.settings.set(settingKeyPrefix .. key, choice.appName)
        hs.alert.show('Hyper+' .. key .. ': ' .. choice.appName)
    end)

    local choices = {}
    local selectedApp = getSelectedApp(key, app)
    for _, candidate in ipairs(app) do
        local normalizedCandidate = normalizeApp(candidate)
        local text = normalizedCandidate.appName
        if normalizedCandidate.appName == selectedApp.appName then
            text = text .. ' [selected]'
        end

        table.insert(choices, {
            text = text,
            subText = normalizedCandidate.launchName,
            appName = normalizedCandidate.appName
        })
    end

    appChooser:choices(choices)
    appChooser:show()
end

return {
    initOrNext = initOrNext,
    before = before,
    chooseApp = chooseApp,
    isAppList = isAppList,
}
