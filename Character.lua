game:GetService"RunService".RenderStepped:Connect(function()
game.Players.LocalPlayer.Character.Head.Anchored = false
game.Players.LocalPlayer.Character.Torso.Anchored = false
game.Players.LocalPlayer.Character["Left Arm"].Anchored = false
game.Players.LocalPlayer.Character["Right Arm"].Anchored = false
game.Players.LocalPlayer.Character["Left Leg"].Anchored = false
game.Players.LocalPlayer.Character["Right Leg"].Anchored = false
game.Players.LocalPlayer.Character["HumanoidRootPart"].Anchored = false
end)
