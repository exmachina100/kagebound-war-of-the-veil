-- KAGEBOUND Studio-only VFX preview (P). This is not a player ability.
-- No FireServer calls, damage, cooldowns or real class changes.
-- Use within the Kage Dojo SafeHub to compare visuals against original ART-001..004
-- and the eight uploaded cinematic/class VFX concept sheets.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end

local Players=game:GetService("Players")
local UserInputService=game:GetService("UserInputService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
local Shared=ReplicatedStorage:WaitForChild("KageboundShared")
local Profiles=require(Shared:WaitForChild("VFXProfiles"))
local World=require(Shared:WaitForChild("WorldConfig"))
local FX=require(script.Parent:WaitForChild("VFXFactory"))

local gui=Instance.new("ScreenGui")
gui.Name="KageboundVFXStudioPreview"
gui.ResetOnSpawn=false
gui.Parent=player:WaitForChild("PlayerGui")

local panel=Instance.new("Frame")
panel.Name="VFXPreviewToolbar"
panel.Size=UDim2.fromOffset(360,192)
panel.Position=UDim2.fromOffset(15,106)
panel.BackgroundColor3=Color3.fromRGB(28,23,46)
panel.BackgroundTransparency=.06
panel.BorderSizePixel=0
panel.Visible=false
panel.Parent=gui
local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,10)
corner.Parent=panel

local title=Instance.new("TextLabel")
title.Name="Title"
title.Size=UDim2.new(1,-20,0,34)
title.Position=UDim2.fromOffset(10,5)
title.BackgroundTransparency=1
title.Text="KAGEBOUND  /  STUDIO VFX TEST  [P]"
title.Font=Enum.Font.GothamBold
title.TextSize=14
title.TextXAlignment=Enum.TextXAlignment.Left
title.TextColor3=Color3.fromRGB(249,211,145)
title.Parent=panel

local status=Instance.new("TextLabel")
status.Name="Status"
status.Size=UDim2.new(1,-18,0,29)
status.Position=UDim2.fromOffset(9,149)
status.BackgroundTransparency=1
status.TextWrapped=true
status.TextSize=11
status.Font=Enum.Font.Gotham
status.TextColor3=Color3.fromRGB(222,208,237)
status.Text="Preview is LOCAL only • No damage / ability unlock"
status.Parent=panel

local labels={"Shinobi","Ronin","Onmyoji","Oni Disciple","Kitsune","Oni","Tengu","Parry"}
local lastClick=0
local function inDojo(root)
    for _,zone in ipairs(World.Zones) do
        if zone.kind=="SafeHub" then
            local offset=Vector2.new(root.Position.X-zone.x,root.Position.Z-zone.z)
            return offset.Magnitude<=zone.radius
        end
    end
    return false
end

local function preview(name)
    local now=os.clock()
    if now-lastClick<.85 then return end
    lastClick=now
    local root=FX.Root(player)
    if not root or not inDojo(root) then
        status.Text="Enter Kage Dojo safe hub to preview VFX."
        return
    end
    status.Text="Preview: "..name.."  •  cosmetic only"
    if name=="Kitsune" then
        FX.Kitsune(root,Profiles.GetMask("Kitsune"))
    elseif name=="Oni" then
        FX.Oni(root,Profiles.GetMask("Oni"))
    elseif name=="Tengu" then
        FX.Tengu(root,Profiles.GetMask("Tengu"))
    elseif name=="Parry" then
        FX.Parry(root,Profiles.Get("Ronin"),true)
    elseif name=="Onmyoji" then
        FX.Seal(root,Profiles.Get("Onmyoji"),2,5.5,"QA_OnmyojiWard")
        FX.Spokes(root,12,7,2,Profiles.Get("Onmyoji").core,"QA_OfudaFlash",.45)
    elseif name=="Oni Disciple" then
        FX.Windup(root,Profiles.Get(name),true)
        task.delay(.24,function()
            if root.Parent then FX.Oni(root,Profiles.Get(name)) end
        end)
    else
        FX.Windup(root,Profiles.Get(name),false)
        task.delay(.13,function()
            if root.Parent then FX.Slash(root,Profiles.Get(name),false,1) end
        end)
    end
end

for i,name in ipairs(labels) do
    local column=(i-1)%4
    local line=math.floor((i-1)/4)
    local btn=Instance.new("TextButton")
    btn.Name=name:gsub("%s","")
    btn.Position=UDim2.fromOffset(10+column*87,44+line*50)
    btn.Size=UDim2.fromOffset(81,40)
    btn.BackgroundColor3=Color3.fromRGB(58,45,81)
    btn.TextColor3=Color3.fromRGB(246,236,253)
    btn.Font=Enum.Font.GothamBold
    btn.TextSize=name=="Oni Disciple" and 10 or 12
    btn.Text=name
    btn.Parent=panel
    local rounding=Instance.new("UICorner")
    rounding.CornerRadius=UDim.new(0,7)
    rounding.Parent=btn
    btn.MouseButton1Click:Connect(function() preview(name) end)
end

UserInputService.InputBegan:Connect(function(input,used)
    if used or UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode==Enum.KeyCode.P then
        panel.Visible=not panel.Visible
    end
end)
print("[KAGEBOUND STUDIO] VFX preview panel ready; press P at Kage Dojo")
