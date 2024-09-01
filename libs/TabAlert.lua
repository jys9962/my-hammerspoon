local canvas = require("hs.canvas")
local screen = hs.screen.primaryScreen()
local screenFrame = screen:frame()
local application = require("hs.application")

local myCanvas = canvas.new({
    x = screenFrame.w * 0.1,
    y = screenFrame.h * 0.1,
    w = screenFrame.w * 0.8,
    h = screenFrame
        .h * 0.8
})

-- 배경 설정
myCanvas[1] = {
    type = "rectangle",
    action = "fill",
    fillColor = { alpha = 0.8, red = 0.1, green = 0.1, blue = 0.1 },
    roundedRectRadii = { xRadius = 10, yRadius = 10 },
}

-- 애플리케이션 아이콘 및 이름 표시 함수
local drawApps = function(apps)
    for i = 2, #myCanvas do
        myCanvas:removeElement(2)
    end

    local maxItemsPerRow = 4
    local itemWidth = myCanvas:frame().w / maxItemsPerRow
    local itemHeight = myCanvas:frame().h / 2

    local totalRows = math.ceil(#apps / maxItemsPerRow)
    local startY = (myCanvas:frame().h - (totalRows * itemHeight)) / 2

    for i, app in ipairs(apps) do
        local row = math.floor((i - 1) / maxItemsPerRow)
        local col = (i - 1) % maxItemsPerRow

        local x = col * itemWidth + (myCanvas:frame().w - math.min(#apps, maxItemsPerRow) * itemWidth) / 2
        local y = startY + row * itemHeight

        -- 아이콘
        myCanvas[#myCanvas + 1] = {
            type = "image",
            image = app:snapshot(),
            frame = {
                x = x + itemWidth * 0.1,
                y = y + itemHeight * 0.1,
                w = itemWidth * 0.8,
                h = itemHeight * 0.6
            }
        }

        -- 앱 이름
        myCanvas[#myCanvas + 1] = {
            type = "text",
            text = app:title(),
            textFont = "Helvetica",
            textSize = 16,
            textColor = { white = 1 },
            textAlignment = "center",
            frame = {
                x = x,
                y = y + itemHeight * 0.75,
                w = itemWidth,
                h = itemHeight * 0.2
            }
        }
    end
end

local selectIndex = function(window, selectedIndex)
    myCanvas[#myCanvas + 1] = {
        type = "rectangle",
        action = "stroke",
        strokeColor = { red = 1, green = 1, blue = 0 },
        strokeWidth = 4,
        frame = {
            x = x + itemWidth * 0.05,
            y = y + itemHeight * 0.05,
            w = itemWidth * 0.9,
            h = itemHeight * 0.9
        },
        roundedRectRadii = { xRadius = 10, yRadius = 10 },
    }
end

local TabAlert = {}
TabAlert.currentApp = nil
TabAlert.new = function()
    local obj = {}
    obj.isOpen = false
    obj.currentIndex = 1
    obj.init = function()
        obj.canvas = canvas.new({
            x = screenFrame.w * 0.1,
            y = screenFrame.h * 0.1,
            w = screenFrame.w * 0.8,
            h = screenFrame.h * 0.8
        })
        obj.canvas[1] = {
            type = "rectangle",
            action = "fill",
            fillColor = { alpha = 0.8, red = 0.1, green = 0.1, blue = 0.1 },
            roundedRectRadii = { xRadius = 10, yRadius = 10 },
        }
    end

    obj.setList = function(windowList)
        for i = 2, #myCanvas do
            myCanvas:removeElement(2)
        end

        local maxItemsPerRow = 4
        local itemWidth = myCanvas:frame().w / maxItemsPerRow
        local itemHeight = myCanvas:frame().h / 2

        local totalRows = math.ceil(#windowList / maxItemsPerRow)
        local startY = (myCanvas:frame().h - (totalRows * itemHeight)) / 2

        for i, appWindow in ipairs(windowList) do
            local row = math.floor((i - 1) / maxItemsPerRow)
            local col = (i - 1) % maxItemsPerRow

            local x = col * itemWidth + (myCanvas:frame().w - math.min(#windowList, maxItemsPerRow) * itemWidth) / 2
            local y = startY + row * itemHeight

            -- 아이콘
            myCanvas[#myCanvas + 1] = {
                type = "image",
                image = appWindow:snapshot(),
                frame = {
                    x = x + itemWidth * 0.1,
                    y = y + itemHeight * 0.1,
                    w = itemWidth * 0.8,
                    h = itemHeight * 0.6
                }
            }

            -- 앱 이름
            myCanvas[#myCanvas + 1] = {
                type = "text",
                text = appWindow:title(),
                textFont = "Helvetica",
                textSize = 16,
                textColor = { white = 1 },
                textAlignment = "center",
                frame = {
                    x = x,
                    y = y + itemHeight * 0.75,
                    w = itemWidth,
                    h = itemHeight * 0.2
                }
            }
        end
    end

    return obj
end

return TabAlert
--TabAlert.show = function(windowList, index)
--    drawApps(windowList, index)
--    myCanvas:show()
--end
--TabAlert.close = function()
--    print('hide MyCanvas')
--    myCanvas:hide()
--end
--
--return TabAlert
