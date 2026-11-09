-- KAGEBOUND mythic masks: original Kitsune / Oni / Tengu active selection.
-- Compact in-game toolbar; server chooses and authorizes the actual loadout.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local ContextActionService=game:GetService("ContextActionService")
local UserInputService=game:GetService("UserInputService")
local player=Players.LocalPlayer
local Shared=ReplicatedStorage:WaitForChild("KageboundShared")
local Rules=require(Shared:WaitForChild("MaskRules"))
local remote=ReplicatedStorage:WaitForChild("KageboundMask")
local kitsune=ReplicatedStorage:WaitForChild("KageboundKitsune")

local gui=Instance.new("ScreenGui")
gui.Name="KageboundMaskHUD"
gui.ResetOnSpawn=false
gui.Parent=player:WaitForChild("PlayerGui")
local frame=Instance.new("Frame")
frame.Name="MaskToolbar"
frame.AnchorPoint=Vector2.new(1,0)
frame.Position=UDim2.new(1,-20,0,24)
frame.Size=UDim2.fromOffset(260,76)
frame.BackgroundColor3=Color3.fromRGB(28,23,48)
frame.BackgroundTransparency=.12
frame.Parent=gui
local border=Instance.new("UICorner")
border.CornerRadius=UDim.new(0,10)
border.Parent=frame
local title=Instance.new("TextLabel")
title.Name="Title"
title.Size=UDim2.new(1,-12,0,21)
title.Position=UDim2.fromOffset(7,3)
title.TextXAlignment=Enum.TextXAlignment.Left
title.BackgroundTransparency=1
title.Font=Enum.Font.GothamBold
title.TextSize=12
title.TextColor3=Color3.fromRGB(245,202,124)
title.Text="MYTHIC MASK  [Z / X] SELECT AT DOJO"
title.Parent=frame
local btns={}
local names={"Kitsune","Oni","Tengu"}
local function current()
    local mask=player:GetAttribute("KageboundMask")
    return Rules.IsValid(mask) and mask or "Kitsune"
end
local function selected()
    local mask=current()
    for _,name in ipairs(names) do
        local b=btns[name]
        b.BackgroundColor3=name==mask and Color3.fromRGB(165,58,122) or Color3.fromRGB(51,41,72)
        b.TextColor3=name==mask and Color3.fromRGB(255,242,252) or Color3.fromRGB(215,197,229)
    end
end
for i,name in ipairs(names) do
    local btn=Instance.new("TextButton")
    btn.Name=name
    btn.Size=UDim2.fromOffset(78,29)
    btn.Position=UDim2.fromOffset(7+(i-1)*83,31)
    btn.Font=Enum.Font.GothamBold
    btn.TextSize=13
    btn.Text=name:upper()
    btn.Parent=frame
    local rounded=Instance.new("UICorner")
    rounded.CornerRadius=UDim.new(0,6)
    rounded.Parent=btn
    btns[name]=btn
    btn.MouseButton1Click:Connect(function()
        remote:FireServer("Select",name)
    end)
end
player:GetAttributeChangedSignal("KageboundMask"):Connect(selected)
selected()

local lastRequest=-math.huge
local function cast(_,state)
    if state~=Enum.UserInputState.Begin then return Enum.ContextActionResult.Pass end
    if UserInputService:GetFocusedTextBox() then return Enum.ContextActionResult.Pass end
    if os.clock()-lastRequest<.15 then return Enum.ContextActionResult.Sink end
    lastRequest=os.clock()
    if current()=="Kitsune" then kitsune:FireServer("Cast")
    else remote:FireServer("Cast") end
    return Enum.ContextActionResult.Sink
end
ContextActionService:BindAction("KageboundMaskCast",cast,true,Enum.KeyCode.G,Enum.KeyCode.ButtonY)
ContextActionService:SetTitle("KageboundMaskCast","MASK")
ContextActionService:SetPosition("KageboundMaskCast",UDim2.new(1,-255,1,-145))

local function cycle(step)
    local mask=current()
    local index=table.find(names,mask) or 1
    local nextIndex=(index-1+step)%#names+1
    remote:FireServer("Select",names[nextIndex])
end
UserInputService.InputBegan:Connect(function(input,used)
    if used or UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode==Enum.KeyCode.Z then cycle(-1)
    elseif input.KeyCode==Enum.KeyCode.X then cycle(1) end
end)
remote.OnClientEvent:Connect(function(kind,data)
    if kind=="Cooldown" and data and Rules.IsValid(data.mask) then
        print("[KAGEBOUND] "..data.mask.." used; cooldown "..tostring(data.seconds).." seconds")
    end
end)
print("[KAGEBOUND] Unified mythic mask toolbar ready")
