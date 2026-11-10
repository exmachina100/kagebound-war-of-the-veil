-- Optional R15 locomotion animation layer. Falls back to Roblox Animate until
-- game-owned clips are published; never overrides server-authoritative movement.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Shared=ReplicatedStorage:WaitForChild("KageboundShared")
local Rules=require(Shared:WaitForChild("LocomotionRules"))
local Catalog=require(Shared:WaitForChild("LocomotionAnimationCatalog"))
local player=Players.LocalPlayer
local currentCharacter=nil
local currentTrack=nil
local currentState=nil
local cached={}
local heartbeat=nil
local function stopTrack()
    if currentTrack then currentTrack:Stop(0.16) end
    currentTrack=nil
end
local function cleanup()
    if heartbeat then heartbeat:Disconnect();heartbeat=nil end
    stopTrack()
    for _,track in pairs(cached) do
        track:Stop(0)
        track:Destroy()
    end
    table.clear(cached)
    currentCharacter=nil
    currentState=nil
end
local function attach(character)
    cleanup()
    currentCharacter=character
    local humanoid=character:WaitForChild("Humanoid",8)
    if not humanoid or player.Character~=character then return end
    local animator=humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator",5)
    if not animator then return end
    local function resolveTrack(state)
        local className=player:GetAttribute("KageboundClass")
        local id=Catalog.Resolve(className,state)
        if not id then return nil end
        local existing=cached[id]
        if existing then return existing end
        local anim=Instance.new("Animation")
        anim.AnimationId=id
        local ok,track=pcall(function() return animator:LoadAnimation(anim) end)
        anim:Destroy()
        if not ok or not track then return nil end
        track.Priority=Enum.AnimationPriority.Movement
        track.Looped=state~="Land" and state~="Start" and state~="Stop" and state~="Pivot"
        cached[id]=track
        return track
    end
    heartbeat=RunService.Heartbeat:Connect(function()
        if player.Character~=character or humanoid.Health<=0 then
            cleanup()
            return
        end
        local root=character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local velocity=root.AssemblyLinearVelocity
        local planar=Vector3.new(velocity.X,0,velocity.Z).Magnitude
        local grounded=humanoid.FloorMaterial~=Enum.Material.Air
        local sprinting=player:GetAttribute("KageboundSprinting")==true
        local state=Rules.StateFor(planar,grounded,velocity.Y,sprinting)
        if not state or state==currentState then return end
        currentState=state
        local nextTrack=resolveTrack(state)
        if currentTrack~=nextTrack then
            stopTrack()
            if nextTrack then
                -- Disable Roblox's default Animate only after owned clips
                -- exist for all locomotion states; otherwise blend conservatively.
                nextTrack:Play(0.16,0.7,1)
            end
            currentTrack=nextTrack
        end
    end)
end
player.CharacterAdded:Connect(attach)
player.CharacterRemoving:Connect(cleanup)
if player.Character then task.spawn(attach,player.Character) end
