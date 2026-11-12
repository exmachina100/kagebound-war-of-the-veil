#!/usr/bin/env python3
"""KAGEBOUND Yomi Rift v11: reproducible original environment mesh batch.
Y-up, ground pivots, embedded texture atlas, LODs and simple collision proxies.
No upload or gameplay modifications.
"""
import json, math
from pathlib import Path
import numpy as np
import trimesh
from PIL import Image, ImageDraw
ROOT=Path("assets/world/yomi_rift/v11")
ROOT.mkdir(parents=True,exist_ok=True)
COLORS={"obsidian":(36,33,61),"rift":(126,68,191),"ash":(95,83,115),
        "bone":(190,175,177),"ember":(225,91,140),"gold":(214,157,108)}
def box(size,pos,mat):
 m=trimesh.creation.box(extents=size);m.apply_translation(pos);m.metadata["mat"]=mat;return m
def cyl(r,h,pos,mat,n=10):
 m=trimesh.creation.cylinder(radius=r,height=h,sections=n);m.apply_translation(pos);m.metadata["mat"]=mat;return m
def cone(r,h,pos,mat,n=9):
 m=trimesh.creation.cone(radius=r,height=h,sections=n);m.apply_translation(pos);m.metadata["mat"]=mat;return m
def beam(a,b,r,mat,n=8):
 a=np.array(a,float);b=np.array(b,float);d=b-a
 m=trimesh.creation.cylinder(radius=r,height=np.linalg.norm(d),sections=n)
 m.apply_transform(trimesh.geometry.align_vectors([0,0,1],d))
 m.apply_translation((a+b)/2);m.metadata["mat"]=mat;return m
def build(name,low=False):
 p=[];N=5 if low else 11
 def add(m):p.append(m)
 if name=="yomi_rift_gate":
  for x in (-4,4):
   add(box((1.2,8,1.2),(x,4,0),"obsidian"))
   add(cone(1.25,2.4,(x,9.1,0),"rift",6 if low else 10))
  add(beam((-5,8,0),(0,10.6,0),.65,"obsidian"))
  add(beam((0,10.6,0),(5,8,0),.65,"obsidian"))
  add(cyl(1.3,.5,(0,10.6,0),"ember",8 if low else 16))
 elif name=="spirit_obelisk":
  add(box((3,1,3),(0,.5,0),"ash"))
  for i in range(3 if low else 6):
   h=2.5+i*.95
   add(cone(1.8-i*.19,h,(0,1+h/2+i*.65,0),"obsidian",6))
  add(cone(.65,2,(0,9.8,0),"rift"))
 elif name=="fractured_bridge":
  for i in range(7 if low else 15):
   x=-9+i*(18/(6 if low else 14));y=2+.45*math.sin(i*1.7)
   add(box((1.38,.48,5.5),(x,y,0),"ash"))
   if i%3==0:
    add(cone(.4,1.2,(x,y+.8,2.5),"rift",6))
  for z in (-3,3):
   add(beam((-9,2.5,z),(9,2.5,z),.18,"bone"))
 elif name=="yokai_watchtower":
  for x in (-2.7,2.7):
   for z in (-2.7,2.7):add(box((.75,12,.75),(x,6,z),"obsidian"))
  for y in (3,8,12):add(box((7,.6,7),(0,y,0),"ash"))
  for z in (-3.5,3.5):
   add(beam((-4,13,z),(0,16,z),.35,"bone"))
   add(beam((0,16,z),(4,13,z),.35,"bone"))
  for i in range(3 if low else 8):
   x=-3.4+i*(6.8/(2 if low else 7))
   add(beam((x,13,-3.6),(x,13,3.6),.15,"obsidian"))
 elif name=="rift_crystal_cluster":
  for i in range(N):
   a=i*2.399963;rad=1.2+(i%4)*.85;h=2.8+(i*7)%8
   add(cone(.55+(i%3)*.2,h,(rad*math.cos(a),h/2,rad*math.sin(a)),"rift",6 if low else 9))
 elif name=="spirit_lantern":
  add(cyl(.4,3.6,(0,1.8,0),"bone",6 if low else 12))
  add(box((2,.35,2),(0,3.7,0),"obsidian"))
  add(cyl(.85,1.5,(0,4.6,0),"ember",6 if low else 12))
  add(cone(1.4,1.5,(0,6.1,0),"obsidian",6 if low else 12))
 elif name=="ritual_dais":
  for i in range(3):
   add(cyl(5-i*.85,.5,(0,.25+i*.5,0),"obsidian",10 if low else 24))
  for i in range(4 if low else 10):
   a=2*math.pi*i/(4 if low else 10)
   add(cone(.35,1.3,(4*math.cos(a),1.7,4*math.sin(a)),"ember",6))
  add(cyl(1.1,.2,(0,1.65,0),"rift",10))
 elif name=="veil_shard_arch":
  for side in (-1,1):
   for i in range(3 if low else 6):
    y=i*1.35+1
    add(beam((side*4, y-.8,0),(side*(3.6-i*.23),y+.7,0),.4,"obsidian"))
  add(beam((-2.6,8.5,0),(0,10.2,0),.5,"rift"))
  add(beam((0,10.2,0),(2.6,8.5,0),.5,"rift"))
 else:raise ValueError(name)
 return p
