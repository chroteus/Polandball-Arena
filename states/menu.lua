menu = {}

function menu:init()
    menu.btn = GUI.Container(1,"dynamic"):setElementSize(150,50)
    
    menu.btn:add{
        GUI.Button("Start"),
        GUI.Button("Quit"):setFunc(love.event.quit)
    }
    
    menu.btn:setState(menu)
end

