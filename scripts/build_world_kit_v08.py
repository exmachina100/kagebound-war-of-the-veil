"""KAGEBOUND v08 Moonfall/Dojo production kit. Deterministic, textured, UV-mapped meshes."""
import json, math, random
from pathlib import Path
import numpy as np
import trimesh
from PIL import Image, ImageDraw
random.seed(8026)
OUT=Path("assets/world/dojo_moonfall/v08"); OUT.mkdir(parents=True,exist_ok=True)
COLORS={"ink":(37,37,60),"vermilion":(159,46,68),"wood":(86,58,59),
"gold":(231,174,99),"stone":(94,99,117),"ivory":(229,218,205),
"bamboo":(58,107,77),"leaf":(76,137,92),"violet":(142,82,181)}
def texture(name):
 c=COLORS[name];im=Image.new("RGB",(128,128),c);d=ImageDraw.Draw(im)
 for i in range(250):
  x=random.randrange(128);y=random.randrange(128);delta=random.randrange(-18,19)
  v=tuple(max(0,min(255,k+delta)) for k in c)
  d.line((x,y,x+random.randrange(-6,7),y+random.randrange(-8,9)),fill=v,width=1)
 im.save(OUT/(name+"_albedo.png"))
 return im
TEX={name:texture(name) for name in COLORS}
def material_mesh(mesh,name):
 from trimesh.visual.texture import TextureVisuals
 from trimesh.visual.material import PBRMaterial
 v=mesh.vertices
 # Triplanar approximation; UVs exist on every exported mesh.
 uv=np.column_stack(((v[:,0]+v[:,2]*.41)*.14%1,(v[:,1]+v[:,2]*.29)*.14%1))
 mesh.visual=TextureVisuals(uv=uv,material=PBRMaterial(name=name,baseColorTexture=TEX[name],roughnessFactor=.86,metallicFactor=0))
 return mesh
def cube(size,center,mat):
 m=trimesh.creation.box(extents=size);m.apply_translation(center)
 return material_mesh(m,mat)
def pole(a,b,r,mat,sections=10):
 a=np.array(a);b=np.array(b);d=b-a
 m=trimesh.creation.cylinder(radius=r,height=np.linalg.norm(d),sections=sections)
 m.apply_transform(trimesh.geometry.align_vectors([0,0,1],d))
 m.apply_translation((a+b)/2)
 return material_mesh(m,mat)
def leaf(a,b,w,mat):
 a=np.array(a);b=np.array(b);d=b-a
 side=np.array([-d[2],0,d[0]]);side/=max(np.linalg.norm(side),.001)
 verts=np.array([a,b+side*w,b-side*w,a+np.array([0,.16,0])])
 m=trimesh.Trimesh(vertices=verts,faces=[[0,1,3],[0,3,2]],process=False)
 return material_mesh(m,mat)
def add(parts,m,level=0):parts.append((m,level))
def torii():
 p=[]
 for x in (-3,3):
  add(p,pole((x,0,0),(x,6,0),.32,"vermilion"))
  add(p,cube((1,.3,1),(x,.2,0),"stone"))
 add(p,cube((8,.44,1.2),(0,6.15,0),"ink"))
 add(p,cube((7.2,.35,.8),(0,5.4,0),"vermilion"))
 for x in (-3.7,3.7):add(p,pole((x,6.1,0),(x,6.6,0),.17,"gold"),1)
 add(p,cube((1.3,1.2,.1),(0,4.55,-.48),"ivory"),1)
 return p,[{"type":"box","center":[-3,3,0],"size":[.8,6,.8]},{"type":"box","center":[3,3,0],"size":[.8,6,.8]}]
def roof():
 p=[]
 for z in (-2.2,2.2):
  for i in range(9):
   x=-4+i
   y=4.4+1.65*(1-abs(x)/4)**1.6
   add(p,pole((x,y,z),(x,y+.15,z),.12,"gold"),1)
 for i in range(9):
  x=-4+i
  y=4.4+1.65*(1-abs(x)/4)**1.6
  add(p,cube((1.1,.18,5.4),(x,y,0),"ink"))
 add(p,pole((-4.5,4.55,-2.8),(4.5,4.55,-2.8),.15,"vermilion"))
 add(p,pole((-4.5,4.55,2.8),(4.5,4.55,2.8),.15,"vermilion"))
 return p,[{"type":"box","center":[0,5,0],"size":[9,2.2,5.6]}]
def lantern():
 p=[(cube((1.4,.28,1.4),(0,.14,0),"stone"),0),(pole((0,.28,0),(0,2.5,0),.24,"stone"),0),
 (cube((1.35,.2,1.35),(0,2.55,0),"stone"),0),(cube((1.1,1,1.1),(0,3.15,0),"gold"),0),
 (cube((1.8,.25,1.8),(0,3.75,0),"ink"),0)]
 for x in (-.52,.52):
  for z in (-.52,.52):add(p,pole((x,2.65,z),(x,3.65,z),.08,"stone"),1)
 add(p,pole((0,3.9,0),(0,4.3,0),.2,"ivory"),1)
 return p,[{"type":"box","center":[0,2,0],"size":[1.6,4,1.6]}]
def banner():
 p=[(pole((-1.3,5,0),(1.3,5,0),.14,"wood"),0),
 (pole((0,0,0),(0,5.6,0),.17,"wood"),0),
 (cube((2.2,3,.08),(0,3.35,0),"vermilion"),0)]
 for x in (-.85,.85):add(p,pole((x,1.9,0),(x,4.8,0),.05,"gold"),1)
 add(p,cube((1.1,1.1,.1),(0,3.5,-.08),"ivory"),1)
 return p,[{"type":"box","center":[0,2.7,0],"size":[.4,5.4,.4]}]
