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
        print('currentAppName: ' .. hs.window.focusedWindow():application():name())
        print('currentWindowName: ' .. hs.window.focusedWindow():title())
    end)
end

function initOptionKey()
    local OptionKey = require('libs.optionKey.index')

    --OptionKey.register('1', 'PhpStorm', 'PhpStorm.app')
    OptionKey.register('1', 'PyCharm', 'PyCharm.app')
    OptionKey.register('2', 'NAVER Whale', 'Whale.app')
    OptionKey.register('3', 'DataGrip', 'DataGrip.app')
    OptionKey.register('4', 'iTerm2', 'iTerm.app')
    OptionKey.register('5', 'Slack', 'Slack.app')
    OptionKey.register('6', 'Notion', 'Notion.app')
    OptionKey.register('k', 'KakaoTalk', 'KakaoTalk.app')
    OptionKey.register('`', 'Finder')
    OptionKey.register('m', '메모', "notes.app")
    OptionKey.register('8', 'Docker Desktop')
    OptionKey.register('9', 'Code', 'Visual Studio Code.app')
    OptionKey.register('g', 'Claude', 'Claude.app')

    OptionKey.registerHyper('p', 'Postman', 'Postman.app')
    OptionKey.registerHyper('y', 'PyCharm', 'PyCharm.app')
    OptionKey.registerHyper('h', 'PhpStorm', 'PhpStorm.app')
    OptionKey.registerHyper('c', '캘린더', 'Calendar.app')
    OptionKey.registerHyper('t', 'ChatGPT', 'ChatGPT.app')
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

    --hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'left', move_win(0, 0, 1 / 2, 1))
    --hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'right', move_win(1 / 2, 0, 1 / 2, 1))
    --hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'up', move_win(0, 0, 1, 1 / 2))
    --hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'down', move_win(0, 1 / 2, 1, 1 / 2))
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'left', win_to_left)
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'right', win_to_right)
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'up', move_win(0, 0, 1, 1))
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'down', move_win(1 / 7, 1 / 7, 5 / 7, 5 / 7))
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'return', move_win(0, 0, 1, 1))
    --hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, 'return', move_win(0, 0, 1, 1))
end

function initLangToggle()
    local inputEnglish = "com.apple.keylayout.ABC"
    local inputKorean = "com.apple.inputmethod.Korean.2SetKorean"

    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, '[', function()
        hs.keycodes.currentSourceID(inputEnglish)
    end)
    hs.hotkey.bind({ 'option', 'cmd', 'ctrl' }, ']', function()
        hs.keycodes.currentSourceID(inputKorean)
    end)
end

initForHammerspoonConsole()
initOptionKey()
initCloseWindow()
initMoveWindow()
initLangToggle()
