local Controller = require('libs/optionKey/Controller')

OptionKey = {}
OptionKey.__index = OptionKey
function OptionKey.new()
    local self = setmetatable({}, OptionKey)
    self.controller = Controller.new()
    return self
end

function OptionKey:register(key, appName, launchName)
    local controller = self.controller
    hs.hotkey.bind({ 'option' }, key, function()
        controller:next(appName, launchName)
    end)
end

return OptionKey
