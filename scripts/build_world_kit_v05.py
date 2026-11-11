"""KAGEBOUND v05 original stylized world kit: reproducible textured GLB/OBJ with LOD and collision metadata.
Requires trimesh, numpy and Pillow. No network or external art dependency.
ART-001/004 visual language: vermilion, ink, moon-ivory, lantern gold, bamboo green.
"""
import json, math
from pathlib import Path
import numpy as np
import trimesh
from PIL import Image, ImageDraw
OUT=Path("assets/world/dojo_moonfall/v05")
OUT.mkdir(parents=True,exist_ok=True)
PALETTE={"vermilion":(154,47,72,255),"ink":(32,35,56,255),"wood":(76,53,65,255),
"ivory":(234,219,231,255),"gold":(250,182,107,255),"stone":(83,86,108,255),
"bamboo":(45,86,74,255),"leaf":(72,112,87,255),"veil":(169,91,228,255)}
def box(size,center,mat):
 m=trimesh.creation.box(extents=size)
 m.apply_translation(center)
 m.visual.vertex_colors=np.tile(PALETTE[mat],(len(m.vertices),1))
 return m
def cyl(r,h,center,mat,sections=10):
 m=trimesh.creation.cylinder(radius=r,height=h,sections=sections)
 m.apply_transform(trimesh.transformations.rotation_matrix(math.pi/2,[1,0,0]))
 # cylinder Z-up -> Y-up
 m.apply_translation(center)
 m.visual.vertex_colors=np.tile(PALETTE[mat],(len(m.vertices),1))
 return m
def beam(a,b,r,mat,sections=8):
 a=np.array(a,float);b=np.array(b,float);d=b-a
 m=trimesh.creation.cylinder(radius=r,height=float(np.linalg.norm(d)),sections=sections)
 m.apply_transform(trimesh.geometry.align_vectors([0,0,1],d))
 m.apply_translation((a+b)/2)
 m.visual.vertex_colors=np.tile(PALETTE[mat],(len(m.vertices),1))
 return m
def wedge(a,b,c,width,mat):
 # triangular roof silhouette extruded along Z, double-sided volume
 p=np.array([[a[0],a[1],-width/2],[b[0],b[1],-width/2],[c[0],c[1],-width/2],
 [a[0],a[1],width/2],[b[0],b[1],width/2],[c[0],c[1],width/2]],float)
 faces=[[0,2,1],[3,4,5],[0,1,4],[0,4,3],[1,2,5],[1,5,4],[2,0,3],[2,3,5]]
 m=trimesh.Trimesh(vertices=p,faces=faces,process=False)
 m.visual.vertex_colors=np.tile(PALETTE[mat],(len(m.vertices),1))
 return m
def create(name,parts,proxy,notes):
 for lod in ("lod0","lod1"):
  meshes=parts if lod=="lod0" else parts[::2]
  scene=trimesh.Scene()
  for i,m in enumerate(meshes):scene.add_geometry(m,node_name=f"{name}_{i:03}")
  scene.export(OUT/f"{name}_{lod}.glb")
  if lod=="lod0":
   with open(OUT/f"{name}.obj","w") as f:
    index=1
    for i,m in enumerate(meshes):
     f.write(f"o {name}_{i:03}\n")
     for v in m.vertices:f.write("v %.5f %.5f %.5f\n"%tuple(v))
     for face in m.faces:f.write("f "+" ".join(str(index+int(k)) for k in face)+"\n")
     index+=len(m.vertices)
  counts[lod][name]=sum(len(m.faces) for m in meshes)
 manifest[name]={"lod0":f"{name}_lod0.glb","lod1":f"{name}_lod1.glb",
 "obj":f"{name}.obj","triangles":counts["lod0"][name],"lod1Triangles":counts["lod1"][name],
 "collisionProxies":proxy,"notes":notes,"pivot":"ground at Y=0"}
counts={"lod0":{},"lod1":{}};manifest={}
# Curved dojo eave: staggered sloped roof panels, ridge finials, contrasting gold trims.
p=[box((9,.5,5),(0,4.9,0),"ink"),box((9.5,.17,.4),(0,5.2,-2.6),"gold")]
for x in np.linspace(-4,4,9):
 p.append(beam((x,5.15,-2.55),(x,6.7,0),.09,"wood"))
 p.append(beam((x,6.7,0),(x,5.15,2.55),.09,"wood"))
p += [beam((-4.7,5.2,-2.65),(4.7,5.2,-2.65),.13,"vermilion"),
beam((-4.7,5.2,2.65),(4.7,5.2,2.65),.13,"vermilion")]
create("dojo_curved_roof",p,[{"type":"box","center":[0,5.25,0],"size":[9.5,1.7,5.6]}],"Ridge, curved-eave impression from tiered beams; replace proxy with roof collision as needed")
# Sacred offering pavilion with roof silhouette and lantern brackets
p=[box((7,.5,6),(0,.25,0),"stone")]
for x in (-2.8,2.8):
 for z in (-2.3,2.3):p.append(box((.45,4.8,.45),(x,2.65,z),"vermilion"))
