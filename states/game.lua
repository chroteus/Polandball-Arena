-- Switch to game with Arena:start or else it'll crash.
game = {}

function game:init()
end

function game:enter()
    if not game.arena then error("Switch to game state with Arena:start") end
end

function game:update(dt)
    game.arena:update(dt)
end

function game:draw()
    game.arena:draw()
end

function game:keypressed(key)
    game.arena:keypressed(key)
end
