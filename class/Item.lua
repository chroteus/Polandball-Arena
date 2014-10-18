Item = Class "Item"

function Item:initialize(arg)
    self.name = arg.name or error("Name not defined.")
    self.text = arg.text or "Undefined text"
    
    if arg.type == "primary" or arg.type == "secondary"
    or arg.type == "tertiary" then
        self.type = arg.type
    else
        error("Type for an Item can be either primary, secondary "..
              " or tertiary.")
    end
    
    
    self.icon = love.graphics.newImage("assets/images/items/icons/" ..
                                        arg.name .. ".png")

    self.image = love.graphics.newImage("assets/images/items/images/" ..
                                        arg.name .. ".png"
    
    self.onEquip = arg.onEquip or error("onEquip not defined.")
    self.onUnequip = arg.onUnequip or error("onUnequip not defined")
end
