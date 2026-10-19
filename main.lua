local GameState = require("gamestate")
local Input = require("input")

local gameState = GameState:new()
local input = Input:new()

function love.load()
    love.window.setMode(600, 600)
    love.window.setTitle("Snake")

    input:bind("up", function()
        local game = gameState.states.playing.game
        if game then
            game:changeDirection(0, -1)
        end
    end)

    input:bind("down", function()
        local game = gameState.states.playing.game
        if game then
            game:changeDirection(0, 1)
        end
    end)

    input:bind("left", function()
        local game = gameState.states.playing.game
        if game then
            game:changeDirection(-1, 0)
        end
    end)

    input:bind("right", function()
        local game = gameState.states.playing.game
        if game then
            game:changeDirection(1, 0)
        end
    end)
end

function love.update(dt)
    gameState:update(dt)
end

function love.draw()
    gameState:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    input:handleKey(key)
    gameState:keypressed(key)
end