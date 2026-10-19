local Events = require("events")
local Entity = require("entity")
local Components = require("components")

local SnakeGame = {}
SnakeGame.__index = SnakeGame

local GRID = 20
local CELL = 30
local STEP_TIME = 0.12

function SnakeGame:spawnFood()
    while true do
        local x = love.math.random(0, GRID - 1)
        local y = love.math.random(0, GRID - 1)

        local free = true

        for _, seg in ipairs(self.snake) do
            if seg.x == x and seg.y == y then
                free = false
                break
            end
        end

        if free then
            self.food = {x = x, y = y}
            return
        end
    end
end

function SnakeGame:new()

    local snakeEntity = Entity:new()

    snakeEntity:addComponent(
        "position",
        Components.Position:new(10, 10)
    )

    snakeEntity:addComponent(
        "movement",
        Components.Movement:new(1, 0)
    )

    snakeEntity:addComponent(
        "renderer",
        Components.Renderer:new(
            {0.3, 0.8, 0.4},
            CELL
        )
    )

    local game = {

        entity = snakeEntity,

        GRID = GRID,
        CELL = CELL,
        STEP_TIME = STEP_TIME,

        snake = {
            {x = 10, y = 10},
            {x = 9, y = 10},
            {x = 8, y = 10},
        },

        direction = {x = 1, y = 0},
        nextDirection = {x = 1, y = 0},

        food = {x = 15, y = 15},

        score = 0,
        timer = 0,
        gameOver = false,
        pendingGrowth = 0,
        paused = false,
        gameOverEmitted = false
    }

    setmetatable(game, SnakeGame)

    local pos = game.entity:getComponent("position")
    pos.x = game.snake[1].x
    pos.y = game.snake[1].y

    game:spawnFood()

    return game
end

function SnakeGame:changeDirection(dx, dy)

    if dx == -self.direction.x and dy == -self.direction.y then
        return
    end

    if dx ~= 0 and self.direction.x ~= 0 then
        return
    end

    if dy ~= 0 and self.direction.y ~= 0 then
        return
    end

    self.nextDirection = {x = dx, y = dy}
end

function SnakeGame:togglePause()
    self.paused = not self.paused
end

function SnakeGame:step()

    self.direction = self.nextDirection

    local head = self.snake[1]

    local newHead = {
        x = head.x + self.direction.x,
        y = head.y + self.direction.y
    }

    if newHead.x < 0 or newHead.x >= GRID
    or newHead.y < 0 or newHead.y >= GRID then
        self.gameOver = true
        return
    end

    local last = #self.snake

    for i, seg in ipairs(self.snake) do

        local isTail =
            (i == last) and self.pendingGrowth == 0

        if not isTail
        and seg.x == newHead.x
        and seg.y == newHead.y then

            self.gameOver = true
            return
        end
    end

    table.insert(self.snake, 1, newHead)

    local pos = self.entity:getComponent("position")
    pos.x = newHead.x
    pos.y = newHead.y

    local move = self.entity:getComponent("movement")
    move.dx = self.direction.x
    move.dy = self.direction.y

    if newHead.x == self.food.x
    and newHead.y == self.food.y then

        self.score = self.score + 1

        self.pendingGrowth =
            self.pendingGrowth + 1

        self:spawnFood()

        Events:emit(
            "food_eaten",
            {score = self.score}
        )

    else

        if self.pendingGrowth > 0 then

            self.pendingGrowth =
                self.pendingGrowth - 1

        else

            table.remove(self.snake)
        end
    end
end

function SnakeGame:update(dt)

    if self.paused then
        return
    end

    if self.gameOver then

        if not self.gameOverEmitted then

            self.gameOverEmitted = true

            Events:emit(
                "game_over",
                {score = self.score}
            )
        end

        return
    end

    self.timer = self.timer + dt

    while self.timer >= self.STEP_TIME do

        self.timer = self.timer - self.STEP_TIME

        self:step()

        if self.gameOver then
            break
        end
    end
end

function SnakeGame:draw()

    love.graphics.setBackgroundColor(
        0.1,
        0.1,
        0.12
    )

    love.graphics.setColor(
        1,
        0.3,
        0.3
    )

    love.graphics.rectangle(
        "fill",
        self.food.x * CELL,
        self.food.y * CELL,
        CELL - 2,
        CELL - 2
    )

    local renderer =
        self.entity:getComponent("renderer")

    for i, seg in ipairs(self.snake) do

        if i == 1 then

            love.graphics.setColor(
                0.5,
                1,
                0.6
            )

        else

            love.graphics.setColor(
                renderer.color[1],
                renderer.color[2],
                renderer.color[3]
            )
        end

        love.graphics.rectangle(
            "fill",
            seg.x * CELL,
            seg.y * CELL,
            CELL - 2,
            CELL - 2
        )
    end

    love.graphics.setColor(
        1,
        1,
        1
    )

    love.graphics.print(
        "Score: " .. self.score,
        10,
        10
    )

    if self.gameOver then

        love.graphics.setColor(
            0,
            0,
            0,
            0.7
        )

        love.graphics.rectangle(
            "fill",
            0,
            0,
            GRID * CELL,
            GRID * CELL
        )

        love.graphics.setColor(
            1,
            1,
            1
        )

        love.graphics.printf(
            "GAME OVER\nScore: "
            .. self.score ..
            "\nPress SPACE for menu",
            0,
            GRID * CELL / 2 - 40,
            GRID * CELL,
            "center"
        )
    end
        if self.paused then
        love.graphics.setColor(1, 1, 1)

        love.graphics.printf(
            "PAUSED",
            0,
            GRID * CELL / 2,
            GRID * CELL,
            "center"
        )
    end
end

return SnakeGame