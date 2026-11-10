-- Server-only weapon authority. Never read replicated player attributes for damage rights.
local Players = game:GetService("Players")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("KageboundShared")
local Rules = require(Shared:WaitForChild("WeaponRules"))
local Authority = {}
local selected = {}
function Authority.Get(player)
    if typeof(player) ~= "Instance" or not player:IsA("Player") or player.Parent ~= Players then
        return nil
    end
    return selected[player] or Rules.Default
end
function Authority.Select(player, name)
    if Authority.Get(player) == nil or not Rules.CanSelect(name) then return false end
    selected[player] = name
    player:SetAttribute("KageboundPrimaryWeapon", name) -- display only
    return true
end
function Authority.IsEquipped(player, character, name)
    if Authority.Get(player) ~= name or player.Character ~= character then return false end
    -- A selected weapon is not sufficient: the server-created tool must be held.
    local tool = character and character:FindFirstChild("Veilblade")
    return name == "Katana" and tool ~= nil and tool:IsA("Tool")
        and tool.Enabled and tool:FindFirstChild("Handle") ~= nil
end
function Authority.Reset(player)
    if player.Parent ~= Players then return end
    selected[player] = Rules.Default
    player:SetAttribute("KageboundPrimaryWeapon", Rules.Default)
end
Players.PlayerRemoving:Connect(function(player) selected[player] = nil end)
return Authority
