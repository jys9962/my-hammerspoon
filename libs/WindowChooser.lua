WindowSelector = {}
WindowSelector.__index = WindowSelector
function WindowSelector.new()
    local self = setmetatable({}, WindowSelector)
    self.chooser = nil
    return self
end

function WindowSelector:showList(windowList)
    local rows = {}
    for index, window in ipairs(windowList) do
        table.insert(rows, {
            window = window,
            text = '[' .. index .. '] ' .. window:title(),
            subText = window:title(),
            image = window:snapshot(),
        })
    end


    self.chooser = hs.chooser.new(function(choices)
        if choices then
            choices.window:focus()
        end
    end)
    self.chooser:choices(rows)
    self.chooser:show()
end

function WindowSelector:isShow()
    return self.chooser and self.chooser:isVisible()
end

function WindowSelector:select(row)
    self.chooser:select(tonumber(row))
end

return WindowSelector