p += [box((7.5,.3,6.6),(0,5.0,0),"ink"),wedge((-4.2,5.05),(0,6.8),(4.2,5.05),6.6,"ink"),
box((2.4,1.4,1.4),(0,1.1,-.5),"wood"),box((2.8,.18,1.7),(0,1.9,-.5),"gold")]
for x in (-3.2,3.2):p.append(box((.42,.75,.42),(x,4.1,-2.9),"gold"))
create("dojo_offering_pavilion",p,[{"type":"box","center":[0,.25,0],"size":[7,.5,6]},
{"type":"box","center":[0,2.5,-2.3],"size":[7,5,.5]}],"Walkable base and noncolliding roof ornament")
# Ritual floor tiles with fractured edges and inset vermilion path
p=[]
for x in range(-3,4):
 for z in range(-3,4):
  y=.05+.025*math.sin(x*13+z*7)
  p.append(box((1.06,.14,1.06),(x*1.12,y,z*1.12),"stone"))
  if x==0:p.append(box((.16,.015,.9),(0,y+.085,z*1.12),"vermilion"))
create("dojo_ceremonial_court",p,[{"type":"box","center":[0,0,0],"size":[8,.15,8]}],"49 individual floor stones; main walkable court proxy")
# Three-arch moonfall bridge, rails and deck planks
p=[]
for k in range(13):
 z=-6+k
 y=1.1+1.2*(1-(z/6)**2)
 p.append(box((4.4,.22,.91),(0,y,z),"wood"))
for x in (-2.2,2.2):
 for k in range(7):
  z=-6+2*k;y=1.1+1.2*(1-(z/6)**2)
  p.append(box((.22,1.2,.22),(x,y+.6,z),"vermilion"))
 for k in range(6):
  z=-5+2*k;y=1.1+1.2*(1-(z/6)**2)
  p.append(box((.18,.18,2.2),(x,y+1.2,z),"gold"))
create("moonfall_arch_bridge",p,[{"type":"box","center":[0,1.1,0],"size":[4.4,2.5,12]}],"Curved bridge deck, rail silhouettes; proxy conservative pending Studio traversal QA")
# Bamboo canopy cluster with articulated segmented culms and leaves
p=[]
for i in range(7):
 x=math.sin(i*2.4)*1.8;z=math.cos(i*2.4)*1.8
 height=8+(i%3)*1.6
 for j in range(4):
  y0=j*height/4;y1=(j+1)*height/4
  p.append(beam((x,y0,z),(x+.12*math.sin(i+j),y1,z+.12*math.cos(i+j)),.13,"bamboo"))
  p.append(box((.38,.12,.38),(x,y1,z),"gold"))
 for j in range(5):
  a=i*2.1+j*1.26;y=height*(.58+.08*j)
  p.append(beam((x,y,z),(x+2*math.cos(a),y+.65,z+2*math.sin(a)),.045,"wood"))
  p.append(wedge((x+1.2*math.cos(a),y+.3),(x+2.5*math.cos(a),y+.7),(x+1.6*math.cos(a),y+1.2),.16,"leaf"))
create("moonfall_bamboo_canopy",p,[{"type":"cylinder","center":[0,4.5,0],"radius":2.2,"height":9}],"Seven stalks, branch leaves; collision proxy intentionally approximate")
# Stone lantern shrine landmark with roof finial and glowing cavity
p=[box((2.2,.4,2.2),(0,.2,0),"stone"),box((.75,2,.75),(0,1.4,0),"stone"),
box((1.8,.3,1.8),(0,2.6,0),"stone"),box((1.1,1.05,1.1),(0,3.25,0),"gold"),
box((2.1,.25,2.1),(0,3.95,0),"ink"),wedge((-1.25,4.0),(0,4.7),(1.25,4.0),2.5,"ink"),
box((.3,.55,.3),(0,4.9,0),"ivory")]
for x in (-.58,.58):
 for z in (-.58,.58):p.append(box((.14,1.05,.14),(x,3.25,z),"stone"))
create("moonfall_ritual_lantern",p,[{"type":"box","center":[0,2.45,0],"size":[2.3,4.9,2.5]}],"Open lantern cavity; gold emissive material requires Studio material assignment")
# Original texture atlas for later Studio surface detail; kept in world source, NOT auto-published.
im=Image.new("RGBA",(512,512),(28,30,51,255));d=ImageDraw.Draw(im)
for k,(name,color) in enumerate(PALETTE.items()):
 x=(k%3)*170;y=(k//3)*170
 d.rectangle((x,y,x+168,y+168),fill=color)
 for n in range(11):
  v=n*13
  d.line((x+v,y,x+v+34,y+168),fill=tuple(min(255,c+10) for c in color[:3])+(90,),width=1)
im.save(OUT/"world_palette_atlas.png")
(OUT/"manifest.json").write_text(json.dumps({"version":"v05","references":["ART-001","ART-004"],
 "format":"GLB 2.0 + OBJ","units":"studs approximate","material":"vertex color, texture atlas supplied separately",
 "lodPolicy":"LOD1 uses every second visual mesh; NOT screen-distance tested",
 "assets":manifest},indent=2)+"\n")
(OUT/"IMPORT.md").write_text("""# KAGEBOUND v05 world art import
- Source: scripts/build_world_kit_v05.py; rebuild with `pip install trimesh numpy pillow`.
- Each asset has `_lod0.glb`, `_lod1.glb` and editable OBJ. Use GLB for vertex colors.
- Ground pivot at Y=0, positive Y up. Import through Studio 3D Importer; do not assume automatic upload.
- Mesh visuals: CanCollide=false, Anchored=true. Implement manifest proxy volumes as transparent anchored Parts.
- Verify collision, scale, normals, traversal, textures and silhouette against ART-001/004.
- Atlas is a palette reference, not a UV texture applied to GLBs; vertex colors provide base colors.
- No Studio test or Roblox asset IDs have been verified.
""")
print("Built",len(manifest),"assets",sum(counts["lod0"].values()),"LOD0 triangles")