def bamboo():
 p=[]
 for i in range(5):
  x=math.sin(i*2.4)*1.3;z=math.cos(i*2.4)*1.3;h=7+i%3*1.4
  for j in range(5):
   a=(x+.06*j,j*h/5,z+.04*j);b=(x+.06*(j+1),(j+1)*h/5,z+.04*(j+1))
   add(p,pole(a,b,.15,"bamboo"),0)
   add(p,pole((b[0],b[1]-.03,b[2]),(b[0],b[1]+.03,b[2]),.19,"gold"),1)
  for k in range(5):
   angle=k*2.4+i; y=h*(.64+.07*k)
   a=(x,y,z);b=(x+2*math.cos(angle),y+.6,z+2*math.sin(angle))
   add(p,pole(a,b,.045,"wood"),1)
   for side in (-1,1):add(p,leaf(b,(b[0]+side*.7,b[1]+.18,b[2]+.25),.32,"leaf"),1)
 return p,[{"type":"cylinder","center":[0,4,0],"radius":1.9,"height":8}]
def bridge():
 p=[]
 for j in range(15):
  z=-7+j;y=1+1.4*(1-(z/7)**2)
  add(p,cube((4.2,.2,.92),(0,y,z),"wood"))
 for x in (-2.1,2.1):
  for j in range(8):
   z=-7+2*j;y=1+1.4*(1-(z/7)**2)
   add(p,pole((x,y,z),(x,y+1.2,z),.13,"vermilion"),0)
  for j in range(7):
   z=-6+2*j;y=1+1.4*(1-(z/7)**2)
   add(p,cube((.14,.14,2.1),(x,y+1.18,z),"gold"),1)
 return p,[{"type":"box","center":[0,1.7,0],"size":[4.2,2.5,14]}]
def stones():
 p=[]
 for i in range(15):
  x=(i%3-1)*1.55+.12*math.sin(i*4);z=(i//3-2)*1.65
  add(p,cube((1.38,.22,1.4),(x,.12,z),"stone"))
  add(p,cube((1.2,.03,.1),(x,.25,z-.4),"ivory"),1)
 return p,[{"type":"box","center":[0,.12,0],"size":[4.6,.25,8]}]
def shrine():
 p=[(cube((6,.4,5),(0,.2,0),"stone"),0)]
 for x in (-2.4,2.4):
  for z in (-1.9,1.9):add(p,pole((x,.4,z),(x,4.5,z),.22,"vermilion"))
 add(p,cube((6.8,.25,5.6),(0,4.55,0),"ink"))
 for x in np.linspace(-3.2,3.2,9):
  y=4.7+1.5*(1-abs(x)/3.3)
  add(p,cube((.75,.16,5.8),(x,y,0),"ink"))
 add(p,cube((2,1.4,1.3),(0,1.2,-.6),"wood"))
 add(p,cube((2.2,.12,1.5),(0,2,-.6),"gold"),1)
 return p,[{"type":"box","center":[0,.2,0],"size":[6,.4,5]}]
ASSETS={"dojo_torii_signature":torii,"dojo_roof_eave_module":roof,"dojo_stone_lantern":lantern,
"dojo_ritual_banner":banner,"moonfall_bamboo_grove":bamboo,"moonfall_arch_bridge":bridge,
"dojo_ceremonial_stones":stones,"dojo_shrine_pavilion":shrine}
manifest={}
for name,fn in ASSETS.items():
 parts,proxy=fn()
 manifest[name]={"collisionProxies":proxy,"lods":{}}
 for lod in (0,1):
  scene=trimesh.Scene()
  for i,(m,level) in enumerate(parts):
   if level<=lod: # LOD0: all; LOD1: essential only (selection inverted below)
    pass
   if lod==1 and level==1:continue
   scene.add_geometry(m,node_name=f"{name}_{i:03}")
  path=OUT/f"{name}_lod{lod}.glb";scene.export(path)
  tris=sum(len(g.faces) for g in scene.geometry.values())
  manifest[name]["lods"][f"lod{lod}"]={"file":path.name,"triangles":tris}
 # Source OBJ/MTL export; GLB retains original PBR texture materials.
 source=trimesh.Scene()
 for i,(m,_) in enumerate(parts):source.add_geometry(m,node_name=f"{name}_{i:03}")
 source.export(OUT/f"{name}.obj")
 manifest[name]["source"]=name+".obj"
(OUT/"manifest.json").write_text(json.dumps({"version":"v08","status":"generated; Studio QA pending","units":"studs approx","up":"Y","reference":["ART-001","ART-004"],"assets":manifest},indent=2)+"\n")
(OUT/"IMPORT.md").write_text("# KAGEBOUND v08 import\nImport LOD0 GLBs via Roblox Studio 3D Importer, preserving embedded albedo textures. Editable OBJ sources accompany GLBs. Align ground pivots at Y=0 after import; Roblox may alter axes. Keep visuals anchored and non-collidable until proxy tests pass. LOD1 is simplified and must be selected manually. No verified Roblox asset IDs or Studio QA.\n")
print("Generated",len(manifest),"assets",sum(v["lods"]["lod0"]["triangles"] for v in manifest.values()),"triangles")
