---@class LibLayout
---@field VERSION string
---@field Make fun(self: LibLayout, frame: Region, callback: fun(make: LibLayoutConstraints))
---@field Remake fun(self: LibLayout, frame: Region, callback: fun(make: LibLayoutConstraints))
---@field CreateConstraints fun(self: LibLayout, frame: Region): LibLayoutConstraints

local LibLayout = {
    VERSION = "0.2.0",
}

_G.LibLayout = LibLayout