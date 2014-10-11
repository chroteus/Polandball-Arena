FighterAI = Fighter:subclass("FighterAI")

function FighterAI:initialize(arg)
    self.enemies = {}
    self.ai_enabled = true
    self.attack_zone = arg.attack_zone or 40
    
    Fighter.initialize(self, arg)
end

function FighterAI:addEnemy(fighter)
    table.insert(self.enemies, fighter)

    return self
end

function FighterAI:addEnemies(team)
    for _,enemy in pairs(team) do
        self:addEnemy(enemy)
    end
    
    return self
end

function FighterAI:inAttackZone()
    return math.dist(self.x,self.y, self.attacked_enemy.x,self.attacked_enemy.y) < self.attack_zone
end


function FighterAI:attack(fighter, arg)
    self.attacked_enemy = fighter
    
    local onAttack = function()
        fighter:getDamage(self.attack_stat)
        self.attacked_enemy = nil
    end
    
    if self:inAttackZone() then
        self:_attackAnim()
        onAttack()
    else
        self:moveTo(fighter, {finishFunc = onAttackEnd})
    end
end

function FighterAI:_onAttackEnd()
    self:ai()
end

function FighterAI:_attackAnim()
    if not self.attack_anim_played then
        self.anim_state = "still_"..self.anim_state
        
        local enemy = self.attacked_enemy
        local angle = math.atan2(enemy.y - self.y, enemy.x - self.x)
        
        Timer.tween(0.1, self, {x = self.x - (self.attack_zone-10)*math.cos(angle)}, "linear")
        Timer.tween(0.1, self, {y = self.y - (self.attack_zone-10)*math.sin(angle)}, "linear",
            function()
                Timer.tween(0.2, self, {x = self.x + (self.attack_zone+10)*math.cos(angle)}, "out-quint")
                Timer.tween(0.2, self, {y = self.y + (self.attack_zone+10)*math.sin(angle)}, "out-quint",
                    function()  self.attack_anim_played = false end)
               
                
                self.attacked_enemy:knockback(angle)
                self:_onArrival()
                self:_onAttackEnd()
            end
        )
        
        self.attack_anim_played = true
    end
end

function FighterAI:update(dt)
    Fighter.update(self, dt)
    
    if self.attacked_enemy ~= nil then
        if self:inAttackZone() then
            self:_attackAnim()
        end
    end
end

function FighterAI:ai()
    table.sort(self.enemies, function(a,b) return a.hp < b.hp end)
    self:attack(self.enemies[1])
end
