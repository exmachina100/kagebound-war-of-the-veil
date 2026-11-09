-- Lightweight Veilfall UI cue. ART-004, FX-008/009.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local TweenService=game:GetService("TweenService")
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local evt=ReplicatedStorage:WaitForChild("KageboundVeilfall")
local gui=Instance.new("ScreenGui")
gui.Name="KageboundVeilfallHUD"
gui.ResetOnSpawn=false
gui.Parent=player:WaitForChild("PlayerGui")
local text=Instance.new("TextLabel")
text.Name="VeilfallNotice"
text.AnchorPoint=Vector2.new(.5,0)
text.Position=UDim2.fromScale(.5,.07)
text.Size=UDim2.new(.65,0,0,54)
text.BackgroundColor3=Color3.fromRGB(38,26,72)
text.BackgroundTransparency=.2
text.TextColor3=Color3.fromRGB(242,203,255)
text.Font=Enum.Font.GothamBold
text.TextScaled=true
text.Text=""
text.Visible=false
text.Parent=gui
local stroke=Instance.new("UIStroke")
stroke.Color=Color3.fromRGB(177,92,239)
stroke.Thickness=2
stroke.Parent=text
local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,12)
corner.Parent=text
local sequence=0
evt.OnClientEvent:Connect(function(state, seconds)
    sequence=sequence+1
    local current=sequence
    if state=="Warning" then
        text.Visible=true
        for n=seconds,1,-1 do
            if sequence~=current then return end
            text.Text="VEILFALL IN "..n.." — NEW ROUTES OPEN"
            task.wait(1)
        end
    elseif state=="Active" then
        text.Visible=true
        text.Text="VEILFALL — SPIRIT PLATFORMS ACTIVE"
        task.delay(3,function() if sequence==current then text.Visible=false end end)
    elseif state=="Closing" then
        text.Visible=true
        for n=seconds,1,-1 do
            if sequence~=current then return end
            text.Text="VEIL CLOSING IN "..n.." — RETURN TO SAFE GROUND"
            task.wait(1)
        end
    elseif state=="Closed" then
        text.Visible=true
        text.Text="VEIL SEALED — ARENA RESTORED"
        task.delay(3,function() if sequence==current then text.Visible=false end end)
    end
end)
