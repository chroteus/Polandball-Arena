require "class.Base"

GUI = {}

GUI.colours = {
	idle = {
		bg = {255,255,255,20 },
		fg = {200,200,200,255},
	},
	
	active = {
		bg = {255,255,255,60},
		fg = {200,200,200,255},
	},
}

GUI.SKIN = "assets/images/guiskin"

GUI.Element = Base:subclass("GUIElement")

function GUI.Element:initialize()
	self.state = "idle"	

	Base.initialize(self)
end

function GUI.Element:setState(state)
	if GUI.colours[state] == nil then
		error("State " .. state .. " does not exist.")
	end
	
	self.state = state
	
	return self
end

------------------------------------------------------------------------

GUI.Button = GUI.Element:subclass("GUIButton")

function GUI.Button:initialize(text)
	assert(type(text) == "string", "A string should be supplied to constructor of GUI.Button")
	self:setText(text)

	GUI.Element.initialize(self)
end

function GUI.Button:setFont(font)
    self.font = font
    
    return self
end

function GUI.Button:setFontSize(size)
    self.font_size = size

    return self
end

function GUI.Button:setText(text)
	if self.dyn_text then
		error("A dynamic text is already set. Static text cannot be set")
	end
	
	assert(type(text) == "string", "A string should be supplied to GUI.Button:setText")
	self.text = text
	
	return self
end

function GUI.Button:setDynamicText(table, item)
	if self.text then 
		error("A static text is already set. Dynamic text cannot be set")
	end
	
	self.dyn_text = {
		table = table,
		item = item
	}
	
	self.text = table[item]
	
	return self
end


function GUI.Button:update(dt)
	if self:collidesWith(the.mouse) then self:setState("active")
    else self:setState("idle")
	end
    
    if self.dyn_text then
		self.text = self.dyn_text.table[self.dyn_text.item]
	end
end

function GUI.Button:setFunc(func)
	self.func = assert(func)
	
	return self
end

function GUI.Button:mousepressed(x,y,button)

end

function GUI.Button:mousereleased(x,y,button)
	if self:collidesWith(the.mouse) then
		if self.func then self.func() end
	end
end

function GUI.Button:draw()
	love.graphics.setColor(GUI.colours[self.state].bg)
	love.graphics.rectangle("fill", self:getBBox())

	love.graphics.setColor(GUI.colours[self.state].fg)
    --love.graphics.rectangle("line", self:getBBox())
	
    love.graphics.printf(
		self.text, 
		self.x, self.y + self.height/2 - love.graphics.getFont():getHeight()/2,
		self.width, "center"
	)

	love.graphics.setColor(255,255,255)
end

------------------------------------------------------------------------

GUI.Container = Base:subclass("GUIContainer")

function GUI.Container:initialize(width, height)
	local width  = width  or 1
	local height = height or 1
	
	
	if width  == "dynamic" then 
		self.dynamic_width  = true 
		width  = 1
	end
	
	if height == "dynamic" then 
		self.dynamic_height = true 
		height = 1
	end
	
	self.grid = {}
	
	for i=1,height do 
		table.insert(self.grid, {})
	end
	
	self.grid_width = width
	self.grid_height = height
	
	Base.initialize(self)
	
	-- default values
	self.x, self.y = 0,0
	self.padding = 5
end

function GUI.Container:setPadding(padding)
	self.padding = padding
	
	return self
end

function GUI.Container:setPos(x,y)
	self.x, self.y = x,y
	self:autoElementPos()

	return self
end

function GUI.Container:attachToState(state)
    local callbacks = {"update", "draw", "mousepressed", "mousereleased"}
    for _,callback in pairs(callbacks) do
        if state[callback] == nil then
            state[callback] = function(state, ...) end
        end
        
        local orig = state[callback]
        
        state[callback] = function(state_self, ...)
            orig(state_self, ...)
            self[callback](self, ...)
        end
    end
end
        
        
function GUI.Container:center(axis)
	self:autoSize()

	self:setPos(
		the.screen.width/2  - self.width/2,
		the.screen.height/2 - self.height/2 
	)
	
	return self
end

function GUI.Container:setElementSize(width,height)
	self.element_size = {}
	
	self.element_size.width  = width
	self.element_size.height = height
	
	return self
end

------------------------------------------------------------------------

