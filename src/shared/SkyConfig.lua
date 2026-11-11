-- KAGEBOUND custom world sky configuration.
-- Supply six SEAMLESS cubemap faces after Roblox upload/moderation.
-- Never use concept-board panels or invented asset IDs as a skybox.
return {
    Preset = "MoonfallNight",
    Faces = {
        Bk = 0, Dn = 0, Ft = 0, Lf = 0, Rt = 0, Up = 0,
    },
    Atmosphere = {
        Color = Color3.fromRGB(101, 88, 150),
        Decay = Color3.fromRGB(38, 34, 77),
        Density = 0.32,
        Haze = 1.7,
        Glare = 0.05,
    },
    Veilfall = {
        Color = Color3.fromRGB(140, 72, 194),
        Decay = Color3.fromRGB(49, 23, 85),
        Density = 0.40,
        Haze = 2.1,
        Glare = 0.08,
    },
}
