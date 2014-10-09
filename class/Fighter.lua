local anim8 = require "lib.anim8"

Fighter = Base:subclass("Fighter")

function Fighter:initialize(arg)
    self.name = arg.name or "Undefined name"

    -- "attack_stat" is not "attack" to prevent conflict 
    -- with method named "attack"
	self.attack_stat = arg.attack_stat or 10
	self.defense = arg.defense or 10
	self.hp = arg.hp or 100

    local frames
	if not arg.frames and self.name then 
        frames = "assets/images/balls/" .. self.name .. ".png"
    elseif not arg.frames and not self.name then
        error("Neither name nor frames file defined")
    else
        frames = arg.frames
    end
        
	if type(frames) == "string" then
		self.frames = love.graphics.newImage(frames)
	else
		self.frames = frames
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
    self.speed = arg.speed or 150
    
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

function Fighter:moveTo(x,y, arg)
    self.goal_x = x
    self.goal_y = y
    if arg then self.funcOnArrival = arg.finishFunc end
    
    return self
end

-- Internal function, thus prefixed with an underscore.
function Fighter:_move(dt)
	local xDiff = math.abs(self.x - self.goal_x)
	local yDiff = math.abs(self.y - self.goal_y)
	
	if xDiff > yDiff then
		if self.x > self.goal_x then self.anim_state = "west"
		elseif self.x < self.goal_x then self.anim_state = "east"
		end
	else
		if self.y > self.goal_y then self.anim_state = "north"
		elseif self.y < self.goal_y then self.anim_state = "south"
		end
	end

    local angle = math.atan2(self.goal_y - self.y, self.goal_x - self.x)
    self.x = self.x + (self.speed * math.cos(angle)) * dt
    self.y = self.y + (self.speed * math.sin(angle)) * dt
    
    if  (self.goal_x-2 <= self.x and self.x <= self.goal_x+2) 
    and (self.goal_y-2 <= self.y and self.y <= self.goal_y+2)  then
        self.goal_x = nil
        self.goal_y = nil
        
        self.funcOnArrival()
        self.anim_state = "still_" .. self.anim_state
    end
end

function Fighter:update(dt)
    if self.goal_x and self.goal_y then self:_move(dt) end
	self.anim[self.anim_state]:update(dt)
end

function Fighter:draw(x,y)
    local x = x or self.x
    local y = y or self.y

	if not x or not y then error("Position for fighter not set") end
	self.anim[self.anim_state]:draw(self.frames, x,y)
end
