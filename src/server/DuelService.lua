-- KAGEBOUND duel membership; server-only authority.
local Players=game:GetService("Players")
local Service={}
local members={}
local function mirror(p,r)
    if p.Parent~=Players then return end
    p:SetAttribute("KageboundDuelId",r and r.id or "")
    p:SetAttribute("KageboundDuelPhase",r and r.phase or "None")
end
function Service.Assign(p,id)
    if not p or p.Parent~=Players or members[p] or type(id)~="string" or id=="" then return false end
    members[p]={id=id,phase="Preparing"}
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
    return x~=nil and y~=nil and x.id==y.id and x.phase=="Active" and y.phase=="Active"
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
