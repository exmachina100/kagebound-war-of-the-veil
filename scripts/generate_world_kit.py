"""KAGEBOUND Moonfall + Kage Dojo modular architectural kit.

Original low-poly editable procedural source. Generates glTF/GLB and OBJ files
with authored materials; NOT a finished Studio import. Unit convention: 1 unit
= 1 Roblox stud. Y up, object pivot at local ground center.
"""
from pathlib import Path
import math
import trimesh
import numpy as np

OUT = Path("assets/world/dojo-moonfall/v01")
OUT.mkdir(parents=True, exist_ok=True)
PALETTE = {
    "ink": [36, 35, 53, 255], "roof": [62, 48, 78, 255],
    "wood": [86, 53, 47, 255], "vermillion": [155, 47, 72, 255],
    "gold": [250, 182, 107, 255], "stone": [92, 90, 113, 255],
    "ivory": [234, 219, 231, 255], "bamboo": [49, 91, 72, 255],
    "leaf": [67, 115, 82, 255],
}
def box(extents, pos, color):
    m = trimesh.creation.box(extents=extents)
    m.apply_translation(pos)
    m.visual.vertex_colors = PALETTE[color]
    return m
def cyl(radius, height, pos, color, sections=10):
    m = trimesh.creation.cylinder(radius=radius, height=height, sections=sections)
    m.apply_transform(trimesh.transformations.rotation_matrix(math.pi/2, [1,0,0]))
    m.apply_translation(pos)
    m.visual.vertex_colors = PALETTE[color]
    return m
def beam(a,b,radius,color,sections=8):
    a,b=np.array(a,dtype=float),np.array(b,dtype=float)
    d=b-a
    m=trimesh.creation.cylinder(radius=radius,height=float(np.linalg.norm(d)),sections=sections)
    m.apply_transform(trimesh.geometry.align_vectors([0,0,1],d))
    m.apply_translation((a+b)/2)
    m.visual.vertex_colors=PALETTE[color]
    return m
def export(name, meshes):
    scene=trimesh.Scene()
    for i,m in enumerate(meshes):
        scene.add_geometry(m,geom_name=f"{name}_{i:02d}")
    scene.export(OUT/f"{name}.glb")
    # OBJ fallback preserves distinct geometry but vertex colors depend on importer.
    (OUT/f"{name}.obj").write_text(trimesh.exchange.obj.export_obj(scene, include_color=True))
    triangles=sum(len(m.faces) for m in meshes)
    return {"name":name,"parts":len(meshes),"triangles":triangles,
            "glb":f"{name}.glb","obj":f"{name}.obj","pivot":"ground-center","units":"studs"}

assets=[]
# 1. Torii: double vermillion posts, lintel, curved visual ridge and gold caps
parts=[box([0.75,9,0.75],[-5,4.5,0],"vermillion"),
       box([0.75,9,0.75],[5,4.5,0],"vermillion"),
       box([12.5,0.85,1.15],[0,8.7,0],"vermillion"),
       box([10.7,0.5,0.75],[0,6.8,0],"wood"),
       box([1.25,0.25,1.25],[-5,9,0],"gold"),
       box([1.25,0.25,1.25],[5,9,0],"gold"),
       beam([-6.8,9.3,0],[0,10.05,0],0.33,"ink"),
       beam([0,10.05,0],[6.8,9.3,0],0.33,"ink")]
assets.append(export("moonfall_torii",parts))
# 2. Stone lantern: plinth, column, light housing and tiered cap
parts=[box([2.3,0.45,2.3],[0,0.225,0],"stone"),
       box([0.75,3.4,0.75],[0,2.05,0],"stone"),
       box([2.1,0.3,2.1],[0,3.85,0],"stone"),
       box([1.5,1.35,1.5],[0,4.65,0],"gold"),
       box([2.35,0.4,2.35],[0,5.55,0],"ink"),
       box([1.1,0.65,1.1],[0,6.05,0],"roof")]
