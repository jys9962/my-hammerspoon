local controller = require('libs/optionKey/Controller')

local function register(key, appName, launchName)
    hs.hotkey.bind({ 'option' }, key, function()
        controller.initOrNext(appName, launchName)
    end)

    hs.hotkey.bind({ 'option', 'shift' }, key, function()
        controller.before(appName, launchName)
    end)
end

return {
    register = register
}
