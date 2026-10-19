-- gamestate.lua -- State manager (Menu / Playing)
local GameState = {}
GameState.__index = GameState

function GameState:new()
    local state = {
        current = "menu",
        states = {
            menu    = require("states.menu_state"),
            playing = require("states.game_state")
        }
    }
    return setmetatable(state, GameState)
end

function GameState:switch(newState)
    if not self.states[newState] then
        print("Unknown state: " .. tostring(newState))
        return
    end
    if self.current == newState then return end
    self.current = newState
    if self.states[newState].enter then
        self.states[newState]:enter()
    end
end

function GameState:update(dt)
    local s = self.states[self.current]
    if s and s.update then s:update(dt) end
end

function GameState:draw()
    local s = self.states[self.current]
    if s and s.draw then s:draw() end
end

function GameState:keypressed(key)
    local s = self.states[self.current]
    if s and s.keypressed then s:keypressed(key) end
    -- global: any state can request a switch through its own flag
    if s and s.nextState then
        local next = s.nextState
        s.nextState = nil
        self:switch(next)
    end
end

return GameState
