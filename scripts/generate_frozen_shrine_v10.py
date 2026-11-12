#!/usr/bin/env python3
"""Frozen Shrine v10 authored procedural mesh kit. Reproducible, deterministic, no Roblox uploads."""
import json, math
from pathlib import Path
import numpy as np
import trimesh
from PIL import Image, ImageDraw
ROOT=Path("assets/world/frozen_shrine/v10")
ROOT.mkdir(parents=True,exist_ok=True)
PALETTE={"ice":(131,196,219),"stone":(86,100,127),"wood":(53,56,78),"vermillion":(155,54,78),"gold":(232,179,111),"snow":(219,225,235),"spirit":(158,104,221)}
def box(size,xyz,mat):
 m=trimesh.creation.box(extents=size);m.apply_translation(xyz);m.metadata["material"]=mat;return m
def cyl(radius,height,xyz,mat,sections=12):
 m=trimesh.creation.cylinder(radius,height,sections=sections);m.apply_translation(xyz);m.metadata["material"]=mat;return m
def cone(radius,height,xyz,mat,sections=8):
 m=trimesh.creation.cone(radius,height,sections=sections);m.apply_translation(xyz);m.metadata["material"]=mat;return m
def beam(a,b,r,mat):
 a=np.array(a,dtype=float);b=np.array(b,dtype=float);d=b-a
 m=trimesh.creation.cylinder(radius=r,height=np.linalg.norm(d),sections=8)
 m.apply_transform(trimesh.geometry.align_vectors([0,0,1],d))
 m.apply_translation((a+b)/2);m.metadata["material"]=mat;return m
def build(name,low=False):
 f=.65 if low else 1
 p=[]
 def add(m):p.append(m)
 if name=="frost_torii_gate":
  for x in (-4,4):add(box((.8,8,.9),(x,4,0),"vermillion"));add(cone(.9,2,(x,8,0),"ice"))
  add(box((11,.9,1.3),(0,8.3,0),"vermillion"))
  add(box((9,.5,.7),(0,6.8,0),"gold"))
  for i in range(3 if low else 7):
   x=-5+i*(10/(2 if low else 6));add(cone(.55,1.4,(x,9,0),"snow"))
 elif name=="frost_shrine_hall":
  add(box((12,6,9),(0,3,0),"wood"));add(box((14,.8,11),(0,.4,0),"stone"))
  for z in (-4.5,4.5):
   for x in (-6,6):add(box((.7,7,.7),(x,3.5,z),"vermillion"))
  for z in (-3.5,3.5):
   add(beam((-7,6.4,z),(0,9.8,z),.42,"stone"))
   add(beam((0,9.8,z),(7,6.4,z),.42,"stone"))
  for x in np.linspace(-6,6,4 if low else 10):
   add(beam((x,6.6,-5.6),(x,6.6,5.6),.22,"snow"))
  add(box((3.8,4,.16),(0,2,4.58),"gold"))
 elif name=="ice_spire_cluster":
  for i in range(4 if low else 9):
   a=i*2.39996;rad=2.2+((i*3)%5)*.45;h=4+(i*7)%8
   x=math.cos(a)*rad;z=math.sin(a)*rad
   add(cone(.8+(i%3)*.25,h,(x,h/2,z),"ice"))
   add(cone(.34,h*.38,(x,h+.1,z),"snow"))
 elif name=="frozen_bell":
  for x in (-2.2,2.2):add(box((.55,5,.55),(x,2.5,0),"wood"))
  add(box((5.5,.65,.7),(0,5.2,0),"vermillion"))
  add(cyl(1.3,2.3,(0,3.15,0),"gold",8 if low else 20))
  add(cone(1.55,1.0,(0,4.4,0),"ice"))
  add(cyl(.3,.5,(0,1.8,0),"wood"))
 elif name=="snow_stairway":
  for i in range(8 if low else 16):
   h=(i+1)*.36;z=i*.85
   add(box((7,h,.9),(0,h/2,z),"stone"))
   if i%3==0:add(box((7,.12,.5),(0,h+.06,z),"snow"))
 elif name=="ice_lantern":
  add(cyl(.48,3.4,(0,1.7,0),"stone",6 if low else 12))
  add(box((2.2,.35,2.2),(0,3.5,0),"stone"))
  add(box((1.6,1.6,1.6),(0,4.5,0),"gold"))
  add(cone(1.8,1.5,(0,6.05,0),"ice",6 if low else 12))
  add(cyl(.25,.6,(0,6.9,0),"snow"))
 elif name=="glacier_bridge":
  for i in range(8 if low else 16):
   x=-8+i*(16/(7 if low else 15))
   y=2+1.8*(1-(x/8)**2)
   add(box((1.15,.45,5),(x,y,0),"stone"))
  for z in (-2.3,2.3):
   for i in range(4 if low else 8):
    x=-7+i*(14/(3 if low else 7));y=2+1.8*(1-(x/8)**2)
    add(box((.3,1.5,.3),(x,y+.9,z),"ice"))
   add(beam((-7,4,-z/abs(z)*2.3),(7,4,-z/abs(z)*2.3),.17,"ice"))
 elif name=="frost_waystone":
  add(box((3,.5,2.5),(0,.25,0),"stone"))
  add(cone(1.6,6,(0,3.5,0),"stone",6))
  add(cone(.6,2,(0,6.8,0),"ice",6))
  for a in range(3 if low else 7):
   x=math.cos(a*2.399)*1.9;z=math.sin(a*2.399)*1.9
   add(cone(.24,1.2,(x,.6,z),"spirit",6))
 return p
