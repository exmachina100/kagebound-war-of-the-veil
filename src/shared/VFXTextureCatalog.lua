-- KAGEBOUND imported sprite-sheet slots — deliberately empty until Roblox uploads.
-- Asset PNGs are in the handoff ZIP: KAGEBOUND_VFX_Flipbooks_v01.zip
-- After Studio Asset Manager upload, replace the empty values with owned IDs.
local Catalog={}
Catalog.Images={
    Shinobi="",
    Ronin="",
    Onmyoji="",
    Oni="",
    Kitsune="",
    Tengu="",
    Parry=""
}
Catalog.Files={
    Shinobi="KGB_VFX_Shinobi_Flipbook4x4_v01.png",
    Ronin="KGB_VFX_Ronin_Flipbook4x4_v01.png",
    Onmyoji="KGB_VFX_Onmyoji_Flipbook4x4_v01.png",
    Oni="KGB_VFX_Oni_Flipbook4x4_v01.png",
    Kitsune="KGB_VFX_Kitsune_Flipbook4x4_v01.png",
    Tengu="KGB_VFX_Tengu_Flipbook4x4_v01.png",
    Parry="KGB_VFX_Parry_Flipbook4x4_v01.png"
}
function Catalog.Resolve(name)
    local value=Catalog.Images[name]
    if typeof(value)~="string" then return nil end
    local digits=value:match("^rbxassetid://(%d+)$") or value:match("^(%d+)$")
    if not digits then return nil end
    local id=tonumber(digits)
    if not id or id<1 or id==math.huge then return nil end
    return "rbxassetid://"..digits
end
return Catalog
