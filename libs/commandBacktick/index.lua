local Controller = require('libs/commandBacktick/Controller')

CommandBacktick = {}
CommandBacktick.__index = CommandBacktick
function CommandBacktick.new()
    local self = setmetatable({}, CommandBacktick)
    self.controller = Controller.new()
    return self
end

function CommandBacktick:init()
    hs.hotkey.bind({ 'command' }, '`', function()
        self.controller:next()
    end)
    hs.hotkey.bind({ 'command', 'shift' }, '`', function()
        self.controller:before()
    end)

end

return CommandBacktick
