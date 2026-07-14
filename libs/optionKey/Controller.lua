local tabAlert = require('libs.util.TabAlert')
local windows = require('libs.util.Window')

local settingKeyPrefix = 'optionKey.selectedApp.'
local appChooser = nil

local function getTabName(bundleID)
    return 'winKey-' .. bundleID
end

-- app 인자는 단일 bundleID(string) 이거나 bundleID 목록(table)이다.
local function isAppList(app)
    return type(app) == 'table'
end

local function getSelectedBundleID(key, app)
    if not isAppList(app) then
        return app
    end

    local selected = hs.settings.get(settingKeyPrefix .. key)
    for _, bundleID in ipairs(app) do
        if bundleID == selected then
            return bundleID
        end
    end

    return app[1]
end

local function initOrNext(key, app)
    local bundleID = getSelectedBundleID(key, app)
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

local function before(key, app)
    local bundleID = getSelectedBundleID(key, app)
    local tabName = getTabName(bundleID)
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

        hs.settings.set(settingKeyPrefix .. key, choice.bundleID)
        hs.alert.show('Hyper+' .. key .. ': ' .. choice.text)
    end)

    local choices = {}
    local selected = getSelectedBundleID(key, app)
    for _, bundleID in ipairs(app) do
        local text = hs.application.nameForBundleID(bundleID) or bundleID
        if bundleID == selected then
            text = text .. ' [selected]'
        end

        table.insert(choices, {
            text = text,
            subText = bundleID,
            bundleID = bundleID
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
