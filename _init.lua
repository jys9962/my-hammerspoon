function initForHammerspoonConsole()
    hs.alert.show('init')
    hs.console.clearConsole()

    hs.hotkey.bind({ 'option', 'cmd', 'ctrl', 'shift' }, '1', function()
        print(123)
    end)

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

    -- 전부 bundleID 기반. (bundleID만 넘기면 이름/실행은 자동 처리)
    -- bundleID는 대상 앱을 포커스한 상태에서 option+cmd+i 를 눌러 콘솔에서 확인.
    OptionKey.register('1', 'com.jetbrains.pycharm')      -- PyCharm
    OptionKey.register('2', 'com.naver.Whale')            -- NAVER Whale
    OptionKey.register('3', 'com.jetbrains.datagrip')     -- DataGrip
    OptionKey.register('4', 'com.googlecode.iterm2')      -- iTerm2
    OptionKey.register('5', 'com.openai.codex')           -- ChatGPT
    OptionKey.register('6', 'notion.id')                  -- Notion

    OptionKey.register('k', 'com.kakao.KakaoTalkMac')     -- KakaoTalk
    OptionKey.register('`', 'com.apple.finder')           -- Finder
    OptionKey.register('m', 'com.apple.Notes')            -- 메모
    OptionKey.register('8', 'com.electron.dockerdesktop') -- Docker Desktop
    OptionKey.register('9', 'com.microsoft.VSCode')       -- Visual Studio Code
    OptionKey.register('g', 'com.anthropic.claudefordesktop') -- Claude

    -- 이름(ChatGPT)이 같은 두 앱을 bundleID로 구분
    OptionKey.registerHyper('x', 'com.openai.codex')      -- ChatGPT.app
    OptionKey.registerHyper('t', 'com.openai.chat')       -- ChatGPT Classic.app
    OptionKey.registerHyper('s', 'com.lampese.codex-switcher') -- Codex Switcher
    OptionKey.registerHyper('a', 'com.google.antigravity') -- Antigravity

    -- OptionKey.register('r', 'Cursor', 'Cursor.app')

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

local chooser = hs.chooser.new(function(choice)
    hs.alert.show(choice.text)
end)

hs.hotkey.bind({ 'option' }, 'l', function()
    local list = {}
    table.insert(list, {
        text = 'alert1',
        subText = '화면에 첫 번째 알림을 띄웁니다',
        -- image = hs.image.imageFromPath( 이미지 주소 .. '.jpg'),
    })
    table.insert(list, {
        text = 'alert2',
        subText = '화면에 두 번째 알림을 띄웁니다',
        -- image = hs.image.imageFromPath( 이미지 주소 .. '.jpg'),
    })
    chooser:choices(list)
    chooser:show()
end)

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

    hs.hotkey.bind({ 'option', 'cmd', 'ctrl'}, 'left', move_win(0, 0, 1 / 2, 1))
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl'}, 'right', move_win(1 / 2, 0, 1 / 2, 1))
    --hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'up', move_win(0, 0, 1, 1 / 2))
    --hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'down', move_win(0, 1 / 2, 1, 1 / 2))
    --hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'left', win_to_left)
    --hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'right', win_to_right)
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'up', move_win(0, 0, 1, 1))
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'down', move_win(1 / 7, 1 / 7, 5 / 7, 5 / 7))
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'return', move_win(0, 0, 1, 1))
    --hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'return', move_win(0, 0, 1, 1))
end

initMoveWindow()
initForHammerspoonConsole()
initOptionKey()
initCloseWindow()
