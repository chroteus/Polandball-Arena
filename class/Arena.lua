Arena = Class("Arena")

function Arena:initialize(arg)
    self.x = arg.x
    self.y = arg.y
    self.width = arg.width
    self.height = arg.height

    self.teams = {}
end

------------------------------------------------------------------------
function Arena:newTeam(name)
    self.teams[name] = {}
    
    return self
end

function Arena:add(fighter)
    assert(self.temp_fighter == nil, 
        "Call Arena:to before calling Arena:add.")
        
    self.temp_fighter = fighter
    return self
end

function Arena:to(team)
    assert(self.temp_fighter ~= nil, "Set fighter to add to team with Arena:add")
    
    if self.teams[team] == nil then self.teams[team] = {} end
    table.insert(self.teams[team], self.temp_fighter)
    self.temp_fighter = nil
    
    return self
end
    
------------------------------------------------------------------------

function Arena:start(arg)
    for _,team in pairs(self.teams) do
        for _,fighter in pairs(team) do            
            -- Add enemies for fighter to attack
            for _,enemy_team in pairs(self.teams) do
                if enemy_team ~= team then
                    fighter:addEnemies(enemy_team)
                end
            end
        end
    end
    
    if not(arg and arg.dont_switch) then
        game.arena = self
        Gamestate.switch(game)
    end
end

------------------------------------------------------------------------

function Arena:update(dt)
    for _,team in pairs(self.teams) do
        for k_f,fighter in pairs(team) do
            fighter:update(dt)

            if fighter.dead then
                team[k_f] = nil
            end
        end
    end
end

function Arena:draw()
    for _,team in pairs(self.teams) do
        table.sort(team, function(a,b) return b.y < a.y end)
        for _,fighter in pairs(team) do
            fighter:draw()
        end
    end
end

function Arena:keypressed(key)
    for _,team in pairs(self.teams) do
        for _,fighter in pairs(team) do
            if fighter:isInstanceOf(Player) then
                fighter:keypressed(key)
            end
        end
    end
end

function Arena:attachToState(state)
    local callbacks = {"update", "draw", "keypressed"}
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
