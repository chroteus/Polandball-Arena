menu = {}

function menu:init()
    menu.btn = GUI.Container(1,"dynamic")
    :setElementSize(150,50)
    
    menu.btn:add{
        GUI.Button("Start"),
        GUI.Button("Quit"):setFunc(love.event.quit)
    }
    
    menu.btn:center()
    menu.btn:setState(menu)

    menu.player = Player{frames = "assets/images/balls/Poland.png"}
    :setPos(300,300)
end

function menu:update(dt)
    menu.player:update(dt)
end

function menu:draw()
    menu.player:draw()
end
