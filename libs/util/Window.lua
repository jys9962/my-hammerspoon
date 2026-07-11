local Fp = require('libs.util.Fp')
local Arr = require('libs.util.ArrayUtil')

local _window_map = {}
local _watched = {}

local function getWindowList(listByApi, oldList)
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

-- 이름이 같은 다른 앱까지 정확히 구분하기 위해 bundleID로 조회한다.
-- 같은 bundleID의 인스턴스가 여러 개여도 모든 window를 모은다.
local function collectWindows(bundleID)
    local list = {}
    for _, app in ipairs(hs.application.applicationsForBundleID(bundleID) or {}) do
        for _, w in ipairs(app:allWindows()) do
            table.insert(list, w)
        end
    end
    return list
end

local function watchApp(bundleID)
    if _watched[bundleID] then
        return ;
    end
    _watched[bundleID] = true

    local wf = hs.window.filter.new(function(win)
        local app = win:application()
        return app ~= nil and app:bundleID() == bundleID
    end)

    local function refresh()
        _window_map[bundleID] = getWindowList(collectWindows(bundleID), _window_map[bundleID] or {})
    end

    wf:subscribe(hs.window.filter.windowCreated, refresh)
    wf:subscribe(hs.window.filter.windowDestroyed, refresh)
end

local function getList(bundleID)
    _window_map[bundleID] = getWindowList(collectWindows(bundleID), _window_map[bundleID] or {})
    return _window_map[bundleID]
end

return {
    watch = watchApp,
    getList = getList
}
