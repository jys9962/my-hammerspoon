local Fp = require('libs.util.Fp')

-- hs.alert 은 텍스트만 그릴 수 있어 아이콘/하이라이트를 위해 hs.canvas 로 직접 그리는 목록 팝업.
-- TabAlert / AppAlert 가 공유한다. 두 팝업이 동시에 뜨지 않으므로 canvas 는 하나만 둔다.
local panel = nil

local style = {
    width = 340,
    -- 그림자가 잘리지 않도록 canvas 를 패널보다 이만큼 크게 잡는다.
    margin = 30,
    padding = 10,
    headerHeight = 44,
    footerHeight = 30,
    rowHeight = 42,
    iconSize = 26,
    headerIconSize = 20,
    radius = 14,
    font = '.AppleSystemUIFont',
    background = { red = 0.11, green = 0.11, blue = 0.12, alpha = 0.96 },
    border = { white = 1, alpha = 0.12 },
    accent = { red = 0.04, green = 0.52, blue = 1, alpha = 1 },
    title = { white = 1, alpha = 0.6 },
    text = { white = 1, alpha = 0.88 },
    selectedText = { white = 1, alpha = 1 },
    hint = { white = 1, alpha = 0.35 },
}

local function getAlertScreen()
    local screen = Fp.pipe(
            hs.screen.allScreens(),
            Fp.sort(function(t1, t2)
                return t1:frame().x > t2:frame().x;
            end)
    )[2]

    return screen or hs.screen.mainScreen()
end

local function hide()
    if panel ~= nil then
        panel:delete()
        panel = nil
    end
end

local function textElement(text, frame, size, color, alignment)
    return {
        type = 'text',
        text = text,
        textFont = style.font,
        textSize = size,
        textColor = color,
        textAlignment = alignment or 'left',
        textLineBreak = 'truncateTail',
        frame = frame,
    }
end

-- 한 줄 텍스트를 높이 h 인 영역의 세로 가운데에 놓기 위한 y 좌표.
local function centerY(y, h, textSize)
    return y + (h - textSize * 1.3) / 2
end

local function getHeaderElements(options, width)
    local m = style.margin
    local titleSize = 13
    local y = m + (style.headerHeight - style.headerIconSize) / 2

    if options.icon == nil then
        return {
            textElement(options.title, { x = m, y = centerY(m, style.headerHeight, titleSize), w = width, h = titleSize * 1.3 }, titleSize, style.title, 'center'),
        }
    end

    -- 아이콘 + 제목 묶음을 가운데 정렬하기 위해 제목 폭을 미리 잰다.
    local gap = 8
    local titleWidth = math.min(
            hs.drawing.getTextDrawingSize(options.title, { font = style.font, size = titleSize }).w + 4,
            width - style.headerIconSize - gap - style.padding * 2
    )
    local x = m + (width - style.headerIconSize - gap - titleWidth) / 2

    return {
        {
            type = 'image',
            image = options.icon,
            imageScaling = 'scaleProportionally',
            frame = { x = x, y = y, w = style.headerIconSize, h = style.headerIconSize },
        },
        textElement(options.title, { x = x + style.headerIconSize + gap, y = centerY(m, style.headerHeight, titleSize), w = titleWidth, h = titleSize * 1.3 }, titleSize, style.title),
    }
end

local function getElements(options, width, panelHeight)
    local m = style.margin
    local p = style.padding
    local elements = Fp.pipe(
            {
                {
                    type = 'rectangle',
                    action = 'strokeAndFill',
                    fillColor = style.background,
                    strokeColor = style.border,
                    strokeWidth = 1,
                    roundedRectRadii = { xRadius = style.radius, yRadius = style.radius },
                    frame = { x = m, y = m, w = width, h = panelHeight },
                    withShadow = true,
                    shadow = { blurRadius = 24, color = { alpha = 0.5 }, offset = { h = -8, w = 0 } },
                },
            },
            Fp.concat(getHeaderElements(options, width))
    )

    for index, item in ipairs(options.items) do
        local selected = index == options.selectedIndex
        local rowY = m + style.headerHeight + (index - 1) * style.rowHeight
        local rowX = m + p
        local rowW = width - p * 2

        if selected then
            table.insert(elements, {
                type = 'rectangle',
                action = 'fill',
                fillColor = style.accent,
                roundedRectRadii = { xRadius = 9, yRadius = 9 },
                frame = { x = rowX, y = rowY, w = rowW, h = style.rowHeight },
            })
        end

        local textX = rowX + 14
        if item.icon ~= nil then
            local iconX = rowX + 10
            table.insert(elements, {
                type = 'image',
                image = item.icon,
                imageScaling = 'scaleProportionally',
                frame = { x = iconX, y = rowY + (style.rowHeight - style.iconSize) / 2, w = style.iconSize, h = style.iconSize },
            })
            textX = iconX + style.iconSize + 12
        end

        local textSize = 15
        table.insert(elements, textElement(
                item.text,
                { x = textX, y = centerY(rowY, style.rowHeight, textSize), w = rowX + rowW - textX - 34, h = textSize * 1.3 },
                textSize,
                selected and style.selectedText or style.text
        ))

        table.insert(elements, textElement(
                tostring(index),
                { x = rowX + rowW - 30, y = centerY(rowY, style.rowHeight, 13), w = 20, h = 13 * 1.3 },
                13,
                selected and style.selectedText or style.hint,
                'right'
        ))
    end

    if options.hint ~= nil then
        table.insert(elements, textElement(
                options.hint,
                { x = m, y = m + panelHeight - style.footerHeight + 6, w = width, h = 18 },
                11,
                style.hint,
                'center'
        ))
    end

    return elements
end

-- options = { title, icon?, items = { { text, icon? } }, selectedIndex, hint?, width? }
local function show(options)
    local width = options.width or style.width
    local footerHeight = options.hint ~= nil and style.footerHeight or style.padding
    local panelHeight = style.headerHeight + #options.items * style.rowHeight + footerHeight
    local canvasW = width + style.margin * 2
    local canvasH = panelHeight + style.margin * 2
    local screenFrame = getAlertScreen():frame()

    hide()
    panel = hs.canvas.new({
        x = screenFrame.x + (screenFrame.w - canvasW) / 2,
        y = screenFrame.y + (screenFrame.h - canvasH) / 2,
        w = canvasW,
        h = canvasH,
    })
    panel:level(hs.canvas.windowLevels.overlay)
    panel:behavior({ 'canJoinAllSpaces', 'transient' })
    panel:appendElements(getElements(options, width, panelHeight))
    panel:show()
end

return {
    show = show,
    hide = hide,
}
