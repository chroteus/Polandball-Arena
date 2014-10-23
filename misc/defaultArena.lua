local function defaultArena(allies, enemies)
    local arena = Arena{x=0, y=0, width=the.screen.width, height=the.screen.height}
    
    for _,ally in pairs(allies) do
        arena:add(ally):to("allies")
    end
    
    for _,enemy in pairs(enemies) do
        arena:add(enemy):to("enemies")
    end

    return arena
end

return defaultArena
