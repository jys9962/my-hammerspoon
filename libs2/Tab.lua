local Controller = require('libs2/Controller')

Tab = {}
Tab.__index = Tab
function Tab.new()
    local self = setmetatable({}, Tab)
    self.controller = Controller.new()
    return self
end

function Tab:register(key, appName, launchName)
    local controller = self.controller
    hs.hotkey.bind({ 'option' }, key, function()
        controller:clickAppKey(appName, launchName)
    end)
end

return Tab
