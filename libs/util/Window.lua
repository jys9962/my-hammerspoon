windowData = {
    apps = {},
    watcher = nil,
}

local function getWindowList(app)
    local appName = app:name()
    local byApp = app:allWindows()
    local byStorage = windowData.apps[appName]

    local result = {}
    for _, t in ipairs(byStorage) do
        for _, j in ipairs(byApp) do
            if j:id() == t:id() then
                table.insert(result, j)
                break
            end
        end
    end

    for _, t in ipairs(byApp) do
        local has = false
        for _, j in ipairs(windowData.apps[app:name()]) do
            if j:id() == t:id() then
                has = true
                break
            end
        end
        if not has then
            table.insert(result, t)
        end
    end

    return result
end

local function getList(appName)
    local app = hs.application.get(appName)
    if not app then
        return {}
    end

    local currentWindows = app:allWindows()
    if not windowData.apps[appName] then
        windowData.apps[appName] = currentWindows
        return currentWindows
    end

    windowData.apps[appName] = getWindowList(app)

    return windowData.apps[appName]
end

local function init()
    windowData.watcher = hs.application.watcher.new(function(appName, eventType, app)
        if not windowData.apps[appName] then
            return
        end

        windowData.apps[appName] = getWindowList(app)
    end)
    windowData.watcher:start()
end

init()

return {
    getList = getList
}
