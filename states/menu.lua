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
    
    love.graphics.setBackgroundColor(130,120,255)
    
    -- TEST
    
    menu.player = Fighter{name = "Poland"}
    :setPos(320, 500)
    
    menu.player:equip(GLOBALS.items.iron_sword)
end

function menu:update(dt)
    menu.player:moveTo(the.mouse.x, the.mouse.y)
    menu.player:update(dt)
end

function menu:draw()
    menu.player:draw()
end
