while wait() do
    local ohString1 = "WeakPunch"
    local ohInstance2 = workspace.Entities.coldheck.Stand.StandRarm
    local ohNumber3 = 0.5
game:GetService("ReplicatedStorage").CombatRemote:FireServer(ohString1, ohInstance2, ohNumber3)
    end
