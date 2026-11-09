-- KAGEBOUND Dojo training QA (run in Studio SERVER Command Bar during Play).
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local World=require(ReplicatedStorage.KageboundShared.WorldConfig)
assert(World.Enabled,"Grand World mode must be active")
assert(World.TrainingGrounds and World.TrainingGrounds.radius>15,
    "Training circle must be configured")
local folder=workspace:WaitForChild("KageboundTraining",30)
assert(folder,"No KageboundTraining folder")
local count=0
for _,model in ipairs(folder:GetChildren()) do
    if model:IsA("Model") and model:GetAttribute("KageboundTrainingTarget") then
        count+=1
        assert((model:GetAttribute("MaxHealth") or 0)>0,"Missing practice health")
        assert(model.PrimaryPart~=nil,"Missing target root")
        for _,part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                assert(part.CanCollide==false,"Training dummy unexpectedly collides")
            end
        end
    end
end
assert(count==3,"Expected three Kage Dojo practice targets")
print("[KAGEBOUND DOJO PASS] 3 safe practice targets present")

-- Manual multiplayer check is still required: both players stand in the safe
-- zone near these targets; sword swings should damage only dummies, never players.
