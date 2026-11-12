"""KAGEBOUND Frozen Shrine v10 — original textured mesh kit. Studio approval pending."""
import json,math,random
from pathlib import Path
import numpy as np,trimesh
from PIL import Image,ImageDraw
from trimesh.visual.texture import TextureVisuals
from trimesh.visual.material import PBRMaterial
random.seed(1010)
O=Path("assets/world/frozen_shrine/v10");O.mkdir(parents=True,exist_ok=True)
P={"froststone":(116,150,171),"ice":(135,203,220),"snow":(225,229,236),"ink":(38,48,76),"vermillion":(147,48,77),"bronze":(189,153,114),"wood":(85,76,90)}
tex={}
for name,rgb in P.items():
 im=Image.new("RGB",(256,256),rgb);d=ImageDraw.Draw(im)
 for i in range(900):
  x=random.randrange(256);y=random.randrange(256);v=random.randrange(-19,20)
  c=tuple(max(0,min(255,a+v)) for a in rgb)
  d.line((x,y,x+random.randrange(1,20),y+random.randrange(-3,4)),fill=c,width=1)
 im.save(O/(name+"_albedo.png"));tex[name]=im
def decorate(m,material):
 v=m.vertices;uv=np.column_stack((np.mod(v[:,0]*.13+v[:,2]*.07,1),np.mod(v[:,1]*.12+v[:,2]*.09,1)))
 m.visual=TextureVisuals(uv=uv,material=PBRMaterial(name=material,baseColorTexture=tex[material],roughnessFactor=.74,metallicFactor=.04))
 return m
def box(a,size,pos,material,detail=0):
 m=trimesh.creation.box(extents=size);m.apply_translation(pos);a.append((decorate(m,material),detail))
def beam(a,start,end,r,material,detail=0,n=8):
 start=np.array(start);end=np.array(end);d=end-start
 m=trimesh.creation.cylinder(radius=r,height=np.linalg.norm(d),sections=n)
 m.apply_transform(trimesh.geometry.align_vectors([0,0,1],d));m.apply_translation((start+end)/2)
 a.append((decorate(m,material),detail))
def spire(a,x,z,h,r,material,detail=0):
 # Tapered six-sided ice shard, not an axis-aligned primitive.
 v=[];f=[]
 for j in range(6):
  t=j*math.tau/6
  v.append((x+r*math.cos(t),0,z+r*math.sin(t)))
 v.append((x+.2*r,h,z-.15*r))
 for j in range(6):f.append((j,(j+1)%6,6))
 f.append(tuple(range(5,-1,-1)))
 a.append((decorate(trimesh.Trimesh(vertices=v,faces=f,process=False),material),detail))
def roof(a,w,d,y):
 # Two sloping panels with snow cap and gold ridge.
 for side in (-1,1):
  start=(-w/2,y-.5,side*d/2);mid=(0,y+1.8,0);end=(w/2,y-.5,side*d/2)
  v=[start,end,mid,(start[0],start[1]-.15,start[2]),(end[0],end[1]-.15,end[2]),(mid[0],mid[1]-.15,mid[2])]
  f=[(0,1,2),(5,4,3),(0,3,4),(0,4,1),(1,4,5),(1,5,2),(2,5,3),(2,3,0)]
  a.append((decorate(trimesh.Trimesh(vertices=v,faces=f,process=False),"ink"),0))
 beam(a,(-w/2,y+1.8,0),(w/2,y+1.8,0),.12,"bronze",1)
def frost_gate():
 a=[]
 for x in (-3.5,3.5):
  box(a,(.65,6,.65),(x,3,0),"vermillion")
  box(a,(1.3,.55,1.3),(x,.275,0),"froststone")
  spire(a,x,0,7.8,.58,"ice",1)
 box(a,(8.6,.55,1.1),(0,5.7,0),"ink");box(a,(9.2,.2,1.4),(0,6.2,0),"snow")
 return a,[{"type":"box","center":[-3.5,3,0],"size":[.7,6,.7]},{"type":"box","center":[3.5,3,0],"size":[.7,6,.7]}]
def shrine():
 a=[]
 box(a,(9,.7,7),(0,.35,0),"froststone")
 for x in (-3.5,3.5):
  for z in (-2.5,2.5):beam(a,(x,.7,z),(x,5.2,z),.23,"wood")
 box(a,(7.6,3.4,5.5),(0,2.6,0),"wood")
 roof(a,10,8,5.6)
 for x in (-2.3,0,2.3):box(a,(1.5,2.5,.1),(x,2.8,-2.81),"snow",1)
 return a,[{"type":"box","center":[0,.35,0],"size":[9,.7,7]},{"type":"box","center":[0,2.6,0],"size":[7.6,3.4,5.5]}]
