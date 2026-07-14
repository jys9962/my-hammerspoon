local controller = require('libs.optionKey.Controller')

local function registerHyper(key, app)
    local function initOrNext()
        controller.initOrNext(key, app)
    end

    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, key, initOrNext, nil, initOrNext)

    if controller.isAppList(app) then
        hs.hotkey.bind({ 'option', 'cmd', 'ctrl', 'shift' }, key, function()
            controller.chooseApp(key, app)
        end)
    end
end

local function register(key, app)
    local function initOrNext()
        controller.initOrNext(key, app)
    end

    local function before()
        controller.before(key, app)
    end

    hs.hotkey.bind({ 'option' }, key, initOrNext, nil, initOrNext)
    hs.hotkey.bind({ 'option', 'shift' }, key, before, nil, before)
    registerHyper(key, app)
end

return {
    register = register,
    registerHyper = registerHyper
}
