Army = class "Army"

function Army:initialize(arg)
	self.soldiers = {}
end

function Army:setPos(x,y)
	self.x = x
	self.y = y
	
	return self
end

function Army:addSoldier(soldier, padding)
	local padding = padding or 20
	local lastSoldier = self.soldiers[#self.soldiers] or {x = self.x, y = self.y}
	soldier:setPos(lastSoldier.x + padding + math.random(-2,2), 
				   lastSoldier.y + padding + math.random(-2,2))
	table.insert(self.soldiers, soldier)
    
    return self
end

function Army:populateWith(num, soldier)
	for i=1,num do
		self:addSoldier(Soldier(soldier))
	end
    
    return self
end

function Army:update(dt)
	for _,soldier in pairs(self.soldiers) do
		soldier:update(dt)
	end
end

function Army:draw()
	for _,soldier in pairs(self.soldiers) do
		soldier:draw()
	end
end

function Army:attack(army)
	for num,enemy in pairs(army.soldiers) do
		if self.soldiers[num] ~= nil then
			self.soldiers[num]:attack(enemy)
		else
			local rand = self.soldiers[math.random(#self.soldiers)]
			rand:attack(enemy)
		end
	end
end
			
function Army:moveTo(x,y)
	local padding = padding or 20
	for num,soldier in pairs(self.soldiers) do
		self.x, self.y = x,y
		soldier:moveTo(self.x + (num-1)*padding/2 + math.random(1,2), 
					   self.y + (num-1)*padding   + math.random(1,2))
	end
end
