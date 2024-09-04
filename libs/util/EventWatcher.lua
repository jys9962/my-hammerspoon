EventWatcher = {}
local callbackList = {}

ctrlWatcher = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(event)
    local flags = event:getFlags()
    for i, v in pairs(flags) do
        print(i, v)
    end
    if not flags.alt and not flags.cmd and not flags.ctrl then
        for index, value in ipairs(callbackList) do
            value()
        end
    end
end)

EventWatcher.new = function()
    local obj = {}
    obj.callback = nil

    obj.listen = function(self, callback)
        table.insert(callbackList, callback)
        ctrlWatcher:start()
    end

    return obj
end

return EventWatcher
