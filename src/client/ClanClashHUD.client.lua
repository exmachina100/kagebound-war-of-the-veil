-- KAGEBOUND Clan Clash 2v2 HUD — server-owned team scores and match state.
-- Client sends only CancelQueue and explicit Forfeit requests.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
local event=ReplicatedStorage:WaitForChild("KageboundClanClash")

local gui=Instance.new("ScreenGui")
gui.Name="KageboundClanClashHUD"
gui.ResetOnSpawn=false
gui.Parent=player:WaitForChild("PlayerGui")
local frame=Instance.new("Frame")
frame.Name="ClanMatchPanel"
frame.AnchorPoint=Vector2.new(.5,0)
frame.Position=UDim2.new(.5,0,0,22)
frame.Size=UDim2.fromOffset(385,116)
frame.BackgroundColor3=Color3.fromRGB(28,23,47)
frame.BackgroundTransparency=.08
frame.BorderSizePixel=0
frame.Visible=false
frame.Parent=gui
local rounding=Instance.new("UICorner")
rounding.CornerRadius=UDim.new(0,11)
rounding.Parent=frame
local stroke=Instance.new("UIStroke")
stroke.Color=Color3.fromRGB(176,84,192)
stroke.Transparency=.2
stroke.Parent=frame

local title=Instance.new("TextLabel")
title.Name="Title"
title.Position=UDim2.fromOffset(8,4)
title.Size=UDim2.new(1,-16,0,31)
title.Font=Enum.Font.GothamBold
title.TextSize=17
title.TextColor3=Color3.fromRGB(255,204,133)
title.BackgroundTransparency=1
title.Text="CLAN CLASH  /  2v2"
title.Parent=frame
local status=Instance.new("TextLabel")
status.Name="Status"
status.Position=UDim2.fromOffset(10,36)
status.Size=UDim2.new(1,-20,0,40)
status.Font=Enum.Font.GothamMedium
status.TextSize=13
status.TextWrapped=true
status.BackgroundTransparency=1
status.TextColor3=Color3.fromRGB(227,213,248)
status.Parent=frame
local action=Instance.new("TextButton")
action.Name="Action"
action.AnchorPoint=Vector2.new(.5,1)
action.Position=UDim2.new(.5,0,1,-7)
action.Size=UDim2.fromOffset(158,26)
action.BackgroundColor3=Color3.fromRGB(132,46,93)
action.TextColor3=Color3.fromRGB(255,239,249)
action.Font=Enum.Font.GothamBold
action.TextSize=12
action.Parent=frame
local buttonCorner=Instance.new("UICorner")
buttonCorner.CornerRadius=UDim.new(0,7)
buttonCorner.Parent=action

local veil=Instance.new("TextLabel")
veil.Name="ClanVeilfallNotice"
veil.AnchorPoint=Vector2.new(.5,0)
veil.Position=UDim2.new(.5,0,0,143)
veil.Size=UDim2.fromOffset(390,31)
veil.BackgroundColor3=Color3.fromRGB(65,35,100)
veil.BackgroundTransparency=.1
veil.TextColor3=Color3.fromRGB(250,217,250)
veil.Font=Enum.Font.GothamBold
veil.TextSize=13
veil.Visible=false
veil.Parent=gui
local veilCorner=Instance.new("UICorner")
veilCorner.CornerRadius=UDim.new(0,7)
veilCorner.Parent=veil
local veilToken=0
local function showVeil(kind,data)
    veilToken+=1
    local token=veilToken
    if kind=="VeilWarning" or kind=="VeilClosing" then
        local seconds=tonumber(data.seconds) or 6
        veil.Visible=true
        task.spawn(function()
            for left=seconds,1,-1 do
                if veilToken~=token then return end
                veil.Text=kind=="VeilWarning"
                    and ("VEILFALL IN "..left.." — ROUTES WILL OPEN")
                    or ("VEIL CLOSES IN "..left.." — LEAVE THE BRIDGE")
                task.wait(1)
            end
        end)
    else
        veil.Visible=true
        veil.Text=kind=="VeilActive" and "VEILFALL — SPECTRAL BRIDGES ACTIVE"
            or "VEIL SEALED — NORMAL ARENA"
        task.delay(3,function()
            if veilToken==token then veil.Visible=false end
        end)
    end
