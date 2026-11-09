-- KAGEBOUND stamina HUD — read-only mirror of server-owned combat stamina.
-- Color and typography from ART-001..004. Never mutate the attribute here.
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local player=Players.LocalPlayer
local gui=player:WaitForChild("PlayerGui")
local existing=gui:FindFirstChild("KageboundStaminaHUD")
if existing then existing:Destroy() end
local screen=Instance.new("ScreenGui")
screen.Name="KageboundStaminaHUD"
screen.ResetOnSpawn=false
screen.IgnoreGuiInset=true
screen.Parent=gui
local frame=Instance.new("Frame")
frame.Name="Stamina"
frame.AnchorPoint=Vector2.new(0,1)
frame.Position=UDim2.new(0,20,1,-30)
frame.Size=UDim2.new(0,230,0,50)
frame.BackgroundColor3=Color3.fromRGB(23,21,40)
frame.BackgroundTransparency=.12
frame.BorderSizePixel=0
frame.Parent=screen
local rounded=Instance.new("UICorner")
rounded.CornerRadius=UDim.new(0,9)
rounded.Parent=frame
local label=Instance.new("TextLabel")
label.Name="Caption"
label.Text="SPIRIT STAMINA"
label.Size=UDim2.new(1,-16,0,19)
label.Position=UDim2.fromOffset(8,3)
label.BackgroundTransparency=1
label.TextXAlignment=Enum.TextXAlignment.Left
label.Font=Enum.Font.GothamBold
label.TextSize=12
label.TextColor3=Color3.fromRGB(230,215,250)
label.Parent=frame
local rail=Instance.new("Frame")
rail.Size=UDim2.new(1,-16,0,12)
rail.Position=UDim2.fromOffset(8,26)
rail.BackgroundColor3=Color3.fromRGB(62,54,85)
rail.BorderSizePixel=0
rail.Parent=frame
local fill=Instance.new("Frame")
fill.Name="Amount"
fill.Size=UDim2.fromScale(1,1)
fill.BackgroundColor3=Color3.fromRGB(186,105,224)
fill.BorderSizePixel=0
fill.Parent=rail
local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,4)
corner.Parent=rail
local cornerFill=Instance.new("UICorner")
cornerFill.CornerRadius=UDim.new(0,4)
cornerFill.Parent=fill
local currentTween=nil
local function sync()
    local value=math.clamp(tonumber(player:GetAttribute("KageboundStamina")) or 100,0,100)
    label.Text=("SPIRIT STAMINA  %d / 100"):format(math.floor(value+.5))
    if currentTween then currentTween:Cancel() end
    currentTween=TweenService:Create(fill,TweenInfo.new(.18),{Size=UDim2.fromScale(value/100,1)})
    currentTween:Play()
end
player:GetAttributeChangedSignal("KageboundStamina"):Connect(sync)
sync()
