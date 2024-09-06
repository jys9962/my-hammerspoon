local controller = require('libs/commandBacktick/Controller')

function init()
    hs.hotkey.bind({ 'command' }, '`', function()
        controller.initOrNext()
    end)
    hs.hotkey.bind({ 'command', 'shift' }, '`', function()
        controller.before()
    end)
end

return {
    init = init
}
