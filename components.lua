-- components.lua -- Position, Movement, Renderer
local Components = {}

Components.Position = {}
Components.Position.__index = Components.Position
function Components.Position:new(x, y)
    return setmetatable({x = x or 0, y = y or 0}, self)
end

Components.Movement = {}
Components.Movement.__index = Components.Movement
function Components.Movement:new(dx, dy)
    return setmetatable({dx = dx or 0, dy = dy or 0}, self)
end

Components.Renderer = {}
Components.Renderer.__index = Components.Renderer
function Components.Renderer:new(color, size)
    return setmetatable({color = color or {1, 1, 1}, size = size or 1}, self)
end

return Components
