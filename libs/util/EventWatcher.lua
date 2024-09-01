local ctrlPressed = false
local EventWatcher = {}
local callbackList = {}

local ctrlWatcher = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(event)
    local flags = event:getFlags()
    if flags.alt and not ctrlPressed then
        ctrlPressed = true
        --print("Control 키 눌림")
    elseif not flags.alt then
        ctrlPressed = false
        --print("Control 키 떼어짐")

        for index, value in ipairs(callbackList) do
            value()
        end
        callbackList = {}
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
