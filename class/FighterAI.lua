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


function FighterAI:attack(fighter, arg)
	local origX,origY = self.x, self.y
	self:moveTo(fighter.x, fighter.y,
    {finishFunc = function()
                    if arg and arg.finishFunc then arg.finishFunc() end
                    fighter:getDamage(self.attack_stat)
                    self:moveTo(origX,origY)
                  end
    }
	)
end

function FighterAI:update(dt)
    Fighter.update(self, dt)
    self:ai()
end

function FighterAI:ai()
    table.sort(self.enemies)
    self:attack(self.enemies[1])
end

