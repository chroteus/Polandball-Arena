-- Switch to game with Arena:start or else it'll crash.
-- OR call game.defaultArena()
game = {}

function game:init()
end

function game:enter()
    if not game.arena then error("Switch to game state with Arena:start") end
    game.arena:attachToState(game)
end
