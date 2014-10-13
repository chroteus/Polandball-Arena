FighterAI = Fighter:subclass("FighterAI")

function FighterAI:initialize(arg)
    Fighter.initialize(self, arg)
end

function FighterAI:attack(fighter)
    self.enemy_to_attack = fighter

    if not self:inAttackZone() then
        self:moveTo(fighter, {finishFunc = function() self:attack(self.enemy_to_attack) end})
    else
        self:_attackAnim()
        fighter:getDamage(self.attack_stat)
        self.enemy_to_attack = nil
    end
end

function FighterAI:_onAttackEnd()
    self:ai()
end

function FighterAI:update(dt)
    Fighter.update(self, dt)
    
    if self.enemy_to_attack ~= nil then
        if self:inAttackZone() then
            self:_attackAnim()
        end
    end
end

function FighterAI:ai()
    print("ke")
    table.sort(self.enemies, function(a,b) return a.hp < b.hp end)
    self:attack(self.enemies[1])
end
