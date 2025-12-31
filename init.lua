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

        OptionKey.register('1', 'PhpStorm', 'PhpStorm.app')
    --OptionKey.register('1', 'PyCharm', 'PyCharm.app')


    OptionKey.register('2', 'NAVER Whale', 'Whale.app')
    OptionKey.register('3', 'DataGrip', 'DataGrip.app')
    OptionKey.register('4', 'iTerm2', 'iTerm.app')
    OptionKey.register('5', 'Slack', 'Slack.app')
    OptionKey.register('6', 'Notion', 'Notion.app')

    OptionKey.register('k', 'KakaoTalk', 'KakaoTalk.app')
    OptionKey.register('`', 'Finder')
    OptionKey.register('m', '메모', "notes.app")
    --OptionKey.register('p', 'GIPHY CAPTURE', "GIPHY CAPTURE.app")
    --     OptionKey.register('m', 'Activity Monitor', 'Activity Monitor.app')
    OptionKey.register('8', 'Docker Desktop')
    OptionKey.register('9', 'Code', 'Visual Studio Code.app')
     OptionKey.register('g', 'Claude', 'Claude.app')
    --OptionKey.register('g', 'ChatGPT')
    -- OptionKey.register('r', 'Cursor', 'Cursor.app')
end

function initLangToggle()
    local inputEnglish = "com.apple.keylayout.ABC"
    local inputKorean = "com.apple.inputmethod.Korean.2SetKorean"

    local toggleLanguage = require('libs.toggleLanguage.index')
    toggleLanguage.init('f18', inputEnglish, inputKorean)
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


initForHammerspoonConsole()
initOptionKey()
--initLangToggle()
initCloseWindow()
