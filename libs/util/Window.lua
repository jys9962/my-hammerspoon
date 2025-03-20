local Fp = require('libs.util.Fp')
local Arr = require('libs.util.ArrayUtil')

local _window_map = {}

local function getWindowList(app, oldList)
    local listByApi = app:allWindows()

    return Fp.pipe(
            oldList,

    -- 종료된 window 제거
            Fp.filter(function(t)
                return Arr.some(
                        listByApi,
                        function(k)
                            return t:id() == k:id()
                        end
                )
            end),

    -- 신규 window 추가
            Fp.concat(
                    Fp.pipe(
                            listByApi,
                            Fp.filter(function(t)
                                return Arr.every(oldList, function(k)
                                    return t:id() ~= k:id()
                                end)
                            end)
                    )
            ),

    -- 유효한 창만 필터링
            Fp.filter(function(t)
                return t:isMaximizable()
            end)
    )

end

local function watchApp(appName)
    if _window_map[appName] then
        return ;
    end

    local wf = hs.window.filter.new(appName)

    local function refresh(win)
        local app = win:application()
        _window_map[appName] = getWindowList(app, _window_map[appName] or {})
    end

    wf:subscribe(hs.window.filter.windowCreated, refresh)
    wf:subscribe(hs.window.filter.windowDestroyed, refresh)
end

local function getList(appName)
    local app = hs.application.get(appName)
    if not app then
        return {}
    end

    _window_map[appName] = getWindowList(app, _window_map[appName] or {})
    return _window_map[appName]
end

return {
    watch = watchApp,
    getList = getList
}
