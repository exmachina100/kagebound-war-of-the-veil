-- Edit-mode regression harness. Run through Studio MCP/Command Bar with:
-- local test=loadstring(TEST_FILE_CONTENTS)(); return test(game.ServerScriptService.KageboundServer.Veilblade.Source)
-- Factories are extracted before player hooks; all test instances are destroyed.
return function(source)
    local factorySource=assert(source:match("(local INK.-)%-%- Optional real Studio%-imported"),"Factory boundary missing")
    local factory=assert(loadstring(factorySource.."\nreturn createKatana"))()
    local tools={}
    local function make(name) local tool=factory(name);table.insert(tools,tool);return tool end
    local ok,result=pcall(function()
        local katana=make("Katana")
        for name,scale in pairs({Tanto=.58,Nodachi=1.35}) do
            local tool=make(name)
            for _,part in ipairs(katana:GetChildren()) do
                if part:IsA("BasePart") then
                    local actual=assert(tool:FindFirstChild(part.Name))
                    assert(math.abs(actual.Size.Y-part.Size.Y*scale)<.0001,name.." size "..part.Name)
                    local original=katana.Handle.CFrame:PointToObjectSpace(part.Position)
                    local position=tool.Handle.CFrame:PointToObjectSpace(actual.Position)
                    assert(math.abs(position.Y-original.Y*scale)<.0001,name.." offset "..part.Name)
                end
            end
        end
        for name,bladeName in pairs({Naginata="NaginataEdge",Yari="YariSpearhead",Katana="BladeVeilEdge",Tanto="BladeVeilEdge",Nodachi="BladeVeilEdge"}) do
            local tool=make(name)
            local trail=assert(tool:FindFirstChild("VeilbladeTrail",true))
            local blade=assert(tool:FindFirstChild(bladeName))
            for _,attachment in ipairs({trail.Attachment0,trail.Attachment1}) do
                assert(attachment.Parent==blade,name.." trail uses wrong blade")
                assert(math.abs(attachment.Position.Y)<=blade.Size.Y*.5,name.." trail outside blade")
            end
            for _,part in ipairs(tool:GetDescendants()) do
                if part:IsA("BasePart") then
                    assert(not part.Anchored and not part.CanCollide and not part.CanTouch and not part.CanQuery and part.Massless,name.." unsafe cosmetic part")
                end
            end
        end
        local storage=Instance.new("Folder");table.insert(tools,storage)
        local art=Instance.new("Folder");art.Name="KageboundArt";art.Parent=storage
        local reference=Instance.new("Model");reference.Name="VeilbladeVisual";reference.Parent=art
        local part=Instance.new("Part");part.Anchored=true;part.Parent=reference
        local embedded=Instance.new("Script");embedded.Parent=reference
        local importedSource=assert(source:match("(local function applyImportedVisual.-)local function equip"),"Import boundary missing")
        local apply=assert(loadstring("return function(ServerStorage) "..importedSource.." return applyImportedVisual end"))()(storage)
        local tool=make("Katana")
        assert(apply(tool,"Katana"),"Import rejected valid geometry")
        assert(embedded.Parent==reference,"Sanitizing clone modified source template")
        local clone=assert(tool:FindFirstChild("VeilbladeVisual"))
        for _,item in ipairs(clone:GetDescendants()) do
            assert(not item:IsA("LuaSourceContainer"),"Imported executable survived")
            if item:IsA("BasePart") then
                assert(not item.Anchored and not item.CanCollide and not item.CanTouch and not item.CanQuery and item.Massless,"Unsafe imported cosmetic")
                assert(item:FindFirstChild("VeilbladeVisualWeld"),"Imported part unwelded")
            end
        end
        return "PASS: proportional sword geometry; five weapon trail anchors; cosmetic physics; detached import sanitation"
    end)
    for _,tool in ipairs(tools) do tool:Destroy() end
    assert(ok,result)
    return result
end
