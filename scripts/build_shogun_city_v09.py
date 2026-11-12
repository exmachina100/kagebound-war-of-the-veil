"""KAGEBOUND v09 Shogun's Last City architectural set.
Original modular geometry with per-material UVs, textured GLB, editable OBJ,
LOD0/LOD1, collider metadata. Roblox Studio import and visual approval pending.
"""
import json, math, random
from pathlib import Path
import numpy as np
import trimesh
from PIL import Image, ImageDraw
from trimesh.visual.texture import TextureVisuals
from trimesh.visual.material import PBRMaterial
random.seed(909)
OUT=Path("assets/world/shogun_last_city/v09");OUT.mkdir(parents=True,exist_ok=True)
PALETTE={"charcoal":(40,43,61),"plaster":(209,199,185),"vermillion":(150,46,66),
"agedwood":(94,66,58),"bronze":(183,134,81),"tile":(54,67,85),
"moss":(67,102,83),"paper":(234,215,176),"stone":(103,103,113)}
TEXTURES={}
for name,c in PALETTE.items():
 im=Image.new("RGB",(256,256),c);d=ImageDraw.Draw(im)
 for i in range(480):
  x=random.randrange(256);y=random.randrange(256);v=random.randrange(-22,23)
  color=tuple(max(0,min(255,a+v)) for a in c)
  if name in ("agedwood","tile"):d.line((x,y,x+random.randrange(4,44),y+random.randrange(-2,3)),fill=color,width=1)
  elif name=="stone":d.line((x,y,x+random.randrange(4,18),y+random.randrange(3,11)),fill=color,width=1)
  else:d.point((x,y),fill=color)
 im.save(OUT/(name+"_albedo.png"));TEXTURES[name]=im
def mat(mesh,name):
 v=mesh.vertices
 uv=np.column_stack((((v[:,0]+v[:,2]*.35)*.19)%1,((v[:,1]+v[:,2]*.22)*.19)%1))
 mesh.visual=TextureVisuals(uv=uv,material=PBRMaterial(name=name,baseColorTexture=TEXTURES[name],roughnessFactor=.84,metallicFactor=.05))
 return mesh
def box(p,size,center,m,detail=0):
 mesh=trimesh.creation.box(extents=size);mesh.apply_translation(center);p.append((mat(mesh,m),detail))
def rod(p,a,b,r,m,detail=0,sections=8):
 a=np.array(a,dtype=float);b=np.array(b,dtype=float);v=b-a
 mesh=trimesh.creation.cylinder(radius=r,height=float(np.linalg.norm(v)),sections=sections)
 mesh.apply_transform(trimesh.geometry.align_vectors([0,0,1],v));mesh.apply_translation((a+b)/2)
 p.append((mat(mesh,m),detail))
def roof(p,w,d,y,detail=0):
 # Continuous hip roof with swept eaves; not a stack of cubes.
 verts=[];faces=[]
 for z in np.linspace(-d/2,d/2,7):
  for x in np.linspace(-w/2,w/2,11):
   nx=abs(x)/(w/2);nz=abs(z)/(d/2)
   height=y+2.15*(1-max(nx,nz)**1.55)-.34*(max(nx,nz)**6)
   verts.append((x,height,z))
 for j in range(6):
  for i in range(10):
   a=j*11+i;faces.extend(((a,a+1,a+11),(a+1,a+12,a+11)))
 mesh=trimesh.Trimesh(vertices=verts,faces=faces,process=False)
 p.append((mat(mesh,"tile"),detail))
 for z in (-d/2,d/2):
  rod(p,(-w/2,y-.2,z),(w/2,y-.2,z),.12,"bronze",detail+1)
def gate():
 p=[]
 for x in (-4.4,4.4):
  box(p,(.9,7,.9),(x,3.5,0),"vermillion")
  box(p,(1.4,.6,1.4),(x,.3,0),"stone")
 box(p,(11,.7,2),(0,6.8,0),"agedwood");roof(p,12,4,7.3)
 for x in (-3.5,3.5):box(p,(.28,3.5,.25),(x,4.8,-.65),"bronze",1)
 return p,[{"type":"box","center":[-4.4,3.5,0],"size":[1,7,1]},{"type":"box","center":[4.4,3.5,0],"size":[1,7,1]}]
def tower():
 p=[]
 for floor in range(3):
  y=floor*5
  box(p,(8-floor*.8,4.6,8-floor*.8),(0,y+2.3,0),"plaster")
  for x in (-3+floor*.3,3-floor*.3):
   for z in (-3+floor*.3,3-floor*.3):rod(p,(x,y,z),(x,y+4.6,z),.22,"agedwood")
  roof(p,10-floor*.7,10-floor*.7,y+4.8)
  for x in (-2,0,2):box(p,(.9,1.7,.08),(x,y+2.7,-4+floor*.4),"charcoal",1)
 rod(p,(0,15,0),(0,18,0),.15,"bronze",1)
 return p,[{"type":"box","center":[0,7.5,0],"size":[8,15,8]}]
