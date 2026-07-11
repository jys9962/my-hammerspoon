local windows = require('libs.util.Window')
local controller = require('libs.optionKey.Controller')

local function registerHyper(key, bundleID)
    local function initOrNext()
        controller.initOrNext(bundleID)
    end

    windows.watch(bundleID)
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, key, initOrNext, nil, initOrNext)
end

local function register(key, bundleID)
    local function initOrNext()
        controller.initOrNext(bundleID)
    end

    local function before()
        controller.before(bundleID)
    end

    windows.watch(bundleID)
    hs.hotkey.bind({ 'option' }, key, initOrNext, nil, initOrNext)
    hs.hotkey.bind({ 'option', 'shift' }, key, before, nil, before)
    registerHyper(key, bundleID)
end

return {
    register = register,
    registerHyper = registerHyper
}
