-- KAGEBOUND: four-style compact loadout toolbar and distinct class action.
-- The client requests a class, but the SERVER validates selection/ability.
-- This never sets style attributes, speeds, damage, HP or cooldowns locally.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local ContextActionService=game:GetService("ContextActionService")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local Shared=ReplicatedStorage:WaitForChild("KageboundShared")
local Rules=require(Shared:WaitForChild("ClassRules"))
local remote=ReplicatedStorage:WaitForChild("KageboundClass")

local gui=Instance.new("ScreenGui")
gui.Name="KageboundClassHUD"
gui.ResetOnSpawn=false
gui.Parent=player:WaitForChild("PlayerGui")
local panel=Instance.new("Frame")
panel.Name="StyleToolbar"
panel.AnchorPoint=Vector2.new(1,0)
panel.Position=UDim2.new(1,-20,0,108)
panel.Size=UDim2.fromOffset(350,108)
panel.BackgroundColor3=Color3.fromRGB(27,23,45)
panel.BackgroundTransparency=.11
panel.BorderSizePixel=0
panel.Parent=gui
local rounded=Instance.new("UICorner")
rounded.CornerRadius=UDim.new(0,10)
rounded.Parent=panel
local heading=Instance.new("TextLabel")
heading.Name="Heading"
heading.Position=UDim2.fromOffset(9,4)
heading.Size=UDim2.new(1,-18,0,22)
heading.BackgroundTransparency=1
heading.TextXAlignment=Enum.TextXAlignment.Left
heading.Font=Enum.Font.GothamBold
heading.TextSize=12
heading.TextColor3=Color3.fromRGB(244,191,113)
heading.Text="WARRIOR STYLE  ·  SELECT AT KAGE DOJO"
heading.Parent=panel

local buttons={}
local function style()
    local s=player:GetAttribute("KageboundWarriorStyle")
    return Rules.IsValid(s) and s or "Shinobi"
end
local cooldownUntil=0
local cooldownStyle=nil
local abilityText=Instance.new("TextLabel")
abilityText.Name="Ability"
abilityText.Position=UDim2.fromOffset(9,67)
abilityText.Size=UDim2.new(1,-18,0,31)
abilityText.BackgroundTransparency=1
abilityText.TextXAlignment=Enum.TextXAlignment.Left
abilityText.Font=Enum.Font.GothamMedium
abilityText.TextSize=12
abilityText.TextColor3=Color3.fromRGB(217,207,238)
abilityText.Parent=panel

for i,name in ipairs(Rules.Order) do
    local b=Instance.new("TextButton")
    b.Name=name:gsub("%s","")
    b.Position=UDim2.fromOffset(8+(i-1)*85,29)
    b.Size=UDim2.fromOffset(80,32)
    b.Text=name=="Oni Disciple" and "ONI" or string.upper(name)
    b.TextSize=11
    b.Font=Enum.Font.GothamBold
    b.TextColor3=Color3.fromRGB(234,225,248)
    b.Parent=panel
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,6)
    c.Parent=b
    b.MouseButton1Click:Connect(function()
        remote:FireServer("Select",name)
    end)
    buttons[name]=b
end
local function refresh()
    local chosen=style()
    for name,b in pairs(buttons) do
        b.BackgroundColor3=name==chosen
            and Color3.fromRGB(150,66,148) or Color3.fromRGB(48,42,74)
    end
    local desc=Rules.Get(chosen)
    local sec=(cooldownStyle==chosen) and math.max(0,cooldownUntil-os.clock()) or 0
    abilityText.Text=("%s  ·  H / L1 / STYLE%s"):format(desc and desc.Ability or "Class",
        sec>.1 and ("  ·  "..string.format("%.1fs",sec)) or "  ·  Ready")
end
player:GetAttributeChangedSignal("KageboundWarriorStyle"):Connect(refresh)
remote.OnClientEvent:Connect(function(event,details)
    if event=="Cooldown" and typeof(details)=="table" then
        cooldownStyle=details.style
        cooldownUntil=os.clock()+(tonumber(details.seconds) or 0)
        refresh()
    elseif event=="Selected" then
        cooldownStyle=nil
        refresh()
    end
end)

local function cast(_,inputState)
    if inputState~=Enum.UserInputState.Begin then return Enum.ContextActionResult.Pass end
    if UIS:GetFocusedTextBox() then return Enum.ContextActionResult.Pass end
    remote:FireServer("Cast")
    return Enum.ContextActionResult.Sink
end
ContextActionService:BindAction("KageboundClassAbility",cast,true,
    Enum.KeyCode.H,Enum.KeyCode.ButtonL1)
ContextActionService:SetTitle("KageboundClassAbility","STYLE")
ContextActionService:SetPosition("KageboundClassAbility",UDim2.new(0,104,1,-172))

task.spawn(function()
    while gui.Parent do
        refresh()
        task.wait(.25)
    end
end)
refresh()
print("[KAGEBOUND] Four-class loadout toolbar: H to use selected style ability")
