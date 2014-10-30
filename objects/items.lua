GLOBALS.items = {
    Item{name = "Iron Sword", type = "primary",
         onEquip   = function(fighter) fighter.attack_stat = fighter.attack_stat + 1 end,
         onUnequip = function(fighter) fighter.attack_stat = fighter.attack_stat - 1 end,
    },
}
