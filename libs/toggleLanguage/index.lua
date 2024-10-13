local function init(key, inputEnglish, inputKorean)
    hs.hotkey.bind({}, key, function()
        local current = hs.keycodes.currentSourceID()
        local next = current == inputEnglish
                and inputKorean
                or inputEnglish
        local alertText = next == inputEnglish
                and 'ABC'
                or '가나다'

        hs.alert.closeAll()
        hs.alert.show(alertText, {
            fillColor = { white = 0 },
            textColor = { white = 1 },
            textFont = ".AppleSystemUIFont",
            textSize = 18,
            radius = 30,
            atScreenEdge = 0,
            fadeInDuration = 0,
            fadeOutDuration = 0,
            padding = 20
        })
        hs.keycodes.currentSourceID(next)
    end)
end

return {
    init = init
}
