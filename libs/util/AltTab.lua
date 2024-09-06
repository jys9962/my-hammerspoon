local EventWatcher = require('libs/util/EventWatcher')
watcher = EventWatcher.new()

local switcher = {
    tabName = nil,
    drawings = {},
    windows = nil,
    selectedIndex = 1
}

-- 그래픽 요소 생성
local function createDrawings()
    local screen = hs.screen.primaryScreen()
    local screenFrame = screen:frame()

    local numWindows = #switcher.windows
    local columns = math.min(numWindows, 5)
    local rows = math.ceil(numWindows / columns)

    local itemWidth = 200
    local itemHeight = 150
    local padding = 20
    local textHeight = 20

    local totalWidth = columns * (itemWidth + padding) - padding
    local totalHeight = rows * (itemHeight + textHeight + padding) - padding

    local startX = screenFrame.x + (screenFrame.w - totalWidth) / 2
    local startY = screenFrame.y + (screenFrame.h - totalHeight) / 2

    -- 배경 생성
    local background = hs.drawing.rectangle(hs.geometry.rect(screenFrame.x, screenFrame.y, screenFrame.w, screenFrame.h))
    background:setFillColor({ red = 0, green = 0, blue = 0, alpha = 0.7 })
    background:setStroke(false)
    background:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
    background:setLevel(hs.drawing.windowLevels.popUpMenu)
    table.insert(switcher.drawings, background)

    for i, win in ipairs(switcher.windows) do
        local col = (i - 1) % columns
        local row = math.floor((i - 1) / columns)

        local x = startX + col * (itemWidth + padding)
        local y = startY + row * (itemHeight + textHeight + padding)

        -- 썸네일 생성
        local thumbnail = hs.drawing.image(hs.geometry.rect(x, y, itemWidth, itemHeight), win:snapshot())
        thumbnail:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        thumbnail:setLevel(hs.drawing.windowLevels.popUpMenu)
        table.insert(switcher.drawings, thumbnail)

        -- 윈도우 이름 생성
        local windowName = win:application():name() .. " - " .. win:title()
        if #windowName > 30 then
            windowName = string.sub(windowName, 1, 27) .. "..."
        end
        local text = hs.drawing.text(hs.geometry.rect(x, y + itemHeight, itemWidth, textHeight), windowName)
        text:setTextColor({ white = 1 })
        text:setTextSize(12)
        text:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        text:setLevel(hs.drawing.windowLevels.popUpMenu)
        table.insert(switcher.drawings, text)

        -- 선택된 항목 강조
        if i == switcher.selectedIndex then
            local highlight = hs.drawing.rectangle(hs.geometry.rect(x - 5, y - 5, itemWidth + 10, itemHeight + textHeight + 10))
            highlight:setStrokeColor({ red = 1, green = 0, blue = 0, alpha = 1 })
            highlight:setStrokeWidth(3)
            highlight:setFillColor({ red = 0, green = 0, blue = 0, alpha = 0 })
            highlight:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
            highlight:setLevel(hs.drawing.windowLevels.popUpMenu)
            table.insert(switcher.drawings, highlight)
        end
    end
end

-- 그래픽 요소 표시
local function showDrawings()
    for _, drawing in ipairs(switcher.drawings) do
        drawing:show()
    end
end

-- 그래픽 요소 숨기기 및 삭제
local function hideAndDeleteDrawings()
    for _, drawing in ipairs(switcher.drawings) do
        drawing:hide()
        drawing:delete()
    end
    switcher.drawings = {}
end

-- Alt-Tab 기능 시작
local function startSwitcher(tabName, windowList, currentIndex)
    switcher.tabName = tabName
    switcher.windows = windowList
    switcher.selectedIndex = currentIndex

    createDrawings()
    showDrawings()
end

-- Alt-Tab 기능 종료
local function stopSwitcher()
    hideAndDeleteDrawings()

    if switcher.windows and switcher.windows[switcher.selectedIndex] then
        switcher.windows[switcher.selectedIndex]:focus()
    end

    switcher.tabName = nil
    switcher.windows = nil
    switcher.selectedIndex = 1
end

local function getTabName()
    return switcher.tabName
end

-- 다음 윈도우 선택
local function selectNextWindow()
    switcher.selectedIndex = switcher.selectedIndex % #switcher.windows + 1
    hideAndDeleteDrawings()
    createDrawings()
    showDrawings()
end

-- 이전 윈도우 선택
local function selectPrevWindow()
    switcher.selectedIndex = (switcher.selectedIndex - 2 + #switcher.windows) % #switcher.windows + 1
    hideAndDeleteDrawings()
    createDrawings()
    showDrawings()
end

watcher:listen(function()
    if switcher.tabName == nil then
        return ;
    end

    stopSwitcher()
end)

return {
    createDrawings = createDrawings,
    showDrawings = showDrawings,
    hideAndDeleteDrawings = hideAndDeleteDrawings,
    startSwitcher = startSwitcher,
    stopSwitcher = stopSwitcher,
    getTabName = getTabName,
    selectNextWindow = selectNextWindow,
    selectPrevWindow = selectPrevWindow,
}
