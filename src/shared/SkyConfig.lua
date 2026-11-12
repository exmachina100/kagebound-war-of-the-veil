-- KAGEBOUND custom world sky configuration.
-- Supply six SEAMLESS cubemap faces after Roblox upload/moderation.
-- Never use concept-board panels or invented asset IDs as a skybox.
return {
    Preset = "MoonfallNight",
    -- ART-001/004: readable indigo moonlight, with warm local lanterns.
    Lighting = {
        ClockTime = 0.8,
        Brightness = 3,
        ExposureCompensation = 0.65,
        Ambient = Color3.fromRGB(78, 71, 112),
        OutdoorAmbient = Color3.fromRGB(104, 100, 148),
        EnvironmentDiffuseScale = 0.65,
        EnvironmentSpecularScale = 0.5,
    },
    Faces = {
        -- Read directly from free Creator Store Sky 14828385099
        -- (MelinoucheGirl2); all six faces inspected in Studio, no embedded code.
        Bk = 6285719338, Dn = 6285721078, Ft = 6285722964,
        Lf = 6285724682, Rt = 6285726335, Up = 6285730635,
    },
    Atmosphere = {
        Color = Color3.fromRGB(101, 88, 150),
        Decay = Color3.fromRGB(38, 34, 77),
        Density = 0.24,
        Haze = 1.2,
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
