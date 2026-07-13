-- 예제 설정 파일입니다.
-- 이 파일을 init.lua 로 복사한 뒤 본인 환경에 맞게 앱 목록을 수정하세요.
--   cp init.example.lua init.lua
-- init.lua 는 개인 설정이므로 .gitignore 에 등록되어 커밋되지 않습니다.

function initForHammerspoonConsole()
    hs.alert.show('init')
    hs.console.clearConsole()

    hs.hotkey.bind({ 'option', 'cmd' }, 'r', function()
        hs.reload()
    end)
    hs.hotkey.bind({ 'option', 'cmd' }, 'c', function()
        hs.console
          .hswindow()
          :focus()
    end)
    hs.hotkey.bind({ 'option', 'cmd' }, 'i', function()
        local app = hs.window.focusedWindow():application()
        print('currentAppName: ' .. app:name())
        print('currentBundleID: ' .. (app:bundleID() or 'nil'))
        print('currentWindowName: ' .. hs.window.focusedWindow():title())
    end)
end

function initOptionKey()
    local OptionKey = require('libs.optionKey.index')

    -- 전부 bundleID 기반. bundleID는 대상 앱을 포커스한 상태에서
    -- option+cmd+i 를 눌러 콘솔에서 확인할 수 있다.
    -- 아래는 예시이므로 본인이 사용하는 앱으로 바꿔 등록하세요.
    OptionKey.register('1', {
        'com.jetbrains.pycharm',   -- PyCharm
        'com.jetbrains.PhpStorm',  -- PhpStorm
    })

    OptionKey.register('2', 'com.naver.Whale')                -- NAVER Whale
    OptionKey.register('4', 'com.googlecode.iterm2')          -- iTerm2
    OptionKey.register('5', 'com.tinyspeck.slackmacgap')      -- Slack
    OptionKey.register('`', 'com.apple.finder')               -- Finder

    OptionKey.registerHyper('c', 'com.apple.iCal')            -- 캘린더
    OptionKey.registerHyper('f', 'com.figma.Desktop')         -- Figma
end

function initCloseWindow()
    hs.hotkey.bind('option', 'q', function()
        local currentWindow = hs.window.focusedWindow()
        if currentWindow == nil then
            return ;
        end

        currentWindow:close()
    end)
end

local CommandBacktick = require('libs.commandBacktick.index')
CommandBacktick.init()

local WindowReorder = require('libs.windowReorder.index')
WindowReorder.init()

function initMoveWindow()
    local function move_win(xx, yy, ww, hh)
        return function()
            local win = hs.window.focusedWindow()
            local f = win:frame()
            local max = win:screen():frame()
            f.x = max.x + max.w * xx
            f.y = max.y + max.h * yy
            f.w = max.w * ww
            f.h = max.h * hh
            win:setFrame(f)
        end
    end
    local function win_to_left()
        local win = hs.window.focusedWindow()
        win:moveOneScreenWest(false, true, 0.05)
    end
    local function win_to_right()
        local win = hs.window.focusedWindow()
        win:moveOneScreenEast(false, true, 0.05)
    end
    local function win_to_up()
        local win = hs.window.focusedWindow()
        win:moveOneScreenNorth(false, true, 0.05)
    end
    local function win_to_down()
        local win = hs.window.focusedWindow()
        win:moveOneScreenSouth(false, true, 0.05)
    end

    hs.hotkey.bind({ 'option', 'cmd', 'ctrl', 'shift' }, 'left', move_win(0, 0, 1 / 2, 1))
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl', 'shift' }, 'right', move_win(1 / 2, 0, 1 / 2, 1))
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl', 'shift' }, 'up', move_win(0, 0, 1, 1 / 2))
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl', 'shift' }, 'down', move_win(0, 1 / 2, 1, 1 / 2))
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'left', win_to_left)
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'right', win_to_right)
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'up', move_win(0, 0, 1, 1))
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'down', move_win(1 / 7, 1 / 7, 5 / 7, 5 / 7))
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'return', move_win(0, 0, 1, 1))
end

initForHammerspoonConsole()
initOptionKey()
initCloseWindow()
initMoveWindow()
