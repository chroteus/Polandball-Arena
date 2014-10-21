local randomEnemy = require "misc.generateFighter"
enemy_scr = {}

function enemy_scr:init()
    enemy_scr.btn = GUI.Container(1, "dynamic")
    :setElementSize(200,60)
    
    for i=1,5 do
        local difficulty = math.ceil(i/2)
        enemy_scr.btn:add(GUI.FighterBtn(randomEnemy(difficulty)))
    end
    
    enemy_scr.btn:center()
    enemy_scr.btn:attachToState(enemy_scr)
end

function enemy_scr:enter()
end
