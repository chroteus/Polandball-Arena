-- GLOBALS: Store every truly global data here to prevent name conflicts.
GLOBALS = {}

-- Libraries
Timer = require "lib.hump.timer"
Camera = require "lib.amo"
Gamestate = require "lib.venus"
Class = require "lib.middleclass"
anim8 = require "lib.anim8"

require "lib.gui"
require "lib.math"
require "lib.TEsound"

-- Classes
require "class.Base"
    require "class.Fighter"
        require "class.Player"
        require "class.FighterAI"
        
require "class.Arena"
require "class.Item"

-- Objects
require "objects.fighters"
require "objects.items"

-- States
require "states.game"
require "states.menu"
require "states.select_scr"
require "states.char_scr"
require "states.enemy_scr"

-- Misc
require "misc.dbox"

DEBUG = true

function love.load()
    the = {
        screen = {width = love.window.getWidth(), 
                  height = love.window.getHeight()}
    }
    the.mouse = {x = 0, y = 0, width = 1, height = 1}

    -- Font handling
    FONT = {}
    local fontHandle = {
        __index = function(t, k)
            FONT[k] =  love.graphics.newFont("assets/Sansation_Regular.ttf", k)
            return FONT[k]
        end
    }
    setmetatable(FONT, fontHandle)
    FONT["default"] = FONT[16]
    
    love.graphics.setFont(FONT["default"])

    Gamestate.registerEvents()
    Gamestate.switch(menu)
end

function love.update(dt)
    Timer.update(dt)
    the.mouse.x, the.mouse.y = love.mouse.getPosition()
    DialogBoxes:update(dt)
end

function love.draw()
end

function love.mousereleased(x,y,button)
     DialogBoxes:mousereleased(x,y,button)
end

function table.count(t)
    -- for tables with key-values
    local count = 0
    for k,v in pairs(t) do count = count + 1 end
    
    return count
end
    
