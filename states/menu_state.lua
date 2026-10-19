-- states/menu_state.lua
local HighScore = require("highscore")

local MenuState = {}

function MenuState:update(dt) end

function MenuState:draw()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.12)
    love.graphics.setColor(0.5, 1, 0.6)
    love.graphics.printf("SNAKE", 0, 180, 600, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Press ENTER to play", 0, 260, 600, "center")
    love.graphics.printf("High score: " .. HighScore:load(), 0, 300, 600, "center")
end

function MenuState:keypressed(key)
    if key == "return" or key == "space" then
        self.nextState = "playing"
    end
end

return MenuState
