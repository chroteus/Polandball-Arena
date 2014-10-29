Player = Fighter:subclass("Player")

function Player:initialize(arg)
    Fighter.initialize(self, arg)
end

function Player:attack()
    local dist = function(a,b) return math.dist(a.x,a.y, b.x,b.y) end
    
    self.enemy_to_attack = self.enemies[1]
    table.sort(self.enemies, function(a,b) return dist(self, self.enemy_to_attack) end)
    
    if self:inAttackZone() then
        self:lookAt(self.enemy_to_attack.x, self.enemy_to_attack.y)
        self:_attackAnim()
    end
    
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
    
    if self.anim_state:find("still") == nil and not self.attack_anim_played then
        if not (key("s") or key("down")) and not(key("w") or key("up"))
        and not (key("d") or key("right")) and not(key("a") or key("left")) then
            self.anim_state = "still_" .. self.anim_state
        end
    end
end

function Player:keypressed(key)
    if key == " " then
        self:attack()
    end
end
