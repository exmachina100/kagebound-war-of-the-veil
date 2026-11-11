-- Shared placement for independently authored HUDs. Gameplay scripts own their content.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local playerGui=player:WaitForChild("PlayerGui")
local gui=Instance.new("ScreenGui")
gui.Name="KageboundHUDNavigation"
gui.ResetOnSpawn=false
gui.DisplayOrder=10
gui.Parent=playerGui

local openPanel=nil
local layout
local buttons={}
local function toggle(key)
    openPanel=openPanel==key and nil or key
    layout()
end
for i,key in ipairs({"Journal","Loadout","Weapons"}) do
    local button=Instance.new("TextButton")
    button.Name=key
    button.Size=UDim2.fromOffset(110,44)
    button.Position=UDim2.fromOffset(14+(i-1)*118,8)
    button.BackgroundColor3=Color3.fromRGB(28,23,48)
    button.TextColor3=Color3.fromRGB(244,224,248)
    button.Font=Enum.Font.GothamBold
    button.TextSize=14
    button.Text=string.upper(key)
    button.Parent=gui
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,9)
    corner.Parent=button
    button.Activated:Connect(function()
        toggle(key)
    end)
    buttons[key]=button
end
UIS.InputBegan:Connect(function(input,processed)
    if processed or UIS:GetFocusedTextBox() then return end
    if input.KeyCode==Enum.KeyCode.J then toggle("Journal") end
    if input.KeyCode==Enum.KeyCode.L then toggle("Loadout") end
    if input.KeyCode==Enum.KeyCode.B then toggle("Weapons") end
end)

local function panel(screen,name)
    local root=playerGui:FindFirstChild(screen)
    if root then root.IgnoreGuiInset=false end
    return root and root:FindFirstChild(name)
end
local function place(object,x,y,width,height,visible)
    if not object then return end
    object.AnchorPoint=Vector2.zero
    object.Position=UDim2.fromOffset(x,y)
    object.Size=UDim2.fromOffset(width,height)
    if visible~=nil then object.Visible=visible end
end

layout=function()
    local camera=workspace.CurrentCamera
    if not camera then return end
    local viewport=camera.ViewportSize
    local width,height=viewport.X,viewport.Y
    local compact=width<1200 or height<600
    local left=math.min(300,width-28)
    local journal=not compact or openPanel=="Journal"
    local loadout=not compact or openPanel=="Loadout"
    local weapons=not compact or openPanel=="Weapons"
    local top=compact and 62 or 12
    local navWidth=math.min(110,(width-44)/3)
    for i,key in ipairs({"Journal","Loadout","Weapons"}) do
        local button=buttons[key]
        button.Position=UDim2.fromOffset(14+(i-1)*(navWidth+8),8)
        button.Size=UDim2.fromOffset(navWidth,44)
        button.Visible=compact
        button.BackgroundColor3=openPanel==key and Color3.fromRGB(118,53,135)
            or Color3.fromRGB(28,23,48)
    end

    local short=compact and height<500
    -- The region journal already names the district; omit the duplicate travel
    -- heading on short phones so objectives fit without shrinking their text.
    place(panel("KageboundWorldHUD","TravelDisplay"),14,top,left,80,journal and not short)
    place(panel("KageboundRegionHUD","Region"),14,top+(short and 0 or 90),left,166,journal)
    place(panel("KageboundQuestHUD","QuestJournal"),14,top+(short and 176 or 266),left,96,journal)
    place(panel("KageboundRegionHUD","RewardFeedback"),math.max(14,(width-360)/2),
        compact and 62 or 140,math.min(360,width-28),40)

    local rightWidth=math.min(350,width-28)
    local rightX=compact and 14 or width-rightWidth-14
    place(panel("KageboundMaskHUD","MaskToolbar"),rightX,top,rightWidth,76,loadout)
    local styles=panel("KageboundClassHUD","StyleToolbar")
    -- Keep all four buttons inside the narrowest supported viewport.
    place(styles,rightX,top+86,350,108,loadout)
    if styles then
        local scale=styles:FindFirstChild("ResponsiveScale") or Instance.new("UIScale")
        scale.Name="ResponsiveScale"
        scale.Scale=math.min(1,rightWidth/350)
        scale.Parent=styles
    end
    place(panel("KageboundAssetQuickbar","MythicEquipment"),
        rightX,top+(compact and 204 or 450),112,38,loadout)
    place(panel("KageboundWeaponHUD","WeaponToolbar"),rightX,
        compact and top or top+204,rightWidth,236,weapons)

    local touch=compact and UIS.TouchEnabled
    place(panel("KageboundProgressionHUD","Progression"),14,touch and top or height-130,
        math.min(278,width-28),50,not compact or openPanel==nil)
    place(panel("KageboundStaminaHUD","Stamina"),14,touch and top+60 or height-70,
        math.min(230,width-28),50,not compact or openPanel==nil)
    local controls=panel("KageboundCombatHUD","Controls")
    if controls then
        controls.TextScaled=false
        controls.TextSize=13
        place(controls,328,height-56,math.max(260,width-656),40,
            not compact and not UIS.TouchEnabled)
    end
    local discovery=panel("KageboundRegionDiscovery","RegionBanner")
    if discovery then
        discovery.AnchorPoint=Vector2.new(.5,0)
        discovery.Position=UDim2.new(.5,0,0,compact and 62 or 12)
        -- Compact navigation owns this space while an overlay is open.
        local discoveryGui=discovery.Parent
        discoveryGui.Enabled=not compact or openPanel==nil
    end
end

local viewportConnection
local function watchCamera()
    if viewportConnection then viewportConnection:Disconnect() end
    if workspace.CurrentCamera then
        viewportConnection=workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(layout)
    end
    layout()
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchCamera)
-- HUDs initialize independently; one final deferred pass handles each new screen.
playerGui.DescendantAdded:Connect(function(object)
    if object:IsA("GuiObject") then task.defer(layout) end
end)
watchCamera()
