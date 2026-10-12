local LibLayout = _G.LibLayout

---@class LibLayoutAnchor
---@field point string
---@field relativeFrame Region
---@field relativePoint string
---@field x number
---@field y number

---@class LibLayoutConstraint
---@field owner LibLayoutConstraints
---@field anchors LibLayoutAnchor[]
local Constraint = {}

Constraint.__index = Constraint

---@param value number
---@return LibLayoutConstraint
function Constraint:Offset(value)
    for _, anchor in ipairs(self.anchors) do
        if anchor.point == "TOP" or anchor.point == "BOTTOM" then
            anchor.y = value
        elseif anchor.point == "CENTER" then
            anchor.x = value
            anchor.y = value
        else
            anchor.x = value
        end
    end

    return self
end

---@param value number
---@return LibLayoutConstraint
function Constraint:Inset(value)
    for _, anchor in ipairs(self.anchors) do
        if anchor.point == "TOP" then
            anchor.y = -value
        elseif anchor.point == "BOTTOM" then
            anchor.y = value
        elseif anchor.point == "LEFT" then
            anchor.x = value
        elseif anchor.point == "RIGHT" then
            anchor.x = -value
        elseif anchor.point == "TOPLEFT" then
            anchor.x = value
            anchor.y = -value
        elseif anchor.point == "BOTTOMRIGHT" then
            anchor.x = -value
            anchor.y = value
        end
    end

    return self
end

---@class LibLayoutConstraints
---@field frame Region
---@field anchors LibLayoutAnchor[]
---@field width number?
---@field height number?
local Constraints = {}

Constraints.__index = Constraints

---@param frame Region
---@return LibLayoutConstraints
function LibLayout:CreateConstraints(frame)
    return setmetatable({
        frame = frame,
        anchors = {},
        width = nil,
        height = nil,
    }, Constraints)
end

---@param point string
---@param relativeFrame Region
---@param relativePoint string
---@return LibLayoutConstraint
function Constraints:CreateConstraint(point, relativeFrame, relativePoint)
    local anchor = {
        point = point,
        relativeFrame = relativeFrame,
        relativePoint = relativePoint,
        x = 0,
        y = 0,
    }

    table.insert(self.anchors, anchor)

    return setmetatable({
        owner = self,
        anchors = { anchor },
    }, Constraint)
end

---@param relativeFrame Region
---@return LibLayoutConstraint
function Constraints:Top(relativeFrame)
    return self:CreateConstraint("TOP", relativeFrame, "TOP")
end

---@param relativeFrame Region
---@return LibLayoutConstraint
function Constraints:Bottom(relativeFrame)
    return self:CreateConstraint("BOTTOM", relativeFrame, "BOTTOM")
end

---@param relativeFrame Region
---@return LibLayoutConstraint
function Constraints:Leading(relativeFrame)
    return self:CreateConstraint("LEFT", relativeFrame, "LEFT")
end

---@param relativeFrame Region
---@return LibLayoutConstraint
function Constraints:Trailing(relativeFrame)
    return self:CreateConstraint("RIGHT", relativeFrame, "RIGHT")
end

---@param relativeFrame Region
---@return LibLayoutConstraint
function Constraints:Center(relativeFrame)
    return self:CreateConstraint("CENTER", relativeFrame, "CENTER")
end

---@param relativeFrame Region
---@return LibLayoutConstraint
function Constraints:After(relativeFrame)
    return self:CreateConstraint("LEFT", relativeFrame, "RIGHT")
end

---@param relativeFrame Region
---@return LibLayoutConstraint
function Constraints:Below(relativeFrame)
    return self:CreateConstraint("TOP", relativeFrame, "BOTTOM")
end

---@param relativeFrame Region
---@return LibLayoutConstraint
function Constraints:Edges(relativeFrame)
    local topLeft = {
        point = "TOPLEFT",
        relativeFrame = relativeFrame,
        relativePoint = "TOPLEFT",
        x = 0,
        y = 0,
    }

    local bottomRight = {
        point = "BOTTOMRIGHT",
        relativeFrame = relativeFrame,
        relativePoint = "BOTTOMRIGHT",
        x = 0,
        y = 0,
    }

    table.insert(self.anchors, topLeft)
    table.insert(self.anchors, bottomRight)

    return setmetatable({
        owner = self,
        anchors = {
            topLeft,
            bottomRight,
        },
    }, Constraint)
end

---@param width number
---@return LibLayoutConstraints
function Constraints:Width(width)
    self.width = width
    return self
end

---@param height number
---@return LibLayoutConstraints
function Constraints:Height(height)
    self.height = height
    return self
end

---@param width number
---@param height number
---@return LibLayoutConstraints
function Constraints:Size(width, height)
    self.width = width
    self.height = height

    return self
end

---@return nil
function Constraints:Apply()
    local frame = self.frame

    for _, anchor in ipairs(self.anchors) do
        frame:SetPoint(
            anchor.point,
            anchor.relativeFrame,
            anchor.relativePoint,
            anchor.x,
            anchor.y
        )
    end

    if self.width then
        frame:SetWidth(self.width)
    end

    if self.height then
        frame:SetHeight(self.height)
    end
end