def wall():
 p=[]
 box(p,(15,6,1.8),(0,3,0),"plaster")
 box(p,(15.8,.65,2.3),(0,6.1,0),"agedwood")
 roof(p,16.5,3.2,6.5)
 for x in (-7.3,7.3):box(p,(1,6,2),(x,3,0),"stone")
 for x in (-5,-2.5,0,2.5,5):box(p,(.9,.45,.12),(x,4.1,-.98),"charcoal",1)
 return p,[{"type":"box","center":[0,3,0],"size":[15,6,1.8]}]
def watchpost():
 p=[]
 for x in (-2.3,2.3):
  for z in (-2.3,2.3):rod(p,(x,0,z),(x,8,z),.28,"agedwood")
 box(p,(6,.35,6),(0,6.5,0),"agedwood");roof(p,7.5,7.5,8)
 for x in (-2.3,2.3):
  rod(p,(x,6.7,-2.3),(x,7.8,-2.3),.13,"bronze",1)
 return p,[{"type":"box","center":[0,3.25,0],"size":[6,6.5,6]}]
def shop():
 p=[]
 box(p,(7,4.5,6),(0,2.25,0),"plaster")
 roof(p,8.5,7,4.65)
 for x in (-2.5,2.5):box(p,(.3,4.2,.3),(x,2.1,-3.05),"agedwood")
 for x in (-1.8,0,1.8):box(p,(1.45,2.3,.12),(x,2,-3.1),"paper",1)
 box(p,(5,.4,1.8),(0,.4,-3.6),"agedwood")
 return p,[{"type":"box","center":[0,2.25,0],"size":[7,4.5,6]}]
def stair():
 p=[]
 for i in range(10):
  z=-5+i
  box(p,(6,.5,1.1),(0,.25+i*.35,z),"stone")
 for x in (-3.2,3.2):
  for i in range(6):
   z=-5+i*2;rod(p,(x,.6+i*.7,z),(x,1.7+i*.7,z),.1,"vermillion",1)
 return p,[{"type":"box","center":[0,2,0],"size":[6,4,10]}]
def canal_bridge():
 p=[]
 for i in range(17):
  z=-8+i;y=1.1+2*(1-(z/8)**2)
  box(p,(5,.2,.9),(0,y,z),"agedwood")
 for x in (-2.6,2.6):
  for i in range(9):
   z=-8+i*2;y=1.1+2*(1-(z/8)**2)
   rod(p,(x,y,z),(x,y+1.2,z),.13,"vermillion")
  for i in range(8):
   z=-7+i*2;y=1.1+2*(1-(z/8)**2)
   box(p,(.15,.15,2.1),(x,y+1.2,z),"bronze",1)
 return p,[{"type":"box","center":[0,1.6,0],"size":[5,3.2,16]}]
def district_lantern():
 p=[]
 box(p,(1.5,.25,1.5),(0,.125,0),"stone")
 rod(p,(0,.25,0),(0,4.7,0),.18,"agedwood")
 rod(p,(0,4.5,0),(1.1,4.5,0),.13,"bronze")
 box(p,(1.2,1.6,1.2),(1.1,3.3,0),"paper")
 roof(p,1.6,1.6,4.15)
 for x in (.55,1.65):
  for z in (-.55,.55):rod(p,(x,2.5,z),(x,4.1,z),.055,"charcoal",1)
 return p,[{"type":"box","center":[0,2.3,0],"size":[.5,4.6,.5]}]
ASSETS={"shogun_citadel_gate":gate,"shogun_pagoda_watchtower":tower,"shogun_city_wall_module":wall,
"shogun_guard_watchpost":watchpost,"shogun_market_shop":shop,"shogun_stone_stairway":stair,
"shogun_canal_arch_bridge":canal_bridge,"shogun_street_lantern":district_lantern}
manifest={}
for name,fn in ASSETS.items():
 parts,proxies=fn()
 manifest[name]={"source":name+".obj","collisionProxies":proxies,"lods":{}}
 for lod in (0,1):
  scene=trimesh.Scene()
  for i,(mesh,detail) in enumerate(parts):
   if lod==1 and detail>0:continue
   scene.add_geometry(mesh,node_name=f"{name}_{i:03}")
  filename=f"{name}_lod{lod}.glb";scene.export(OUT/filename)
  manifest[name]["lods"][f"lod{lod}"]={"file":filename,"triangles":sum(len(g.faces) for g in scene.geometry.values())}
 scene=trimesh.Scene()
 for i,(mesh,_) in enumerate(parts):scene.add_geometry(mesh,node_name=f"{name}_{i:03}")
 scene.export(OUT/(name+".obj"))
(OUT/"manifest.json").write_text(json.dumps({"version":"v09","biome":"ShogunLastCity",
 "status":"Generated mesh source; Roblox Studio QA and approved art parity pending",
 "upAxis":"Y","pivot":"asset ground at Y=0","references":["ART-001","ART-004"],"assets":manifest},indent=2)+"\n")
(OUT/"IMPORT.md").write_text("""# Shogun's Last City v09 Studio import
Import LOD0 GLBs through Studio 3D Importer with embedded material textures; preserve UVs.
Each mesh is anchored and initially non-colliding; use collisionProxies in manifest after traversal tests.
LOD1 removes decorative details; select it manually for distant/low-end presentation.
OBJ files are editable geometry source, GLBs are the textured runtime visual.
No Roblox asset IDs or Studio QA claimed. Check scale, pivot, normals, rooftop visibility and collision.
""")
print("Generated",len(manifest),"textured assets")
