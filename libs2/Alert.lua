function toText(appName, windowList, selectedIndex)
    local result = '    [ ' .. appName .. ']    \n'
    for index, value in ipairs(windowList) do
        if (index == selectedIndex) then
            result = result .. '\nV '
        else
            result = result .. '\n    '
        end

        result = result .. value:title()
    end

    return result
end

TabAlert = {
    show = function(appName, windowList, index)
        hs.alert.closeAll()

        local message = toText(appName, windowList, index)
        hs.alert.show(message, {
            strokeWidth = 3,
            strokeColor = { white = 1, alpha = 1 },
            fillColor = { red = 0.1, green = 0.3, blue = 0.8, alpha = 1 },
            textColor = { white = 1, alpha = 1 },
            textFont = ".AppleSystemUIFont",
            textSize = 23,
            radius = 10,
            atScreenEdge = 0,
            fadeInDuration = 0,
            fadeOutDuration = 0,
            padding = 20
        }
        )
    end,
    close = function()
        hs.alert.closeAll()
    end
}

return TabAlert
