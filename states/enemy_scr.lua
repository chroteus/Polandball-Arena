local randomEnemy = require "misc.generateFighter"
local defaultArena = require "misc.defaultArena"

enemy_scr = {}

function enemy_scr:init()
    enemy_scr.btn = GUI.Container(1, "dynamic")
    :setElementSize(200,60)
    
    for i=1,5 do
        local difficulty = math.ceil(i/2)
        local enemy = randomEnemy(difficulty):setPos(600, 250)
        GLOBALS.player:setPos(80, 250)
        
        local start = function()
                          local arena = defaultArena({GLOBALS.player},{enemy})
                          arena:start()
                      end
        
        enemy_scr.btn:add(GUI.FighterBtn(enemy):setFunc(start))
    end
    
    enemy_scr.btn:center()
    enemy_scr.btn:attachToState(enemy_scr)
end

function enemy_scr:draw()
    love.graphics.printf("Choose your enemy", 0, 50, 
                         the.screen.width, "center")
end
