-- Libraries
Timer = require "lib.hump.timer"
Camera = require "lib.amo"
Gamestate = require "lib.venus"
Class = require "lib.middleclass"
require "lib.gui" -- GUI lib.
require "lib.TEsound"

-- Classes
require "class.Base"
    require "class.Fighter"
        require "class.Player"

-- States
require "states.menu"

-- Misc
require "misc.dbox"

DEBUG = true

function love.load()
    the = {
        screen = {width = love.window.getWidth(), 
                  height = love.window.getHeight()}
    }
    the.mouse = {x = 0, y = 0, width = 1, height = 1}

    Gamestate.registerEvents()
    Gamestate.switch(menu)
end

function love.update(dt)
    the.mouse.x, the.mouse.y = love.mouse.getPosition()
end

function love.draw()
end
