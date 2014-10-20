char_scr = {}

local char
function char_scr:init()
    char = GLOBALS.player -- shortcut
end

function char_scr:enter()
end

function char_scr:update(dt)

end

function char_scr:draw()
    local x = the.screen.width/5 - char.width/2
    local y = the.screen.height/3 - char.height/2 
    char:draw(x,y)
    
    
end
