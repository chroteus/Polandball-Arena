Player = Fighter:subclass("Player")

function Player:initialize(arg)
    Fighter.initialize(self, arg)
end

function Player:update(dt)
    Fighter.update(self, dt)
    
    local key = love.keyboard.isDown
    if key("d") or key("right") then
        self.x = self.x + (self.speed*dt)
        self.anim_state = "east"
    elseif key("a") or key("left") then
        self.x = self.x - (self.speed*dt)
        self.anim_state = "west"
    end
    
    if key("s") or key("down") then
        self.y = self.y + (self.speed*dt)
        self.anim_state = "south"
    elseif key("w") or key("up") then
        self.y = self.y - (self.speed*dt)
        self.anim_state = "north"
    end
    
    if self.anim_state:find("still") == nil then
        if not (key("s") or key("down")) and not(key("w") or key("up"))
        and not (key("d") or key("right")) and not(key("a") or key("left")) then
            self.anim_state = "still_" .. self.anim_state
        end
    end
end
