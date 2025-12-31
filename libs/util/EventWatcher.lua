local data = {
    list = {}
}

local ctrlWatcher = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(event)
    local flags = event:getFlags()
    if not flags.alt and not flags.cmd and not flags.ctrl then
        for index, value in ipairs(data.list) do
            value()
        end
    end
end)

local function listen(callback)
    table.insert(data.list, callback)
    ctrlWatcher:start()
end

return {
    listen = listen
}
