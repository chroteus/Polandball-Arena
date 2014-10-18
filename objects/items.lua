GLOBALS.items = {
    iron_sword = Item{name = "Iron Sword", type = "primary",
                      onEquip = function() print("equip") end,
                      onUnequip = function() print("took off") end,
                      },
}
