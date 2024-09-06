local function init(mods, speed)
    local function scrollUp()
        local scrollEvent = hs.eventtap.event.newScrollEvent({ 0, -speed }, {}, "line")
        scrollEvent:post()
    end

    local function scrollDown()
        local scrollEvent = hs.eventtap.event.newScrollEvent({ 0, speed }, {}, "line")
        scrollEvent:post()
    end

    hs.hotkey.bind(mods, "up", scrollUp, nil, scrollUp)
    hs.hotkey.bind(mods, "down", scrollDown, nil, scrollDown)
end

return {
    init = init
}