def textures():
 d=ROOT/"textures";d.mkdir(exist_ok=True)
 for name,color in COLORS.items():
  rng=np.random.default_rng(sum(ord(c) for c in name))
  im=Image.new("RGB",(128,128),color);draw=ImageDraw.Draw(im)
  for i in range(230):
   x,y=rng.integers(0,128,2);v=int(rng.integers(-20,21))
   c=tuple(max(0,min(255,z+v)) for z in color)
   draw.line((int(x),int(y),int(x+4),int(y+1)),fill=c)
  im.save(d/(name+".png"))
def main():
 textures()
 names=("yomi_rift_gate","spirit_obelisk","fractured_bridge","yokai_watchtower",
        "rift_crystal_cluster","spirit_lantern","ritual_dais","veil_shard_arch")
 manifest={"version":"v11","zone":"YomiRift","status":"exported; Roblox Studio import QA pending",
           "reference":["ART-001","ART-004"],"units":"Roblox studs, Y up","assets":{}}
 for name in names:
  counts={}
  for lod in (0,1):
   parts=build(name,low=bool(lod));scene=trimesh.Scene()
   for i,part in enumerate(parts):
    mat=part.metadata["mat"]
    part.visual=trimesh.visual.TextureVisuals(
     uv=np.mod(part.vertices[:,[0,2]]*.125,1),
     material=trimesh.visual.material.PBRMaterial(
      baseColorFactor=(1,1,1,1),baseColorTexture=Image.open(ROOT/"textures"/(mat+".png")),
      metallicFactor=.08,roughnessFactor=.8))
    scene.add_geometry(part,geom_name=f"{mat}_{i}")
   counts[f"lod{lod}Triangles"]=sum(len(p.faces) for p in parts)
   (ROOT/f"{name}_lod{lod}.glb").write_bytes(scene.export(file_type="glb"))
   if lod==0:trimesh.util.concatenate(parts).export(ROOT/f"{name}.obj")
  assert counts["lod1Triangles"]<counts["lod0Triangles"],name
  bounds=trimesh.util.concatenate(build(name)).bounds
  manifest["assets"][name]={**counts,"pivot":"ground origin, Y up",
    "boundsStuds":np.round(bounds,2).tolist(),
    "collisionProxy":{"type":"box","center":np.round(bounds.mean(axis=0),2).tolist(),
      "size":np.round(bounds[1]-bounds[0],2).tolist(),"enabled":False},
    "files":[f"{name}.obj",f"{name}_lod0.glb",f"{name}_lod1.glb"]}
 (ROOT/"manifest.json").write_text(json.dumps(manifest,indent=2))
 (ROOT/"IMPORT.md").write_text(
  "# Yomi Rift v11 import\nImport each *_lod0.glb with Roblox Studio 3D Importer. "
  "Use *_lod1.glb for reduced detail. Verify orientation, material color, silhouette, "
  "texture and dimensions. Collision proxies are metadata only; leave collision "
  "disabled until Studio testing. Do not change gameplay authority. No Roblox IDs assigned.\n")
 print(json.dumps({n:m["lod0Triangles"] for n,m in manifest["assets"].items()},indent=2))
if __name__=="__main__":main()
