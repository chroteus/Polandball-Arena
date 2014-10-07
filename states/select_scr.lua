select_scr = {}

function select_scr:init()
    select_scr.btn = GUI.Container(3, "dynamic")
    :setElementSize(200,50)
    
    local FighterBtn = GUI.Button:subclass("FighterBtn")
    
    function FighterBtn:initialize(fighter)
        self.fighter = fighter
        GUI.Button.initialize(self, fighter.name)
    end
    
    function FighterBtn:update(dt)
        GUI.Button.update(self, dt)
        self.fighter.update(self.fighter, dt)
        
        if self.state == "active" then
            self.fighter.anim_state = "south"
        else
            self.fighter.anim_state = "still_south"
        end
    end
    
    function FighterBtn:draw()
        GUI.Button.draw(self)
        self.fighter.draw(self.fighter, self.x, self.y)
    end
        
    
    for k,fighter in pairs(GLOBALS.fighters) do
        select_scr.btn:add(
            FighterBtn(fighter)
            :setFunc(function() select_scr.selected_fighter = fighter end)
        )
    end
    
    select_scr.btn:center()
    select_scr.btn:attachToState(select_scr)
end
