-- KAGEBOUND duel membership; server-only authority.
local Players=game:GetService("Players")
local Service={}
local members={}
local function mirror(p,r)
    if p.Parent~=Players then return end
    p:SetAttribute("KageboundDuelId",r and r.id or "")
    p:SetAttribute("KageboundDuelPhase",r and r.phase or "None")
    p:SetAttribute("KageboundMatchTeam",r and r.team or "")
    p:SetAttribute("KageboundMatchMode",r and r.mode or "")
end
function Service.Assign(p,id,team)
    if not p or p.Parent~=Players or members[p] or type(id)~="string" or id=="" then return false end
    if team~=nil and team~="A" and team~="B" then return false end
    members[p]={id=id,phase="Preparing",team=team,mode=team and "ClanClash" or "ShadowDuel"}
    mirror(p,members[p])
    return true
end
function Service.SetPhase(p,id,phase)
    local r=members[p]
    if not r or r.id~=id then return false end
    if not table.find({"Preparing","Countdown","Active","Intermission","Finished"},phase) then return false end
    r.phase=phase
    mirror(p,r)
    return true
end
function Service.IsParticipant(p)
    return members[p]~=nil
end
function Service.CanAct(p)
    local r=members[p]
    return r==nil or r.phase=="Active"
end
function Service.CanDamage(a,b)
    if a==b then return false end
    local x,y=members[a],members[b]
    if not x and not y then return true end
    if not x or not y or x.id~=y.id or x.phase~="Active" or y.phase~="Active" then
        return false
    end
    -- Legacy 1v1 players have no team; Clan Clash requires opposing teams.
    if x.team or y.team then
        return x.team~=nil and y.team~=nil and x.team~=y.team
    end
    return true
end
function Service.Clear(p,id)
    local r=members[p]
    if not r or (id and r.id~=id) then return false end
    members[p]=nil
    mirror(p,nil)
    return true
end
Players.PlayerRemoving:Connect(function(p) members[p]=nil end)
return Service
