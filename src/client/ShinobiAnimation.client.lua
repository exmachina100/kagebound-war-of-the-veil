-- KAGEBOUND Shinobi animation/presentation driver 0.4.
-- Server is always authoritative: this script NEVER fires damage or action remotes.
-- Authored Roblox animation IDs are optional; until supplied, animate Tool.Grip
-- locally as a temporary blockout (safe with modern AnimationConstraint avatars).
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local shared = ReplicatedStorage:WaitForChild("KageboundShared")
local Catalog = require(shared:WaitForChild("AnimationCatalog"))
local Rules = require(shared:WaitForChild("CombatRules"))
local combat = ReplicatedStorage:WaitForChild("KageboundCombat")

local currentCharacter = nil
local tracks = {}
local failedTracks = {}
local baseGrips = setmetatable({}, {__mode="k"})
local activeTween = nil
local poseSequence = 0
local trailSequence = 0
local lastPose = nil

local function stopTween()
    if activeTween then activeTween:Cancel() activeTween=nil end
end

local function equippedVeilblade()
    local character = player.Character
    if not character then return nil end
    local tool = character:FindFirstChild("Veilblade")
    if tool and tool:IsA("Tool") then return tool end
    return nil
end

local function getTrack(key)
    local id = Catalog.Resolve(Catalog.Shinobi[key])
    if not id or failedTracks[key] then return nil end
    local character = player.Character
    if not character then return nil end
    if tracks[key] then return tracks[key] end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
    if not animator then return nil end
    local animation = Instance.new("Animation")
    animation.AnimationId = id
    local ok, track = pcall(function() return animator:LoadAnimation(animation) end)
    animation:Destroy()
    if not ok or not track then
        failedTracks[key] = true
        warn("[KAGEBOUND] Animation load failed for "..key.."; using grip pose fallback")
        return nil
    end
    track.Priority = Enum.AnimationPriority.Action
    track.Looped = false
    tracks[key] = track
    return track
end

local function playTrack(key)
    local track = getTrack(key)
    if not track then return false end
    -- A combo should replace the previous attack track, not blend indefinitely.
    for name,other in pairs(tracks) do
        if name~=key and other.IsPlaying then other:Stop(.05) end
    end
    -- Play only on the owning client; eligible player tracks replicate.
    -- Damage remains server-timed and independent of cosmetic marker callbacks.
    track:Play(0.06,1,1)
    return true
end

local function gripPose(tool,relative,duration)
    if not tool or tool.Parent~=player.Character then return end
    local baseline = baseGrips[tool]
    if not baseline then baseline=tool.Grip baseGrips[tool]=baseline end
    stopTween()
    local tween=TweenService:Create(tool,TweenInfo.new(duration,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{
        Grip=baseline*relative
    })
    activeTween=tween
    tween:Play()
end

local function restoreGrip(tool,duration,token)
    if token~=poseSequence or not tool or tool.Parent~=player.Character then return end
    local baseline=baseGrips[tool]
    if not baseline then return end
    stopTween()
    activeTween=TweenService:Create(tool,TweenInfo.new(duration,Enum.EasingStyle.Quad),{Grip=baseline})
    activeTween:Play()
end

local function beginPose(key,windup,recovery)
    poseSequence+=1
    local token=poseSequence
    local authored = playTrack(key)
    local tool=equippedVeilblade()
    lastPose = {key=key, authored=authored, tool=tool, sequence=token}
    if authored or not tool then return end

    local angles={
        Light1={-35,-30,35},
        Light2={25,30,-45},
        Light3={-45,10,60},
        Heavy={-75,-20,70},
        Parry={-40,0,-68},
        Dash={-18,0,-12},
        DoubleJump={-25,0,-26}
    }
    local v=angles[key] or {0,0,0}
    local target=CFrame.Angles(math.rad(v[1]),math.rad(v[2]),math.rad(v[3]))
    gripPose(tool,target,math.max(.06,windup*.8))
    task.delay(windup+recovery,function()
        restoreGrip(tool,.16,token)
    end)
end

-- A blade-bound Trail follows the actual equipped tool locally; remote players
-- still receive authored combat VFX via CombatVFX.client.lua.
local function activeBladeTrail()
    local tool=equippedVeilblade()
    if not tool then return end
    local trail=tool:FindFirstChild("VeilbladeTrail",true)
    if not trail or not trail:IsA("Trail") then return end
    trailSequence+=1
    local token=trailSequence
    trail.Enabled=true
    task.delay(.16,function()
        if trailSequence==token and trail.Parent then
            trail.Enabled=false
        end
    end)
end

local function finishSwing(action,combo)
    local pose=lastPose
    if not pose then return end
    local expected=action=="Heavy" and "Heavy" or "Light"..tostring(combo or 1)
    if pose.key~=expected or pose.sequence~=poseSequence then return end
    activeBladeTrail()
    if pose.authored then return end
    local tool=pose.tool
    if not tool or tool.Parent~=player.Character then return end
    -- Fast slash follow-through; the original windup schedules the reset.
    local angles={
        Light1={26,18,-55},
        Light2={-32,-18,56},
        Light3={41,14,-70},
        Heavy={55,35,-90}
    }
    local v=angles[expected] or {0,0,0}
    local duration=Rules.AttackTimeline[action].active
    gripPose(tool,CFrame.Angles(math.rad(v[1]),math.rad(v[2]),math.rad(v[3])),
        math.max(.07,duration*.7))
end

local function onCharacter(character)
    poseSequence+=1
    trailSequence+=1
    lastPose=nil
    stopTween()
    for _,track in pairs(tracks) do
        track:Stop(.05)
        track:Destroy()
    end
    table.clear(tracks)
    table.clear(failedTracks)
    currentCharacter=character
end

player.CharacterAdded:Connect(onCharacter)
if player.Character then onCharacter(player.Character) end

combat.OnClientEvent:Connect(function(event,actor,arg1,arg2)
    if actor~=player or player.Character~=currentCharacter then return end
    if event=="Windup" then
        local action=arg1
        if action=="Light" then
            local index=math.clamp(tonumber(arg2) or 1,1,3)
            beginPose("Light"..index,Rules.AttackTimeline.Light.windup,
                Rules.AttackTimeline.Light.active+Rules.AttackTimeline.Light.recovery)
        elseif action=="Heavy" then
            beginPose("Heavy",Rules.AttackTimeline.Heavy.windup,
                Rules.AttackTimeline.Heavy.active+Rules.AttackTimeline.Heavy.recovery)
        end
    elseif event=="Swing" then
        finishSwing(arg1,arg2)
    elseif event=="ParryStart" then
        beginPose("Parry",Rules.ParryWindow,.1)
    elseif event=="DashFX" then
        beginPose("Dash",.1,.12)
    elseif event=="DoubleJumpFX" then
        beginPose("DoubleJump",.12,.24)
    end
end)
print("[KAGEBOUND] Shinobi authored animation slots + safe grip fallback initialized")
