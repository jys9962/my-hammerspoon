local Controller = require('libs/beforeWindow/Controller')

BeforeWindow = {}
BeforeWindow.__index = BeforeWindow
function BeforeWindow.new()
    local self = setmetatable({}, BeforeWindow)
    self.controller = Controller.new()
    return self
end

function BeforeWindow:init()
    hs.hotkey.bind({ 'option' }, '`', function()
        self.controller:next()
    end)
    hs.hotkey.bind({ 'option', 'shift' }, '`', function()
        self.controller:before()
    end)

end

return BeforeWindow
