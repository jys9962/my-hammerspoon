local controller = require('libs/commandBacktick/Controller')

function init()
    hs.hotkey.bind({ 'command' }, '`', controller.initOrNext, nil, controller.initOrNext)
    hs.hotkey.bind({ 'command', 'shift' }, '`', controller.before, nil, controller.before)
end

return {
    init = init
}
