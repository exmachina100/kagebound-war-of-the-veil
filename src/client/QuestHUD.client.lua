-- KAGEBOUND quest toast and journal HUD, original visual styling from ART-001/004.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local evt=ReplicatedStorage:WaitForChild("KageboundQuestEvent")
local gui=Instance.new("ScreenGui")
gui.Name="KageboundQuestHUD"
gui.ResetOnSpawn=false
gui.Parent=Players.LocalPlayer:WaitForChild("PlayerGui")
local card=Instance.new("TextLabel")
card.Name="QuestJournal"
card.AnchorPoint=Vector2.new(1,0)
card.Position=UDim2.new(1,-18,0,125)
card.Size=UDim2.new(0,315,0,84)
card.BackgroundColor3=Color3.fromRGB(31,25,53)
card.BackgroundTransparency=.13
card.TextColor3=Color3.fromRGB(243,223,243)
card.TextStrokeTransparency=.95
card.TextWrapped=true
card.Font=Enum.Font.GothamMedium
card.TextSize=14
card.Text="KAGEBOUND | WORLD QUESTS\nSpeak to the Keeper at Kage Dojo."
card.Parent=gui
local rounding=Instance.new("UICorner")
rounding.CornerRadius=UDim.new(0,10)
rounding.Parent=card
local border=Instance.new("UIStroke")
border.Color=Color3.fromRGB(165,93,213)
border.Thickness=1
border.Parent=card
evt.OnClientEvent:Connect(function(message,stage)
    card.Text="KAGEBOUND | WHISPERS ACROSS THE VEIL\n"..message
    card.TextColor3=stage==3 and Color3.fromRGB(255,209,136) or Color3.fromRGB(243,223,243)
end)
