local WindowFilter = require('hs.window.filter')
local Application = require('hs.application')
local Alert = require('libs/TabAlert')
local EventWatcher = require('libs/util/EventWatcher')
local WindowChooser = require('libs/WindowChooser')
local Controller = require('libs/Controller')

Switcher = {}
Switcher.__index = Switcher
function Switcher.new()
    local self = setmetatable({}, Switcher)
    self.controller = Controller.new()
    return self
end

function Switcher:register(key, appName)
    local controller = self.controller
    controller:setApp(key, appName)
    hs.hotkey.bind({ 'option' }, key, function()
        controller:clickNumberWithOption(key)
    end)
end

return Switcher
