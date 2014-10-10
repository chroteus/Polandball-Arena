FighterAI = Fighter:subclass("FighterAI")

function FighterAI:initialize(arg)
    self.enemies = {}
    self.ai_enabled = true
    self.attack_zone = arg.attack_zone or 60
    
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


function FighterAI:attack(fighter, arg)
    self.attacked_enemy = fighter
    
	self:moveTo(fighter,
    {finishFunc = function()
                    fighter:getDamage(self.attack_stat)
                    if arg and arg.finishFunc then
                      arg.finishFunc()
                    end
                        
                    self.attacked_enemy = nil
                  end
    }
	)
end

function FighterAI:_attackAnim()
    if not self.attack_anim_played then
        self.anim_state = "still_"..self.anim_state
        
        local enemy = self.attacked_enemy
        local angle = math.atan2(enemy.y - self.y, enemy.x - self.x)
        
        Timer.tween(0.2, self, {x = self.x + self.attack_zone*math.cos(angle)}, "out-quint")
        Timer.tween(0.2, self, {y = self.y + self.attack_zone*math.sin(angle)}, "out-quint")
        
        
        self.attack_anim_played = true
    end
end

function FighterAI:update(dt)
    Fighter.update(self, dt)
    
    if self.attacked_enemy then
        if math.dist(self.x,self.y, self.attacked_enemy.x,self.attacked_enemy.y) < self.attack_zone then
            self:_attackAnim()
        end
    end
end

function FighterAI:ai()
    table.sort(self.enemies, function(a,b) return a.hp < b.hp end)
    self:attack(self.enemies[1])
end
