-- KAGEBOUND Shadow Duel HUD — ART-001/004, server-authored match state.
-- Display-only except queue cancel and explicit player forfeit requests.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
local event=ReplicatedStorage:WaitForChild("KageboundShadowDuel")
local gui=Instance.new("ScreenGui")
gui.Name="KageboundShadowDuelHUD"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.Parent=player:WaitForChild("PlayerGui")

local card=Instance.new("Frame")
card.Name="MatchPanel"
card.AnchorPoint=Vector2.new(.5,0)
card.Position=UDim2.new(.5,0,0,24)
card.Size=UDim2.new(0,370,0,118)
card.BackgroundColor3=Color3.fromRGB(25,22,46)
card.BackgroundTransparency=.07
card.BorderSizePixel=0
card.Visible=false
card.Parent=gui
local round=Instance.new("UICorner")
round.CornerRadius=UDim.new(0,12)
round.Parent=card
local border=Instance.new("UIStroke")
border.Color=Color3.fromRGB(175,95,233)
border.Thickness=1.5
border.Parent=card

local title=Instance.new("TextLabel")
title.Name="Title"
title.Size=UDim2.new(1,-20,0,30)
title.Position=UDim2.fromOffset(10,7)
title.BackgroundTransparency=1
title.TextColor3=Color3.fromRGB(255,205,133)
title.Font=Enum.Font.GothamBold
title.TextSize=18
title.Text="SHADOW DUEL"
title.Parent=card
local message=Instance.new("TextLabel")
message.Name="Status"
message.Size=UDim2.new(1,-20,0,43)
message.Position=UDim2.fromOffset(10,35)
message.BackgroundTransparency=1
message.TextColor3=Color3.fromRGB(232,216,244)
message.Font=Enum.Font.GothamMedium
message.TextSize=15
message.TextWrapped=true
message.Text="Waiting for another warrior..."
message.Parent=card
local action=Instance.new("TextButton")
action.Name="Action"
action.AnchorPoint=Vector2.new(.5,1)
action.Position=UDim2.new(.5,0,1,-9)
action.Size=UDim2.fromOffset(135,27)
action.BackgroundColor3=Color3.fromRGB(117,39,82)
action.TextColor3=Color3.fromRGB(253,238,244)
action.Font=Enum.Font.GothamBold
action.TextSize=12
action.Text="CANCEL QUEUE"
action.Parent=card
local buttonCorner=Instance.new("UICorner")
buttonCorner.CornerRadius=UDim.new(0,7)
buttonCorner.Parent=action

-- Separate Veilfall notice: does not reset the round timer HUD.
local veilNote=Instance.new("TextLabel")
veilNote.Name="DuelVeilfallNotice"
veilNote.AnchorPoint=Vector2.new(.5,0)
veilNote.Position=UDim2.new(.5,0,0,151)
veilNote.Size=UDim2.new(.76,0,0,37)
veilNote.BackgroundColor3=Color3.fromRGB(60,29,100)
veilNote.BackgroundTransparency=.08
veilNote.TextColor3=Color3.fromRGB(248,208,245)
veilNote.TextScaled=true
veilNote.Font=Enum.Font.GothamBold
veilNote.Visible=false
veilNote.Parent=gui
local veilCorner=Instance.new("UICorner")
veilCorner.CornerRadius=UDim.new(0,9)
veilCorner.Parent=veilNote
local veilSequence=0
local function showVeil(eventName,data)
    veilSequence+=1
    local current=veilSequence
    if eventName=="VeilWarning" or eventName=="VeilClosing" then
        local seconds=tonumber(data.seconds) or 6
        veilNote.Visible=true
        task.spawn(function()
            for remaining=seconds,1,-1 do
                if veilSequence~=current then return end
                veilNote.Text=eventName=="VeilWarning"
                    and ("VEILFALL IN "..remaining.." — ROUTES WILL OPEN")
                    or ("VEIL SEALS IN "..remaining.." — LEAVE THE PLATFORMS")
                task.wait(1)
            end
        end)
    else
        veilNote.Visible=true
        veilNote.Text=eventName=="VeilActive"
            and "VEILFALL — SPECTRAL ROUTES OPEN"
            or "VEIL SEALED — NORMAL ARENA"
        task.delay(3,function()
            if veilSequence==current then veilNote.Visible=false end
        end)
    end
end

local mode="None"
local token=0
local function show(head,body,buttonMode)
    card.Visible=true
    title.Text=head
    message.Text=body
    mode=buttonMode or "None"
    action.Visible=mode~="None"
    action.Text=mode=="Queue" and "CANCEL QUEUE" or "FORFEIT DUEL"
end
action.MouseButton1Click:Connect(function()
    if mode=="Queue" then
        event:FireServer("CancelQueue")
    elseif mode=="Duel" then
        event:FireServer("Forfeit")
    end
end)
local function dismissAfter(seconds,thisToken)
    task.delay(seconds,function()
        if token==thisToken then
            card.Visible=false
            mode="None"
        end
    end)
end

event.OnClientEvent:Connect(function(eventName,data)
    data=data or {}
    if eventName=="VeilWarning" or eventName=="VeilActive"
        or eventName=="VeilClosing" or eventName=="VeilClosed" then
        showVeil(eventName,data)
        return
    end
    if eventName=="MatchEnd" or eventName=="RoundResult" then
        veilSequence+=1
        veilNote.Visible=false
    end
    token+=1
    local thisToken=token
    if eventName=="Queued" then
        show("SHADOW DUEL","In the 1v1 queue. Waiting for an opponent...","Queue")
    elseif eventName=="QueueCancelled" then
        show("SHADOW DUEL","Queue cancelled.","None")
        dismissAfter(3,thisToken)
    elseif eventName=="QueueBlocked" then
        show("SHADOW DUEL","Already queued for another match mode.","None")
        dismissAfter(3,thisToken)
    elseif eventName=="MatchFound" then
        show("MATCH FOUND","Preparing the Veilbound arena...","Duel")
    elseif eventName=="Countdown" then
        show("ROUND "..tostring(data.round or 1),
            ("Begins in %d  |  Score: %d - %d"):format(
                data.seconds or 3,data.scoreA or 0,data.scoreB or 0),"Duel")
    elseif eventName=="RoundStart" then
        show("FIGHT — ROUND "..tostring(data.round or 1),
            ("Time: %ds  |  Score: %d - %d"):format(
                data.duration or 70,data.scoreA or 0,data.scoreB or 0),"Duel")
        local remaining=data.duration or 70
        task.spawn(function()
            while remaining>0 and token==thisToken do
                task.wait(1)
                remaining-=1
                if token==thisToken then
                    message.Text=("Time: %ds  |  Score: %d - %d"):format(
                        remaining,data.scoreA or 0,data.scoreB or 0)
                end
            end
        end)
    elseif eventName=="RoundResult" then
        local status=data.result=="Draw" and "Round drawn"
            or ("Point to warrior "..tostring(data.result))
        show("ROUND "..tostring(data.round or 1).." RESULT",
            ("%s  |  Score: %d - %d"):format(
                status,data.scoreA or 0,data.scoreB or 0),"Duel")
    elseif eventName=="MatchEnd" then
        show("SHADOW DUEL RESULT",
            ("%s — %s  |  Final %d - %d"):format(
                data.winnerName or "DRAW",data.reason or "Complete",
                data.scoreA or 0,data.scoreB or 0),"None")
        dismissAfter(8,thisToken)
    end
end)
print("[KAGEBOUND] Shadow Duel HUD waiting for queue and match messages")
