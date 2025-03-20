local windows = require('libs.util.Window')
local controller = require('libs.optionKey.Controller')

local function register(key, appName, launchName)
    local function initOrNext()
        controller.initOrNext(appName, launchName)
    end

    local function before()
        controller.before(appName, launchName)
    end

    windows.watch(appName)
    hs.hotkey.bind({ 'option' }, key, initOrNext, nil, initOrNext)
    hs.hotkey.bind({ 'option', 'shift' }, key, before, nil, before)
end

return {
    register = register
}