end

local mode="None"
local token=0
local function show(text,sub,nextMode)
    frame.Visible=true
    title.Text=text
    status.Text=sub
    mode=nextMode or "None"
    action.Visible=mode~="None"
    action.Text=mode=="Queue" and "CANCEL QUEUE" or "FORFEIT MATCH"
end
local function later(seconds,index)
    task.delay(seconds,function()
        if token==index then
            frame.Visible=false
            mode="None"
        end
    end)
end
action.MouseButton1Click:Connect(function()
    if mode=="Queue" then event:FireServer("CancelQueue")
    elseif mode=="Match" then event:FireServer("Forfeit") end
end)
event.OnClientEvent:Connect(function(kind,data)
    data=data or {}
    if kind=="VeilWarning" or kind=="VeilActive"
        or kind=="VeilClosing" or kind=="VeilClosed" then
        showVeil(kind,data)
        return -- preserve round-timer token and team score
    end
    if kind=="MatchEnd" or kind=="RoundResult" then
        veilToken+=1
        veil.Visible=false
    end
    token+=1
    local current=token
    if kind=="Queued" then
        show("CLAN CLASH  /  QUEUED",
            ("Waiting for warriors: %d / %d"):format(data.count or 1,data.need or 4),"Queue")
    elseif kind=="QueueCancelled" then
        show("CLAN CLASH","Queue cancelled.","None")
        later(2,current)
    elseif kind=="QueueBlocked" then
        show("CLAN CLASH","You are already queued in another match mode.","None")
        later(3,current)
    elseif kind=="MatchFound" then
        local a=type(data.teamA)=="table" and table.concat(data.teamA,", ") or "Team A"
        local b=type(data.teamB)=="table" and table.concat(data.teamB,", ") or "Team B"
        show("CLAN CLASH  /  MATCH FOUND",a.."   vs   "..b,"Match")
    elseif kind=="Countdown" then
        show("ROUND "..tostring(data.round or 1).."  /  PREPARE",
            ("Starts in %d  ·  Team score %d : %d"):format(
                data.seconds or 3,data.scoreA or 0,data.scoreB or 0),"Match")
    elseif kind=="RoundStart" then
        show("CLAN CLASH  /  ROUND "..tostring(data.round or 1),
            ("Time %ds  ·  Score %d : %d"):format(
                data.seconds or 80,data.scoreA or 0,data.scoreB or 0),"Match")
        local remaining=data.seconds or 80
        task.spawn(function()
            while remaining>0 and token==current do
                task.wait(1)
                remaining-=1
                if token==current then
                    status.Text=("Time %ds  ·  Score %d : %d"):format(
                        remaining,data.scoreA or 0,data.scoreB or 0)
                end
            end
        end)
    elseif kind=="RoundResult" then
        show("ROUND "..tostring(data.round or 1).."  /  RESULT",
            ("%s wins round  ·  Score %d : %d"):format(
                data.result=="Draw" and "Nobody" or "Team "..tostring(data.result),
                data.scoreA or 0,data.scoreB or 0),"Match")
    elseif kind=="MatchEnd" then
        local winner=data.winner=="Draw" and "DRAW" or ("TEAM "..tostring(data.winner).." WINS")
        show("CLAN CLASH  /  "..winner,
            ("%s  ·  Final %d : %d"):format(
                data.why or "Match over",data.scoreA or 0,data.scoreB or 0),"None")
        later(8,current)
    end
end)
print("[KAGEBOUND] Clan Clash 2v2 HUD ready")
