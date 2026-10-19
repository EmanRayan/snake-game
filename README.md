Lua Snake Game

Snake game built with LÖVE 11.x using modern Lua programming concepts and design patterns.

RUN

love .

On Windows, if love is not on PATH:

& "C:\Program Files\LOVE\love.exe" .

CONTROLS

Enter / Space: Start game
Arrow Keys / WASD: Move snake
P: Pause / Resume game
Space / Enter: Return to menu after game over
Escape: Quit game

FILES

main.lua : Entry point
gamestate.lua : State manager (Menu / Playing)
entity.lua : Entity Component System
components.lua : Position, Movement, Renderer components
vector2.lua : Vector math with metamethods
highscore.lua : Save / Load high score
input.lua : Command Pattern input handler
events.lua : Observer Pattern (Bonus)
snake_game.lua : Snake movement, food, score, collisions and pause system
states/menu_state.lua : Menu state
states/game_state.lua : Playing state

MODERN LUA FEATURE

vector2.lua uses metamethods:

__add
__eq
__tostring
__len

These allow vectors to behave like built-in Lua values.

IMPLEMENTED FEATURES

Menu and Playing game states
Entity Component System (ECS)
Command Pattern for input handling
High score save/load system
Vector2 class with metamethods
Event System (Observer Pattern)
Snake movement and growth
Random food spawning
Wall collision detection
Self collision detection
Game over screen
Pause / Resume functionality using the P key

HIGH SCORE SYSTEM

The high score is stored in highscore.txt using io.open() and is loaded when the game starts.

NOTE

The assignment requests Lua 5.4 to-be-closed variables:

local file = io.open(...)

However, LÖVE 11.x uses LuaJIT (Lua 5.1), which does not support the attribute.

For compatibility with LÖVE, file handles are closed explicitly using:

file:close()