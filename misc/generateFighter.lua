local adjectives = {
    "Angry", "Square", "Ironic", "Round",
}

local function randomAdjective()
    math.randomseed(os.time())
    return adjectives[math.random(#adjectives)]
end

local function generateFighter(difficulty, FighterType)
    local difficulty = difficulty or 1
    local fighter = GLOBALS.fighters[math.random(#GLOBALS.fighters)]

    -- fighter: Fighter to base our random fighter on
    -- f: Fighter to return

    local FighterType = FighterType or FighterAI
    local f = FighterType{
        name    = fighter.name,
        attack  = fighter.attack_stat*difficulty + math.random(-3,3),
        defense = fighter.defense*difficulty + math.random(-3,3),
        hp      = fighter.hp*difficulty + math.random(-10,10),
    }
    f.name = randomAdjective() .. " " .. f.name
    
    local function wear()
        if f.items.primary == nil
        and (f.items.secondary == nil or f.items.tertiary == nil) then
            local item = GLOBALS.items[math.random(#GLOBALS.items)]
            f:equip(item)
            
            wear()
        end
    end
    
    wear()
    return f
end

return generateFighter        
