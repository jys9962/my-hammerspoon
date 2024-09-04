WindowUtil = {}
function WindowUtil.getAllWindow(appName)
    return hs.window.filter.new(appName)
             :setSortOrder(hs.window.filter.sortByCreated)
             :getWindows()
end

return WindowUtil