function GUI.Container:add(element)
	if element.isInstanceOf then -- checking if the element is an instance
		local column
		local column_num
		
		for i=1,#self.grid do
			if #self.grid[i] < self.grid_width or self.dynamic_width then
			
				element:setSize(self.element_size.width,
								self.element_size.height)
				
				if element:isInstanceOf(GUI.Container) then
					element:autoSize()
					element:autoElementPos()
				end
				
				table.insert(self.grid[i], element)
				
				if self.dynamic_height and #self.grid >= self.grid_height then
					table.insert(self.grid, {})
				end
				
				break
			end
		end

		self:autoSize()
		self:autoElementPos()
		
	
	-- if "element" passed to add() is a table consisting of Elements and/or Containers 
	else
	
		for _,table_element in pairs(element) do
			self:add(table_element)
		end
	
	end
		
	
	return self
end

function GUI.Container:autoSize()
	local width  = #self.grid[1]    * (self.element_size.width  + self.padding) + self.padding
	local height = (#self.grid - 1) * (self.element_size.height + self.padding) + self.padding
	
	self:setSize(width, height)
	
	return self
end

-- automatically sets positions of all elements
function GUI.Container:autoElementPos()
	for column_index,column in pairs(self.grid) do
		for row_index,element in pairs(column) do
			element:setPos(
				self.x + self.padding + (row_index-1) * (element.width + self.padding), 
				self.y + self.padding + (column_index-1) * (element.height + self.padding)
			)
		end
	end
end

local callbacks = {"update", "draw", "mousepressed", "mousereleased"}

for _,callback in pairs(callbacks) do
	GUI.Container[callback] = function(self, ...)
		for _,column in pairs(self.grid) do
			for _,element in pairs(column) do
				element[callback](element, ...)
			end
		end
	end
end


function GUI.Container:getElementNum()
	local all_elements_num = 0
	
	for _,column in pairs(self.grid) do
		for _,element in pairs(column) do
			all_elements_num = all_elements_num + 1
		end
	end
	
	return all_elements_num
end

------------------------------------------------------------------------

GUI.ShopButton = GUI.Button:subclass("GUIShopButton")

function GUI.ShopButton:initialize(text)
	self.icon = love.graphics.newImage("assets/images/icons/" .. text .. ".png")
	
	
	GUI.Button.initialize(self, text)
end

function GUI.ShopButton:setPrice(price)
	self.price = price
	
	if self.price < 0 then self.price = 0 end
	
	return self
end

function GUI.ShopButton:setAmount(amount)
	self.amount = amount
	
	return self
end

function GUI.ShopButton:setLimit(min, max)
	self.limit = {min = min, max = max}

	return self
end
	
function GUI.ShopButton:setItem(entity, item, func)
	self:setFunc(	
		function()
			if (entity.money or entity.entity.money) >= self.price then
				
				if entity[item] < self.limit.min 
				or entity[item] > self.limit.max then
					
					Messages:add(
						Message("Limit reached")
					)
				else
				
					if func == nil then 
						entity[item] = entity[item] + self.amount
					else
						func(self.amount)
					end

					if entity.money then 
						entity.money = entity.money - self.price
					elseif entity.entity then
						-- for turrets
						entity.entity.money = entity.entity.money - self.price
				
					end
				end
			end
		end
	)
	
	self.entity = entity
	self.item = item
	
	return self
end

function GUI.ShopButton:draw()
	love.graphics.setColor(GUI.colours[self.state].bg)
	love.graphics.rectangle("fill", self:getBBox())
	love.graphics.rectangle("line", self:getBBox())

	love.graphics.setColor(GUI.colours[self.state].fg)
	
	local sign
	if self.amount < 0 then sign = "" else sign = "+" end
	
	love.graphics.printf(
		sign .. self.amount .. " " .. self.text .. ", " .. self.price .. "$", 
		self.x, self.y + self.height/2 - love.graphics.getFont():getHeight()/2,
		self.width, "center"
	)

	love.graphics.setColor(255,255,255)
	
	love.graphics.draw(self.icon, self.x - 100, self.y)
	
	love.graphics.print(
		self.entity[self.item], 
		self.x - 60, 
		self.y + self.icon:getHeight()/2 - love.graphics.getFont():getHeight()/2
	)
end








