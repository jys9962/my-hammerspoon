local controller = require('libs/optionBacktick/Controller')

local function init()
    hs.hotkey.bind({ 'option' }, '`', controller.initOrNext, nil, controller.initOrNext)
    hs.hotkey.bind({ 'option', 'shift' }, '`', controller.before, nil, controller.before)
end

return {
    init = init
}
