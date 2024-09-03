local Controller = require('libs/winTab/Controller')

WinTab = {}
WinTab.__index = WinTab
function WinTab.new()
    local self = setmetatable({}, WinTab)
    self.controller = Controller.new()
    return self
end

function WinTab:register(key, appName, launchName)
    local controller = self.controller
    hs.hotkey.bind({ 'option' }, key, function()
        controller:clickAppKey(appName, launchName)
    end)
end

return WinTab
