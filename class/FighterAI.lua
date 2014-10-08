FighterAI = Fighter:subclass("FighterAI")

function FighterAI:initialize(arg)
    self.enemies = {}
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

function FighterAI:ai()
    table.sort(self.enemies)
    self:attack(self.enemies[1], {finishFunc = function() self:ai() end})
end