def texture():
 folder=ROOT/"textures";folder.mkdir(exist_ok=True)
 for name,rgb in PALETTE.items():
  im=Image.new("RGB",(128,128),rgb);draw=ImageDraw.Draw(im)
  rng=np.random.default_rng(sum(map(ord,name)))
  for _ in range(180):
   x,y=rng.integers(0,128,size=2);v=int(rng.integers(-13,14))
   color=tuple(max(0,min(255,c+v)) for c in rgb)
   draw.line((int(x),int(y),int(x+3),int(y+1)),fill=color,width=1)
  im.save(folder/(name+".png"))
def mesh_for_export(parts):
 scene=trimesh.Scene()
 for i,part in enumerate(parts):
  mat=part.metadata["material"]
  part.visual=trimesh.visual.TextureVisuals(uv=np.mod(part.vertices[:,[0,2]]*.125,1),material=trimesh.visual.material.PBRMaterial(baseColorFactor=(1,1,1,1),baseColorTexture=Image.open(ROOT/"textures"/(mat+".png")),metallicFactor=.04,roughnessFactor=.84))
  scene.add_geometry(part,geom_name=f"{mat}_{i}")
 return scene
def main():
 texture();names=["frost_torii_gate","frost_shrine_hall","ice_spire_cluster","frozen_bell","snow_stairway","ice_lantern","glacier_bridge","frost_waystone"]
 manifest={"version":"v10","status":"generated source geometry; Studio QA pending","reference":["ART-001","ART-004"],"units":"studs; Y-up glTF and OBJ coordinate conversion must be checked in Studio","assets":{}}
 for name in names:
  counts={}
  for lod in (0,1):
   parts=build(name,low=lod==1)
   scene=mesh_for_export(parts)
   tri=sum(len(m.faces) for m in parts)
   counts[f"lod{lod}Triangles"]=tri
   (ROOT/f"{name}_lod{lod}.glb").write_bytes(scene.export(file_type="glb"))
   if lod==0:
    combined=trimesh.util.concatenate(parts)
    combined.export(ROOT/f"{name}.obj")
    # GLB is the fully textured glTF 2.0 binary; OBJ is editable source.
  assert counts["lod1Triangles"]<counts["lod0Triangles"],name
  manifest["assets"][name]={**counts,"pivot":"Y=0 ground, world origin centered","collision":"primitive proxy pending Studio review","files":[f"{name}.obj",f"{name}_lod0.glb",f"{name}_lod1.glb"]}
 (ROOT/"manifest.json").write_text(json.dumps(manifest,indent=2))
 (ROOT/"IMPORT.md").write_text("# Frozen Shrine v10\\nImport *_lod0.glb via Studio 3D Importer. Preserve existing collision and script authority. Validate axes, pivots, scaling, materials, LOD, mobile frame rate and ART-004 comparison before use. LOD1 is a separate mobile candidate. No Roblox asset IDs are assigned.\\n")
 print(json.dumps({k:v["lod0Triangles"] for k,v in manifest["assets"].items()},indent=2))
if __name__=="__main__":main()
