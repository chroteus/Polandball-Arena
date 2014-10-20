local function generateFighter(difficulty)
    local difficulty = difficulty or 1
    local fighter = GLOBALS.fighters[math.random(#GLOBALS.fighters)]

    return Fighter{
        name    = fighter.name,
        attack  = fighter.attack_stat*difficulty,
        defense = fighter.defense*difficulty,
    }
end

return generateFighter
        
