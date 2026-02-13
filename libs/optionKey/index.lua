local controller = require('libs.optionKey.Controller')

local function registerHyper(key, appName, launchName)
    local function initOrNext()
        controller.initOrNext(appName, launchName)
    end

    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, key, initOrNext, nil, initOrNext)
end

local function register(key, appName, launchName)
    local function initOrNext()
        controller.initOrNext(appName, launchName)
    end

    local function before()
        controller.before(appName, launchName)
    end

    hs.hotkey.bind({ 'option' }, key, initOrNext, nil, initOrNext)
    hs.hotkey.bind({ 'option', 'shift' }, key, before, nil, before)
    registerHyper(key, appName, launchName)
end

return {
    register = register,
    registerHyper = registerHyper
}