assets.append(export("shrine_stone_lantern",parts))
# 3. Bamboo cluster: segmented stalks and stylized tapered leaves
parts=[]
for j,(x,z,h) in enumerate([(-1.6,0,12),(0.3,0.8,15),(1.7,-0.6,10),(-0.4,-1.1,13)]):
    parts.append(cyl(0.18,h,[x,h/2,z],"bamboo",8))
    for k in range(2,int(h//2)+1):
        parts.append(cyl(0.24,0.11,[x,k*2,z],"gold",8))
    for y in (h*0.62,h*0.82,h*0.95):
        for sign in (-1,1):
            parts.append(beam([x,y,z],[x+sign*2.4,y+0.65,z+0.55],0.09,"leaf",5))
assets.append(export("moonfall_bamboo_cluster",parts))
# 4. Modular shrine deck and roof, with layered eaves
parts=[box([14,0.9,10],[0,0.45,0],"stone"),
       box([11,0.5,7],[0,1.15,0],"wood")]
for x in (-4.5,4.5):
    for z in (-2.7,2.7):
        parts.append(box([0.7,6,0.7],[x,4.4,z],"vermillion"))
for sign in (-1,1):
    parts.append(beam([0,8.2,-5.6],[sign*7.5,6.9,-5.6],0.65,"roof"))
    parts.append(beam([0,8.2,5.6],[sign*7.5,6.9,5.6],0.65,"roof"))
parts += [box([14.7,0.5,12],[0,7.1,0],"roof"),
          box([10,0.5,0.5],[0,7.8,-5.2],"gold"),
          box([3,3,0.35],[0,3,-3.55],"ivory")]
assets.append(export("kage_dojo_shrine_module",parts))
# 5. Modular footbridge
parts=[box([5,0.65,14],[0,2.2,0],"wood")]
for x in (-2.25,2.25):
    for z in (-6,-3,0,3,6):
        parts.append(box([0.25,2.5,0.25],[x,3.55,z],"vermillion"))
    parts.append(box([0.3,0.3,14.5],[x,4.8,0],"gold"))
for z in range(-6,7,2):
    parts.append(box([5.4,0.12,0.15],[0,2.6,z],"ink"))
assets.append(export("moonfall_bridge",parts))
# 6. Path stones
parts=[]
for i in range(9):
    x=((i*7)%5-2)*0.42
    z=(i-4)*2.2
    parts.append(box([2.6+(i%3)*0.25,0.32,1.75],[x,0.16,z],"stone"))
assets.append(export("moonfall_stone_path",parts))
# 7. Shrine banner post
parts=[box([0.25,8,0.25],[0,4,0],"wood"),
       box([0.18,5.3,2.5],[0.2,5,0],"vermillion"),
       box([0.22,0.2,3],[0.22,7.75,0],"gold"),
       box([0.12,0.12,1.6],[0.35,5.5,0],"ivory")]
assets.append(export("dojo_clan_banner",parts))
# 8. Stepped shrine altar
parts=[box([7,0.7,5],[0,0.35,0],"stone"),
       box([5.8,0.7,4],[0,1.05,0],"stone"),
       box([4.5,0.7,3],[0,1.75,0],"stone"),
       box([3,0.5,2],[0,2.35,0],"wood"),
       box([1.5,2,0.4],[0,3.5,-0.4],"ivory"),
       box([2,0.22,0.6],[0,4.6,-0.4],"gold")]
assets.append(export("dojo_ritual_altar",parts))
import json
(OUT/"manifest.json").write_text(json.dumps({"version":"v01","style":"ART-001/004","assetCount":len(assets),
    "status":"procedural mesh draft, Studio import unverified",
    "collision":"Create separate simple Roblox collision proxies; do not use mesh collision for gameplay authority",
    "assets":assets},indent=2)+"\n")
print("Exported",len(assets),"editable low-poly architectural assets")
