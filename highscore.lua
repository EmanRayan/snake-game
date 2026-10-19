-- highscore.lua -- Save/load high score
-- Note: LÖVE 11.5 runs LuaJIT (Lua 5.1), so the Lua 5.4 <close> attribute
-- is not available here. We close the file explicitly instead.
-- Assignment note:
-- The task requests Lua 5.4 to-be-closed variables:
--
--     local file <close> = io.open(...)
--
-- LOVE 11.x runs LuaJIT (Lua 5.1), which does not support
-- the <close> attribute, so files are closed explicitly
-- with file:close().

local HighScore = {}

local FILE = "highscore.txt"

function HighScore:save(score)
    local file = io.open(FILE, "w")
    if file then
        file:write(tostring(score))
        file:close()
    end
end

function HighScore:load()
    local file = io.open(FILE, "r")
    if file then
        local content = file:read("*a")
        file:close()
        return tonumber(content) or 0
    end
    return 0
end

return HighScore
