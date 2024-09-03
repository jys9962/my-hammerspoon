EventWatcher = {}
local callbackList = {}

ctrlWatcher = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(event)
    local flags = event:getFlags()
    if not flags.alt then
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
