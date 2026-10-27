local Fp = require('libs.util.Fp')
local Str = require('libs.util.StringUtil')

-- hs.alert 은 텍스트만 그릴 수 있어 아이콘/하이라이트를 위해 hs.canvas 로 직접 그리는 목록 팝업.
-- TabAlert / AppAlert 가 공유한다. 두 팝업이 동시에 뜨지 않으므로 canvas 는 하나만 둔다.
local panel = nil

local font = {
    regular = '.AppleSystemUIFont',
    medium = '.AppleSystemUIFontMedium',
    semibold = '.AppleSystemUIFontDemi',
}

local style = {
    width = 400,
    -- 그림자가 잘리지 않도록 canvas 를 패널보다 이만큼 크게 잡는다.
    margin = 40,
    radius = 18,
    headerHeight = 68,
    headerIconSize = 36,
    listPadding = 8,
    rowHeight = 44,
    rowGap = 2,
    rowRadius = 10,
    iconSize = 26,
    badgeSize = 22,
    footerHeight = 38,

    backgroundTop = { red = 0.17, green = 0.17, blue = 0.19, alpha = 0.97 },
    backgroundBottom = { red = 0.11, green = 0.11, blue = 0.12, alpha = 0.97 },
    border = { white = 1, alpha = 0.10 },
    separator = { white = 1, alpha = 0.07 },
    footerBackground = { white = 0, alpha = 0.18 },
    accentTop = { red = 0.18, green = 0.56, blue = 1, alpha = 1 },
    accentBottom = { red = 0.02, green = 0.42, blue = 0.94, alpha = 1 },
    accentStroke = { white = 1, alpha = 0.16 },

    title = { white = 1, alpha = 0.95 },
    subtitle = { white = 1, alpha = 0.45 },
    text = { white = 1, alpha = 0.88 },
    subtext = { white = 1, alpha = 0.38 },
    selectedText = { white = 1, alpha = 1 },
    selectedSubtext = { white = 1, alpha = 0.75 },
    badge = { white = 1, alpha = 0.08 },
    selectedBadge = { white = 1, alpha = 0.22 },
    badgeText = { white = 1, alpha = 0.6 },
    keycap = { white = 1, alpha = 0.08 },
    keycapStroke = { white = 1, alpha = 0.14 },
    keycapText = { white = 1, alpha = 0.75 },
    hint = { white = 1, alpha = 0.42 },
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

-- 한 줄 텍스트를 (y, h) 영역의 세로 가운데에 둔 frame.
local function textFrame(x, y, w, h, size)
    local lineHeight = math.ceil(size * 1.25)
    return { x = x, y = y + (h - lineHeight) / 2, w = w, h = lineHeight }
end

local function text(value, frame, size, color, fontName, alignment)
    return {
        type = 'text',
        text = value,
        textFont = fontName or font.regular,
        textSize = size,
        textColor = color,
        textAlignment = alignment or 'left',
        textLineBreak = 'truncateTail',
        frame = frame,
    }
end

local function roundRect(frame, radius, fill, stroke)
    return {
        type = 'rectangle',
        action = stroke and 'strokeAndFill' or 'fill',
        fillColor = fill,
        strokeColor = stroke,
        strokeWidth = stroke and 1 or nil,
        roundedRectRadii = { xRadius = radius, yRadius = radius },
        frame = frame,
    }
end

local function image(img, frame)
    return { type = 'image', image = img, imageScaling = 'scaleProportionally', frame = frame }
end

local function getListHeight(count)
    return style.listPadding * 2 + count * style.rowHeight + math.max(count - 1, 0) * style.rowGap
end

local function getHeaderElements(options, width)
    local m = style.margin
    local x = m + 20
    local elements = {}

    if options.icon ~= nil then
        local size = style.headerIconSize
        table.insert(elements, image(options.icon, { x = x, y = m + (style.headerHeight - size) / 2, w = size, h = size }))
        x = x + size + 12
    end

    local textW = m + width - 20 - x
    if options.subtitle == nil then
        table.insert(elements, text(options.title, textFrame(x, m, textW, style.headerHeight, 15), 15, style.title, font.semibold))
    else
        table.insert(elements, text(options.title, { x = x, y = m + 15, w = textW, h = 20 }, 15, style.title, font.semibold))
        table.insert(elements, text(options.subtitle, { x = x, y = m + 36, w = textW, h = 17 }, 12, style.subtitle))
    end

    return elements
end

local function getRowElements(item, index, selected, rowX, rowY, rowW)
    local h = style.rowHeight
    local elements = {}

    if selected then
        local highlight = roundRect({ x = rowX, y = rowY, w = rowW, h = h }, style.rowRadius, nil, style.accentStroke)
        highlight.fillGradient = 'linear'
        highlight.fillGradientAngle = 90
        highlight.fillGradientColors = { style.accentTop, style.accentBottom }
        table.insert(elements, highlight)
    end

    local x = rowX + 12
    if item.icon ~= nil then
        local size = style.iconSize
        table.insert(elements, image(item.icon, { x = x, y = rowY + (h - size) / 2, w = size, h = size }))
        x = x + size + 12
    else
        local size = style.badgeSize
        local badgeY = rowY + (h - size) / 2
        table.insert(elements, roundRect({ x = x, y = badgeY, w = size, h = size }, 6, selected and style.selectedBadge or style.badge))
        table.insert(elements, text(
                tostring(index), textFrame(x, badgeY, size, size, 12), 12,
                selected and style.selectedText or style.badgeText, font.medium, 'center'
        ))
        x = x + size + 12
    end

    local right = rowX + rowW - 14
    if item.subtext ~= nil then
        local subW = 90
        table.insert(elements, text(
                item.subtext, textFrame(right - subW, rowY, subW, h, 12), 12,
                selected and style.selectedSubtext or style.subtext, font.regular, 'right'
        ))
        right = right - subW - 8
    end

    table.insert(elements, text(
            item.text, textFrame(x, rowY, right - x, h, 14), 14,
            selected and style.selectedText or style.text, selected and font.medium or font.regular
    ))

    return elements
end

-- 키캡/라벨 폭은 canvas 를 만들기 전에 잴 수 없으므로 글자 수로 어림한다(11pt 기준).
local function estimateWidth(value, perChar)
    return Str.utf8Len(value) * perChar
end

local function getFooterElements(hints, width, footerY)
    local m = style.margin
    local keyGap, hintGap, capH = 6, 18, 20

    local layout = Fp.map(function(hint)
        local capW = hint.key and math.max(capH, estimateWidth(hint.key, 8) + 12) or 0
        local labelW = estimateWidth(hint.label, 11) + 2
        return { hint = hint, capW = capW, labelW = labelW, w = capW + (hint.key and keyGap or 0) + labelW }
    end)(hints)

    local total = Fp.reduce(function(acc, l) return acc + l.w end, 0)(layout) + hintGap * (#layout - 1)
    local x = m + (width - total) / 2
    local elements = {}

    for _, l in ipairs(layout) do
        if l.hint.key ~= nil then
            local capY = footerY + (style.footerHeight - capH) / 2
            table.insert(elements, roundRect({ x = x, y = capY, w = l.capW, h = capH }, 5, style.keycap, style.keycapStroke))
            table.insert(elements, text(l.hint.key, textFrame(x, capY, l.capW, capH, 11), 11, style.keycapText, font.medium, 'center'))
            x = x + l.capW + keyGap
        end
        table.insert(elements, text(l.hint.label, textFrame(x, footerY, l.labelW, style.footerHeight, 11), 11, style.hint))
        x = x + l.labelW + hintGap
    end

    return elements
end

local function getElements(options, width, panelHeight)
    local m = style.margin
    local panelFrame = { x = m, y = m, w = width, h = panelHeight }
    local radii = { xRadius = style.radius, yRadius = style.radius }
    local listY = m + style.headerHeight
    local footerY = listY + getListHeight(#options.items)

    local elements = {
        {
            type = 'rectangle',
            action = 'fill',
            fillGradient = 'linear',
            fillGradientAngle = 90,
            fillGradientColors = { style.backgroundTop, style.backgroundBottom },
            roundedRectRadii = radii,
            frame = panelFrame,
            withShadow = true,
            shadow = { blurRadius = 40, color = { alpha = 0.55 }, offset = { h = -14, w = 0 } },
        },
        -- 아래 요소들(구분선/푸터 배경)이 둥근 모서리 밖으로 나가지 않게 자른다.
        { type = 'rectangle', action = 'clip', roundedRectRadii = radii, frame = panelFrame },
        { type = 'rectangle', action = 'fill', fillColor = style.separator, frame = { x = m, y = listY - 1, w = width, h = 1 } },
    }

    if options.hints ~= nil then
        table.insert(elements, { type = 'rectangle', action = 'fill', fillColor = style.footerBackground, frame = { x = m, y = footerY, w = width, h = style.footerHeight } })
        table.insert(elements, { type = 'rectangle', action = 'fill', fillColor = style.separator, frame = { x = m, y = footerY, w = width, h = 1 } })
    end
    table.insert(elements, { type = 'resetClip' })

    elements = Fp.pipe(elements, Fp.concat(getHeaderElements(options, width)))

    local rowX = m + style.listPadding
    local rowW = width - style.listPadding * 2
    for index, item in ipairs(options.items) do
        local rowY = listY + style.listPadding + (index - 1) * (style.rowHeight + style.rowGap)
        elements = Fp.pipe(elements, Fp.concat(getRowElements(item, index, index == options.selectedIndex, rowX, rowY, rowW)))
    end

    if options.hints ~= nil then
        elements = Fp.pipe(elements, Fp.concat(getFooterElements(options.hints, width, footerY)))
    end

    -- 패널 테두리는 마지막에 그려 하이라이트/푸터 위에 얹는다.
    table.insert(elements, {
        type = 'rectangle',
        action = 'stroke',
        strokeColor = style.border,
        strokeWidth = 1,
        roundedRectRadii = radii,
        frame = { x = m + 0.5, y = m + 0.5, w = width - 1, h = panelHeight - 1 },
    })

    return elements
end

-- options = {
--   title, subtitle?, icon?, width?, selectedIndex,
--   items = { { text, subtext?, icon? } },   -- icon 이 없으면 번호 배지를 그린다.
--   hints? = { { key?, label } },            -- 하단 키캡 안내
-- }
-- 연타할 때마다 다시 그리므로 canvas 는 재사용하고 요소만 교체한다.
local function show(options)
    local width = options.width or style.width
    local footerHeight = options.hints ~= nil and style.footerHeight or 0
    local panelHeight = style.headerHeight + getListHeight(#options.items) + footerHeight
    local canvasW = width + style.margin * 2
    local canvasH = panelHeight + style.margin * 2
    local screenFrame = getAlertScreen():frame()
    local frame = {
        x = screenFrame.x + (screenFrame.w - canvasW) / 2,
        y = screenFrame.y + (screenFrame.h - canvasH) / 2,
        w = canvasW,
        h = canvasH,
    }

    if panel == nil then
        panel = hs.canvas.new(frame)
        panel:level(hs.canvas.windowLevels.overlay)
        panel:behavior({ 'canJoinAllSpaces', 'transient' })
        panel:replaceElements(getElements(options, width, panelHeight))
        panel:show(0.08)
    else
        panel:frame(frame)
        panel:replaceElements(getElements(options, width, panelHeight))
    end

    return panel
end

return {
    show = show,
    hide = hide,
}
