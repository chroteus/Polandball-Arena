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

    -- For testing purposes. REMOVE AFTER TESTING.
    menu.player = Player{name = "Poland"}
    :setPos(300,300)
    
    menu.enemy = FighterAI{name = "Poland"}
    :setPos(600, 300)
    
    menu.arena = Arena{x=0, y=0, width=800, height=800}
    menu.arena:add(menu.player):to("allies")
    menu.arena:add(menu.enemy):to("enemies")
    menu.arena:start()
    
    love.graphics.setBackgroundColor(50,50,50)
end

function menu:update(dt)
    menu.arena:update(dt)
end

function menu:draw()
    menu.arena:draw()
end

function menu:keypressed(key)
    menu.arena:keypressed(key)
end

