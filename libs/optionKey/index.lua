local controller = require('libs.optionKey.Controller')

local function registerHyper(key, appName, launchName)
    local function initOrNext()
        controller.initOrNext(key, appName, launchName)
    end

    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, key, initOrNext, nil, initOrNext)

    if controller.isAppList(appName) then
        hs.hotkey.bind({ 'option', 'cmd', 'ctrl', 'shift' }, key, function()
            controller.chooseApp(key, appName)
        end)
    end
end

local function register(key, appName, launchName)
    local function initOrNext()
        controller.initOrNext(key, appName, launchName)
    end

    local function before()
        controller.before(key, appName, launchName)
    end

    hs.hotkey.bind({ 'option' }, key, initOrNext, nil, initOrNext)
    hs.hotkey.bind({ 'option', 'shift' }, key, before, nil, before)
    registerHyper(key, appName, launchName)
end

return {
    register = register,
    registerHyper = registerHyper
}
