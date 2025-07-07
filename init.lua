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

        -- OptionKey.register('1', 'Cursor', 'Cursor.app')
--         OptionKey.register('1', 'RustRover')
    OptionKey.register('1', 'WebStorm')
--     OptionKey.register('1', 'IntelliJ IDEA')
--     OptionKey.register('1', 'Android Studio')
--     OptionKey.register('1', 'PyCharm')
    OptionKey.register('2', 'NAVER Whale', 'Whale.app')
    OptionKey.register('3', 'DataGrip')
    OptionKey.register('4', 'iTerm2', 'iTerm.app')
    OptionKey.register('5', 'Claude', 'Claude.app')
    OptionKey.register('6', 'Notion')

    OptionKey.register('k', 'KakaoTalk', 'KakaoTalk.app')
    -- OptionKey.register('f', 'Finder')
    OptionKey.register('m', '메모', "notes.app")
    --OptionKey.register('p', 'GIPHY CAPTURE', "GIPHY CAPTURE.app")
--     OptionKey.register('m', 'Activity Monitor', 'Activity Monitor.app')
    OptionKey.register('g', 'ChatGPT')
    OptionKey.register('v', 'Code', 'Visual Studio Code.app')
    OptionKey.register('y', '크레마 예스24 eBook', 'YES24_eBook.app')
    OptionKey.register('o', 'iPadB2C', '교보eBook.app')
     OptionKey.register('r', 'Cursor', 'Cursor.app')
end

function initCtrlScroll()
    local ctrlScroll = require('libs.ctrlScroll.index')
    ctrlScroll.init('ctrl', 4)
end

function initEventPublisher()
    local name = 'iPadB2C'

    function eventSender(appName, mods, key)
        local app = hs.application.find(appName)
        local currentWindow = hs.window.focusedWindow()

        if app == nil then
            hs.alert.show("not found : ", windowName)
            return ;
        end

        app:activate()
        --targetWindow:focus()
        hs.eventtap.keyStroke(mods, key)
        if currentWindow then
            currentWindow:focus()
        end
    end

    function beforePageKyoboEbook()
        eventSender(name, {}, 'left')
    end

    function nextPageKyoboEbook()
        eventSender(name, {}, 'right')
    end

    hs.hotkey.bind('option', 'pageUp', beforePageKyoboEbook)
    hs.hotkey.bind('option', 'pageDown', nextPageKyoboEbook)
    hs.hotkey.bind('option', '[', beforePageKyoboEbook)
    hs.hotkey.bind('option', ']', nextPageKyoboEbook)
end

function initCommandBacktick()
    local commandBacktick = require('libs.commandBacktick.index')
    commandBacktick.init()
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


initForHammerspoonConsole()
initOptionKey()
initCtrlScroll()
initEventPublisher()
initCommandBacktick()
initLangToggle()
initCloseWindow()
