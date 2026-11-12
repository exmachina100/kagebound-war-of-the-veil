#!/usr/bin/env python3
"""KAGEBOUND v13/v14 OBJ -> textured GLB LOD batch. No Roblox publishing."""
from pathlib import Path
import json, math, hashlib
import numpy as np
import trimesh
from PIL import Image, ImageDraw
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'assets/world/production/v15'
INPUTS=[
 ('v13','dojo_bell_pavilion','dojo','wood'),
 ('v13','dojo_ritual_basin','dojo','stone'),
 ('v13','moonfall_bamboo_fence','moonfall','bamboo'),
 ('v14','dojo_ritual_drum','dojo','wood'),
 ('v14','dojo_training_pavilion','dojo','wood'),
 ('v14','moonfall_ritual_gate','moonfall','vermilion'),
 ('v14','moonfall_shrine_stair','moonfall','stone')]
PALETTE={'wood':(69,49,64),'stone':(88,91,113),'bamboo':(50,89,75),'vermilion':(155,48,72)}
def texture(kind):
    rgb=PALETTE[kind]
    im=Image.new('RGB',(256,256),rgb)
    px=im.load()
    for y in range(256):
        for x in range(256):
            n=(int(hashlib.sha256(f'{kind}:{x//5}:{y//5}'.encode()).hexdigest()[:2],16)-128)//18
            grain=(math.sin((x if kind in ('wood','bamboo') else y)*0.21)*5)
            d=int(n+grain)
            px[x,y]=tuple(max(0,min(255,c+d)) for c in rgb)
    return im
def main():
    OUT.mkdir(parents=True,exist_ok=True)
    manifest={'schema':1,'unit':'stud','up':'Y','source':'v13/v14 original OBJ','assets':[]}
    for version,name,region,kind in INPUTS:
        source=ROOT/'assets/world/production'/version/(name+'.obj')
        loaded=trimesh.load(source,force='scene',process=False)
        mesh=loaded.dump(concatenate=True)
        if not isinstance(mesh,trimesh.Trimesh) or len(mesh.faces)==0: raise RuntimeError(name)
        # Source OBJ uses Y-up. Preserve coordinates and ground pivot.
        verts=np.asarray(mesh.vertices,dtype=np.float64)
        faces=np.asarray(mesh.faces,dtype=np.int64)
        if not np.isfinite(verts).all() or faces.min()<0 or faces.max()>=len(verts): raise RuntimeError(name)
        # Planar UV projection gives every imported face an actual texture, not vertex-only placeholder.
        bounds=mesh.bounds; span=np.maximum(bounds[1]-bounds[0],1e-5)
        uv=np.column_stack(((verts[:,0]-bounds[0,0])/span[0],(verts[:,2]-bounds[0,2])/span[2]))
        tex=texture(kind)
        texname=f'{kind}_albedo.png'
        tex.save(OUT/texname)
        material=trimesh.visual.material.PBRMaterial(baseColorTexture=tex,metallicFactor=0.0,roughnessFactor=0.83,doubleSided=True)
        mesh.visual=trimesh.visual.TextureVisuals(uv=uv,material=material)
        mesh.remove_unreferenced_vertices()
        paths=[]
        for lod in (0,1):
            m=mesh.copy()
            if lod==1 and len(m.faces)>80:
                try:
                    m=m.simplify_quadric_decimation(face_count=max(64,int(len(m.faces)*0.55)))
                except Exception as exc:
                    raise RuntimeError(f'{name}: LOD decimation unavailable: {exc}')
                # Simplification can discard UV/material. Reproject UV to the same bounds.
                vv=np.asarray(m.vertices)
                m.visual=trimesh.visual.TextureVisuals(uv=np.column_stack(((vv[:,0]-bounds[0,0])/span[0],(vv[:,2]-bounds[0,2])/span[2])),material=material)
            path=OUT/f'{name}_lod{lod}.glb'
            path.write_bytes(m.export(file_type='glb'))
            check=trimesh.load(path,force='scene')
            if not check.geometry: raise RuntimeError(f'GLB readback failed: {path}')
            paths.append({'path':str(path.relative_to(ROOT)),'triangles':int(len(m.faces)),'bytes':path.stat().st_size})
        if paths[1]['triangles']>=paths[0]['triangles']: raise RuntimeError('LOD not reduced: '+name)
        manifest['assets'].append({'name':name,'region':region,'source':str(source.relative_to(ROOT)),'texture':str((OUT/texname).relative_to(ROOT)),'lods':paths,'bounds_studs':bounds.round(4).tolist(),'pivot':'source OBJ origin; Y-up','collision_proxy':{'shape':'box','size_studs':span.round(4).tolist(),'center_studs':((bounds[0]+bounds[1])/2).round(4).tolist(),'default_collidable':False},'studio_status':'NOT IMPORTED'})
    (OUT/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    (OUT/'IMPORT.md').write_text('# KAGEBOUND v15 — GLB import\n\nImport each *_lod0.glb using Roblox Studio 3D Importer. Confirm scale and Y-up orientation, inspect materials and face normals. Keep *_lod1.glb for distant variants. The JSON collision boxes are specifications, not automatically installed collision. Existing traversable collision remains authoritative. Set imported decorative MeshParts CanCollide=false; never overwrite gameplay collision. No Roblox asset IDs or Studio validation are claimed.\n')
    print('exported',len(manifest['assets']),'assets',sum(len(a['lods']) for a in manifest['assets']),'GLBs')
if __name__=='__main__': main()
