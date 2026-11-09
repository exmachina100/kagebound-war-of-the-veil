-- Original KAGEBOUND mask FX-006/007: bounded local neon motion cues.
-- Damage, targets, cooldown, and movement are determined on the server.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local TweenService=game:GetService("TweenService")
local Debris=game:GetService("Debris")
local UserInputService=game:GetService("UserInputService")
local remote=ReplicatedStorage:WaitForChild("KageboundMask")
local segments=UserInputService.TouchEnabled and 8 or 14
local function ring(root,amount,shade,name,height)
    local camera=workspace.CurrentCamera
    if camera and (camera.CFrame.Position-root.Position).Magnitude>170 then return end
    local center=root.Position+Vector3.new(0,height,0)
    for i=1,segments do
        local a=(i-1)*math.pi*2/segments
        local b=i*math.pi*2/segments
        local p1=center+Vector3.new(math.cos(a)*amount,0,math.sin(a)*amount)
        local p2=center+Vector3.new(math.cos(b)*amount,0,math.sin(b)*amount)
        local delta=p2-p1
        local p=Instance.new("Part")
        p.Name=name
        p.Size=Vector3.new(.24,.19,delta.Magnitude)
        p.CFrame=CFrame.lookAt((p1+p2)*.5,p2)
        p.Anchored=true
        p.CanCollide=false
        p.CanTouch=false
        p.CanQuery=false
        p.Material=Enum.Material.Neon
        p.Color=shade
        p.Parent=workspace
        TweenService:Create(p,TweenInfo.new(.34),{Transparency=1}):Play()
        Debris:AddItem(p,.44)
    end
end
remote.OnClientEvent:Connect(function(event,actor)
    if event~="OniFX" and event~="TenguFX" then return end
    local char=actor and actor.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if event=="OniFX" then
        ring(root,8,Color3.fromRGB(228,49,92),"FX006_OniShockwave",.5)
        ring(root,12,Color3.fromRGB(255,122,91),"FX006_OniEdge",1)
    else
        ring(root,4,Color3.fromRGB(151,218,255),"FX007_TenguWind",.4)
        ring(root,6,Color3.fromRGB(189,137,243),"FX007_TenguVeil",2)
    end
end)
