select_scr = {}

function select_scr:init()
    select_scr.btn = GUI.Container(3, "dynamic")
    :setElementSize(180,50)
    :setPadding(50)
    
    for k,fighter in pairs(GLOBALS.fighters) do
        select_scr.btn:add(
            GUI.FighterBtn(fighter)
            :setFunc(function() 
                        GLOBALS.player = Player(fighter)
                        Gamestate.switch(enemy_scr)
                    end)
        )
    end
    
    select_scr.btn:center()
    select_scr.btn:attachToState(select_scr)
end
