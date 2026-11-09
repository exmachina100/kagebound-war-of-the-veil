-- KAGEBOUND class VFX bible data — visual-only, never authorizes combat.
-- Exact source PNG paths are already committed under assets/concept-sheets.
-- Six abilities per class are ART DIRECTION proposals, not gameplay-complete moves.
local Profiles={}

Profiles.Classes={
    Shinobi={
        texture="Shinobi",
        core=Color3.fromRGB(237,73,139),edge=Color3.fromRGB(168,71,234),
        defense=Color3.fromRGB(132,215,252),
        motif="Crimson fox / razor crescent / ribbon afterimage",
        board="assets/concept-sheets/clan-vfx-v01/KGB_VFX_Shinobi_ConceptSheet_v01.png",
        abilities={"Veil Slash","Shadow Dash","Parry Burst","Fox Veil Illusion","Cross-Cut","Veil Release"}
    },
    Ronin={
        texture="Ronin",
        core=Color3.fromRGB(113,203,252),edge=Color3.fromRGB(175,160,249),
        defense=Color3.fromRGB(218,241,255),
        motif="Moon crescent / crystalline clash / clean iai ribbon",
        board="assets/concept-sheets/clan-vfx-v01/KGB_VFX_Ronin_ConceptSheet_v01.png",
        abilities={"Crescent Draw","Wind Step","Moon Guard","Rising Tide Cut","Cross Moon","Full Moon Execution"}
    },
    Onmyoji={
        texture="Onmyoji",
        core=Color3.fromRGB(183,116,249),edge=Color3.fromRGB(246,201,119),
        defense=Color3.fromRGB(221,197,255),
        motif="Ofuda seal / violet spirit ring / sacred paper orbit",
        board="assets/concept-sheets/clan-vfx-v01/KGB_VFX_Onmyoji_ConceptSheet_v01.png",
        abilities={"Ofuda Barrage","Spirit Step","Barrier Ward","Seal Prison","Divine Exorcism","Veil Liturgy"}
    },
    ["Oni Disciple"]={
        texture="Oni",
        core=Color3.fromRGB(239,72,88),edge=Color3.fromRGB(165,79,219),
        defense=Color3.fromRGB(255,179,125),
        motif="Horn fracture / black-red shockwave / chain sparks",
        board="assets/concept-sheets/clan-vfx-v01/KGB_VFX_OniDisciple_ConceptSheet_v01.png",
        abilities={"Hell Cleave","Rage Charge","Oni Guard Break","Chain Reaver","Demon Breaker","Wrath of the Veil"}
    }
}

Profiles.Masks={
    Kitsune={core=Color3.fromRGB(252,114,184),edge=Color3.fromRGB(216,182,255),
        motif="Fox phantom / pink decoy / spectral petal"},
    Oni={core=Color3.fromRGB(239,59,82),edge=Color3.fromRGB(255,143,88),
        motif="Fractured crater / crimson horn / radial rupture"},
    Tengu={core=Color3.fromRGB(135,226,255),edge=Color3.fromRGB(183,151,249),
        motif="Wind ribbons / cyan feather / rising spiral"}
}

function Profiles.Get(name)
    return Profiles.Classes[name] or Profiles.Classes.Shinobi
end
function Profiles.GetMask(name)
    return Profiles.Masks[name]
end
return Profiles
