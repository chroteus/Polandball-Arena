menu = {}

function menu:init()
    menu.btn = GUI.Container(1,"dynamic")
    :setElementSize(150,50)
    
    menu.btn:add{
        GUI.Button("Start")
        :setFunc(function() Gamestate.switch(select_scr) end),
        
        GUI.Button("Quit"):setFunc(love.event.quit)
    }
    
    menu.btn:center()
    menu.btn:attachToState(menu)
    
    love.graphics.setBackgroundColor(20,20,20)
end
