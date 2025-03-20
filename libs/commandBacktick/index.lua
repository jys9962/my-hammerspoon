local controller = require('libs.commandBacktick.Controller')

function init()
    hs.hotkey.bind({ 'command' }, '`', controller.initOrNext, nil, controller.initOrNext)
    hs.hotkey.bind({ 'command', 'shift' }, '`', controller.initOrBefore, nil, controller.initOrBefore)
end

return {
    init = init
}
