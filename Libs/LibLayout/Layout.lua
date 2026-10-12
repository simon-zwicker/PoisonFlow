local LibLayout = _G.LibLayout

---@param frame Region
---@param callback fun(make: LibLayoutConstraints)
---@return nil
function LibLayout:Make(frame, callback)
    assert(frame, "LibLayout: Frame is required.")

    assert(
        type(callback) == "function",
        "LibLayout: Callback must be a function."
    )

    local constraints = self:CreateConstraints(frame)

    callback(constraints)

    constraints:Apply()
end

---@param frame Region
---@param callback fun(make: LibLayoutConstraints)
---@return nil
function LibLayout:Remake(frame, callback)
    assert(frame, "LibLayout: Frame is required.")

    assert(
        type(callback) == "function",
        "LibLayout: Callback must be a function."
    )

    -- Build first so callback errors do not destroy the existing layout.
    local constraints = self:CreateConstraints(frame)

    callback(constraints)

    frame:ClearAllPoints()

    constraints:Apply()
end