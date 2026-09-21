local RETRY_DELAY_SECONDS = 0.04
local MAX_ATTEMPTS = 3

local state = {
    requestId = 0,
    target = nil,
    timer = nil
}

local alertStyle = {
    fillColor = { white = 0 },
    textColor = { white = 1 },
    textFont = ".AppleSystemUIFont",
    textSize = 18,
    radius = 30,
    atScreenEdge = 0,
    fadeInDuration = 0,
    fadeOutDuration = 0,
    padding = 20
}

local function showAlert(text)
    hs.alert.closeAll()
    hs.alert.show(text, alertStyle)
end

local function stopTimer()
    if state.timer ~= nil then
        state.timer:stop()
        state.timer = nil
    end
end

local function finish(requestId, target, alertText, attempt)
    if requestId ~= state.requestId then
        return
    end

    state.timer = nil

    if hs.keycodes.currentSourceID() == target then
        state.target = nil
        showAlert(alertText)
        return
    end

    if attempt >= MAX_ATTEMPTS then
        local current = hs.keycodes.currentSourceID()
        state.target = nil
        hs.printf(
                '[toggleLanguage] Failed to switch input source: target=%s, current=%s',
                target,
                tostring(current)
        )
        showAlert('한/영 전환 실패')
        return
    end

    local changed = hs.keycodes.currentSourceID(target)
    if not changed then
        hs.printf(
                '[toggleLanguage] Input source switch attempt %d failed: target=%s',
                attempt + 1,
                target
        )
    end

    state.timer = hs.timer.doAfter(RETRY_DELAY_SECONDS, function()
        finish(requestId, target, alertText, attempt + 1)
    end)
end

local function requestSwitch(target, alertText)
    state.requestId = state.requestId + 1
    local requestId = state.requestId

    stopTimer()
    state.target = target

    local changed = hs.keycodes.currentSourceID(target)
    if not changed then
        hs.printf(
                '[toggleLanguage] Input source switch attempt 1 failed: target=%s',
                target
        )
    end

    state.timer = hs.timer.doAfter(RETRY_DELAY_SECONDS, function()
        finish(requestId, target, alertText, 1)
    end)
end

local function init(key, inputEnglish, inputKorean)
    hs.hotkey.bind({}, key, function()
        -- macOS가 직전 요청을 아직 반영하지 않았을 수 있으므로, 전환 중에는
        -- 시스템 값 대신 마지막 목표값을 기준으로 다음 언어를 계산한다.
        local current = state.target or hs.keycodes.currentSourceID()
        local next = current == inputEnglish
                and inputKorean
                or inputEnglish
        local alertText = next == inputEnglish
                and 'ABC'
                or '가나다'

        requestSwitch(next, alertText)
    end)
end

return {
    init = init
}
