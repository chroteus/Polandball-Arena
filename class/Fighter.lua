local anim8 = require "lib.anim8"

Fighter = Base:subclass("Fighter")

function Fighter:initialize(arg)
	self.attack_stat = arg.attack_stat or 10
	self.defense = arg.defense or 10
	self.hp = arg.hp or 10
	self.maxHP = self.hp or 10

	if not arg.frames then error("Frames for fighter not set") end
	
	if type(arg.frames) == "string" then
		self.frames = love.graphics.newImage(arg.frames)
	else
		self.frames = arg.frames
	end
	
	self.frames:setFilter("nearest", "nearest")
	local grid = anim8.newGrid(75,70, self.frames:getWidth()-30, self.frames:getHeight(),15,0,0)
	self.anim = {
		still_south = anim8.newAnimation(grid(1,1), 0.1),
		south = anim8.newAnimation(grid("1-3", 1),  0.1),
		
		still_east  = anim8.newAnimation(grid(4, 1),  0.1),
		east  = anim8.newAnimation(grid("4-6", 1),  0.1),
		
		still_west  = anim8.newAnimation(grid(4, 1),  0.1):flipH(),
		west  = anim8.newAnimation(grid("4-6", 1),  0.1):flipH(),
		
		still_north = anim8.newAnimation(grid(7,1), 0.1),
		north = anim8.newAnimation(grid("7-9", 1), 0.1),
	}
	
	self.timer = Timer.new()
	self.anim_state = "still_south"
	self.scale = arg.scale or 1
    self.speed = arg.speed or 200
    
    Base.initialize(self)
end	

function Fighter:setScale(scale)
	self.scale = scale
	
	return self
end

function Fighter:getDamage(attack_arg)
	local netAtt = attack_arg - self.defense
	if netAtt < 0 then netAtt = 0 end
	
	self.hp = self.hp - netAtt
end

function Fighter:moveTo(x,y, finishFunc)
	self.timer:clear()
	local duration = math.dist(self.x,self.y, x,y)/50/self.scale
	local xDiff = math.abs(self.x - x)
	local yDiff = math.abs(self.y - y)
	
	if xDiff > yDiff then
		if self.x > x then self.anim_state = "west"
		elseif self.x < x then self.anim_state = "east"
		end
	else
		if self.y > y then self.anim_state = "north"
		elseif self.y < y then self.anim_state = "south"
		end
	end
	
	self.timer:tween(duration, self, {x = x})
	self.timer:tween(duration, self, {y = y})
	self.timer:add(duration, 
					function()
						self.anim_state = "still_" .. self.anim_state
						if finishFunc then finishFunc() end
					end)
end

function Fighter:attack(fighter)
	local origX,origY = self.x, self.y
	self:moveTo(fighter.x, fighter.y,
		function()
		-- finish func
			soldier:getDamage(self.attack_stat)
			self:moveTo(origX,origY)
		end
	)
end

function Fighter:update(dt)
	self.timer:update(dt)
	self.anim[self.anim_state]:update(dt)
end

function Fighter:draw()
	if not self.x or not self.y then error("Position for fighter not set") end

    print(self.anim_state)
	self.anim[self.anim_state]:draw(self.frames, 
									self.x, self.y)

end
