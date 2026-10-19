local SnakeGame = require("snake_game")
local HighScore = require("highscore")

local GameState = {}

function GameState:enter()
    self.game = SnakeGame:new()
    self.best = HighScore:load()
end

function GameState:update(dt)

    if not self.game then
        return
    end

    self.game:update(dt)

    if self.game.gameOver and self.game.score > self.best then
        self.best = self.game.score
        HighScore:save(self.best)
    end
end

function GameState:draw()

    if not self.game then
        return
    end

    self.game:draw()

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Best: " .. self.best, 10, 30)
end

function GameState:keypressed(key)

    if not self.game then
        return
    end

    -- Pause / Resume
    if key == "p" then
        self.game:togglePause()
        return
    end

    if self.game.gameOver then
        if key == "return" or key == "space" then
            self.nextState = "menu"
        end
        return
    end

    if key == "up" or key == "w" then
        self.game:changeDirection(0, -1)

    elseif key == "down" or key == "s" then
        self.game:changeDirection(0, 1)

    elseif key == "left" or key == "a" then
        self.game:changeDirection(-1, 0)

    elseif key == "right" or key == "d" then
        self.game:changeDirection(1, 0)
    end
end

return GameState