-- KAGEBOUND world atlas: original Japanese mythology, approved ART-001..004.
-- Layout is scalable; zones are connected by traversable ground and roads.
local World = {}
World.Enabled = true
World.Seed = 260911
World.TileSize = 120
World.Origin = Vector3.new(0, 0, 0)
World.Zones = {
    {id="KageDojo",name="Kage Dojo",x=0,z=0,radius=290,tint=Color3.fromRGB(65,69,86),accent=Color3.fromRGB(236,170,106),level=1,kind="SafeHub"},
    {id="MoonfallBamboo",name="Moonfall Bamboo",x=0,z=-780,radius=310,tint=Color3.fromRGB(45,86,74),accent=Color3.fromRGB(228,92,164),level=1,kind="Wilderness"},
    {id="ShogunLastCity",name="Shogun's Last City",x=760,z=-240,radius=340,tint=Color3.fromRGB(78,67,91),accent=Color3.fromRGB(181,71,113),level=8,kind="City"},
    {id="FrozenShrine",name="Frozen Shrine",x=-770,z=-300,radius=320,tint=Color3.fromRGB(123,171,197),accent=Color3.fromRGB(147,208,243),level=15,kind="Highlands"},
    {id="YomiRift",name="Yomi Rift",x=650,z=740,radius=320,tint=Color3.fromRGB(68,53,103),accent=Color3.fromRGB(176,93,237),level=25,kind="SpiritWilds"}
}
World.Routes = {
    {"KageDojo","MoonfallBamboo"},
    {"KageDojo","ShogunLastCity"},
    {"KageDojo","FrozenShrine"},
    {"ShogunLastCity","YomiRift"}
}
World.Palette = {
    ink=Color3.fromRGB(32,35,56),
    vermilion=Color3.fromRGB(154,47,72),
    stone=Color3.fromRGB(83,86,108),
    warm=Color3.fromRGB(250,182,107),
    spirit=Color3.fromRGB(169,91,228),
    moon=Color3.fromRGB(206,188,245)
}
return World
