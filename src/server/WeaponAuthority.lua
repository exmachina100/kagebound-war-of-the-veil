-- Server-only weapon authority. Replicated attributes and locally inserted tools are never authority.
local Players=game:GetService("Players")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KageboundShared")
local Rules=require(Shared:WaitForChild("WeaponRules"))
local Authority={}
local selected={}
local issued={}
function Authority.Get(player)
    if typeof(player)~="Instance" or not player:IsA("Player") or player.Parent~=Players then return nil end
    return selected[player] or Rules.Default
end
function Authority.Select(player,name)
    if not Authority.Get(player) or not Rules.CanSelect(name) then return false end
    selected[player]=name
    player:SetAttribute("KageboundPrimaryWeapon",name) -- display only
    return true
end
function Authority.RegisterTool(player,character,tool,name)
    if Authority.Get(player)~=name or player.Character~=character or not Rules.CanSelect(name)
        or typeof(tool)~="Instance" or not tool:IsA("Tool")
        or tool.Name~="Veilblade" or not tool:FindFirstChild("Handle") then return false end
    issued[player]={character=character,tool=tool,name=name}
    return true
end
function Authority.GetIssuedTool(player,character)
    local record=issued[player]
    if record and record.character==character and player.Character==character then
        return record.tool
    end
    return nil
end
function Authority.ActiveEquipped(player,character)
    local name=Authority.Get(player)
    if name and Authority.IsEquipped(player,character,name) then return name end
    return nil
end
function Authority.IsEquipped(player,character,name)
    local record=issued[player]
    return record~=nil and Authority.Get(player)==name
        and record.name==name and record.character==character
        and player.Character==character and record.tool.Parent==character
        and record.tool.Enabled and record.tool:FindFirstChild("Handle")~=nil
end
function Authority.Reset(player)
    if player.Parent~=Players then return end
    selected[player]=Rules.Default
    issued[player]=nil
    player:SetAttribute("KageboundPrimaryWeapon",Rules.Default)
end
function Authority.ClearTool(player)
    issued[player]=nil
end
Players.PlayerRemoving:Connect(function(player)
    selected[player]=nil
    issued[player]=nil
end)
return Authority