def ice_cluster():
 a=[]
 for i,(x,z,h,r) in enumerate([(-2,-.8,7,1.2),(0,0,10,1.7),(2,.5,6,1.1),(.6,-2,4,.8)]):
  spire(a,x,z,h,r,"ice" if i%2==0 else "froststone")
  if i%2==0:spire(a,x+.25,z+.4,h*.45,r*.55,"snow",1)
 return a,[{"type":"box","center":[0,2.5,0],"size":[6,5,5]}]
def bell():
 a=[]
 box(a,(3.6,.4,3.6),(0,.2,0),"froststone")
 for x in (-1.2,1.2):beam(a,(x,.4,0),(x,5.5,0),.2,"vermillion")
 box(a,(3.6,.35,.6),(0,5.4,0),"ink")
 m=trimesh.creation.cone(radius=1.05,height=1.7,sections=12);m.apply_translation((0,3.75,0))
 a.append((decorate(m,"bronze"),0))
 beam(a,(0,4.5,0),(0,5.6,0),.08,"wood",1)
 return a,[{"type":"box","center":[0,.2,0],"size":[3.6,.4,3.6]},{"type":"box","center":[0,3.7,0],"size":[2.2,2,2.2]}]
def stair():
 a=[]
 for i in range(12):
  box(a,(6,.36,1.25),(0,.18+i*.31,-6+i*1.1),"froststone")
  if i%3==0:box(a,(5.7,.08,.95),(0,.4+i*.31,-6+i*1.1),"snow",1)
 return a,[{"type":"box","center":[0,2,0],"size":[6,4,14]}]
def lantern():
 a=[]
 box(a,(1.9,.4,1.9),(0,.2,0),"froststone")
 beam(a,(0,.4,0),(0,3,0),.28,"froststone")
 box(a,(1.7,.2,1.7),(0,3,0),"froststone")
 box(a,(1.2,1.2,1.2),(0,3.75,0),"ice")
 for x in (-.65,.65):
  for z in (-.65,.65):beam(a,(x,3.1,z),(x,4.35,z),.07,"ink",1)
 roof(a,2.1,2.1,4.6)
 return a,[{"type":"box","center":[0,2.3,0],"size":[2.1,4.6,2.1]}]
A={"frozen_ritual_gate":frost_gate,"frozen_shrine_hall":shrine,"frozen_ice_spire_cluster":ice_cluster,"frozen_bell_frame":bell,"frozen_ceremonial_stairs":stair,"frozen_stone_lantern":lantern}
manifest={}
for name,fn in A.items():
 parts,proxies=fn();manifest[name]={"collisionProxies":proxies,"source":name+".obj","lods":{}}
 for level in (0,1):
  scene=trimesh.Scene()
  for i,(mesh,detail) in enumerate(parts):
   if level==1 and detail>0:continue
   scene.add_geometry(mesh,node_name=f"{name}_{i:03}")
  file=f"{name}_lod{level}.glb";scene.export(O/file)
  manifest[name]["lods"][f"lod{level}"]={"file":file,"triangles":sum(len(m.faces) for m in scene.geometry.values())}
 scene=trimesh.Scene()
 for i,(mesh,_) in enumerate(parts):scene.add_geometry(mesh,node_name=f"{name}_{i:03}")
 scene.export(O/(name+".obj"))
(O/"manifest.json").write_text(json.dumps({"version":"v10","biome":"FrozenShrine","up":"Y","pivot":"ground Y=0","status":"Generated; Studio import and art approval pending","references":["ART-001","ART-004"],"assets":manifest},indent=2)+"\n")
(O/"IMPORT.md").write_text("Frozen Shrine v10: Import *_lod0.glb with embedded PBR albedo in Roblox Studio 3D Importer. OBJ files are editable sources. LOD1 omits small detail. Models anchored, visuals noncolliding until manifest collisionProxies are manually implemented and tested. Verify pivot, UV, normals, scaling, traversal and visual parity with ART-001/004. No Roblox asset IDs or Studio QA claimed.\n")
print("Generated",len(A),"assets",sum(x["lods"]["lod0"]["triangles"] for x in manifest.values()),"triangles")
