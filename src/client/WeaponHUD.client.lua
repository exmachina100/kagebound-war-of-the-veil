-- Requests only an archetype name; server weapon authority owns equipment/stats.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
local shared=ReplicatedStorage:WaitForChild("KageboundShared")
local Weapons=require(shared:WaitForChild("WeaponRules"))
local remote=ReplicatedStorage:WaitForChild("KageboundWeapon")
local gui=Instance.new("ScreenGui")
gui.Name="KageboundWeaponHUD"
gui.ResetOnSpawn=false
gui.Parent=player:WaitForChild("PlayerGui")
local panel=Instance.new("Frame")
panel.Name="WeaponToolbar"
panel.Position=UDim2.fromOffset(14,62)
panel.Size=UDim2.fromOffset(350,236)
panel.BackgroundColor3=Color3.fromRGB(27,23,45)
panel.BackgroundTransparency=.1
panel.BorderSizePixel=0
panel.Parent=gui
local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,10)
corner.Parent=panel
local heading=Instance.new("TextLabel")
heading.Name="Heading"
heading.Position=UDim2.fromOffset(10,5)
heading.Size=UDim2.new(1,-20,0,24)
heading.BackgroundTransparency=1
heading.Text="WEAPONS · SELECT AT KAGE DOJO"
heading.TextXAlignment=Enum.TextXAlignment.Left
heading.Font=Enum.Font.GothamBold
heading.TextSize=12
heading.TextColor3=Color3.fromRGB(244,191,113)
heading.Parent=panel
local grid=Instance.new("Frame")
grid.Name="Choices"
grid.Position=UDim2.fromOffset(10,34)
grid.Size=UDim2.new(1,-20,0,148)
grid.BackgroundTransparency=1
grid.Parent=panel
local layout=Instance.new("UIGridLayout")
layout.CellSize=UDim2.new(.5,-4,0,44)
layout.CellPadding=UDim2.fromOffset(8,8)
layout.SortOrder=Enum.SortOrder.LayoutOrder
layout.Parent=grid
local status=Instance.new("TextLabel")
status.Name="Status"
status.Position=UDim2.fromOffset(10,190)
status.Size=UDim2.new(1,-20,0,38)
status.BackgroundTransparency=1
status.TextWrapped=true
status.TextXAlignment=Enum.TextXAlignment.Left
status.Font=Enum.Font.GothamMedium
status.TextSize=12
status.TextColor3=Color3.fromRGB(225,211,239)
status.Parent=panel
local buttons={}
local pending=nil
local requestVersion=0
local message=nil
local function refresh()
    local selected=player:GetAttribute("KageboundPrimaryWeapon") or Weapons.Default
    for name,button in pairs(buttons) do
        button.Text=(name==selected and "✓ " or "")..name
        button.BackgroundColor3=name==selected and Color3.fromRGB(145,52,125)
            or Color3.fromRGB(48,42,74)
    end
    status.Text=message or ("Equipped: "..selected.." · Changes are available in the dojo before queueing.")
end
for index,name in ipairs(Weapons.Order) do
    if Weapons.CanSelect(name) then
        local button=Instance.new("TextButton")
        button.Name=name
        button.LayoutOrder=index
        button.Font=Enum.Font.GothamBold
        button.TextSize=14
        button.TextColor3=Color3.fromRGB(244,229,244)
        button.Parent=grid
        local rounding=Instance.new("UICorner")
        rounding.CornerRadius=UDim.new(0,7)
        rounding.Parent=button
        button.Activated:Connect(function()
            if pending then return end
            requestVersion+=1
            local version=requestVersion
            pending=name
            message="Requesting "..name.."…"
            refresh()
            remote:FireServer("Select",name)
            task.delay(2,function()
                if requestVersion~=version or not pending then return end
                pending=nil
                message="No change confirmed. Return to the dojo, leave any queue and finish your attack, then retry."
                refresh()
            end)
        end)
        buttons[name]=button
    end
end
remote.OnClientEvent:Connect(function(event,name)
    if event~="Selected" or not Weapons.CanSelect(name) then return end
    pending=nil
    requestVersion+=1
    message=nil
    refresh()
end)
player:GetAttributeChangedSignal("KageboundPrimaryWeapon"):Connect(refresh)
refresh()
