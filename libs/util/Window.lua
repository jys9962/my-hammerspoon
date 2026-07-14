local Fp = require('libs.util.Fp')
local Arr = require('libs.util.ArrayUtil')

_window_map = {}

local function getWindowList(listByApi, oldList)
    --local timestamp = os.time()

    return Fp.pipe(
            oldList,

            Fp.tap(function(t)
                --print(t);
            end),

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

local function getList(bundleID)
    _window_map[bundleID] = getWindowList(collectWindows(bundleID), _window_map[bundleID] or {})
    return _window_map[bundleID]
end

-- 캐시된 윈도우 목록에서 fromIndex 창을 toIndex 위치로 옮긴다.
-- getList가 반환하는 배열과 동일 객체를 in-place 수정하므로 순서가 그대로 유지된다.
local function reorder(bundleID, fromIndex, toIndex)
    local list = _window_map[bundleID]
    if list == nil then
        return ;
    end

    local n = #list
    if fromIndex < 1 or fromIndex > n or toIndex < 1 or toIndex > n then
        return ;
    end

    local w = table.remove(list, fromIndex)
    table.insert(list, toIndex, w)
end

return {
    getList = getList,
    reorder = reorder,
}
