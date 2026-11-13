#!/usr/bin/env python3
"""Export original v16 Dojo/Moonfall OBJ geometry into importable textured GLB LODs.
Does not publish Roblox IDs or modify gameplay. All dimensions remain in source units.
"""
from pathlib import Path
import json, math, hashlib
import numpy as np
import trimesh
from PIL import Image

ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'assets/world/production/v16'
ASSETS=[
 ('KGB_Dojo_SpiritLantern_v16','dojo','stone'),
 ('KGB_Moonfall_CurvedBridge_v16','moonfall','stone'),
 ('KGB_Dojo_CeremonialTorii_v16','dojo','vermilion'),
]
COLORS={'stone':(86,88,108),'vermilion':(154,47,72)}
def texture(kind):
    im=Image.new('RGB',(256,256))
    pixels=im.load()
    color=COLORS[kind]
    for y in range(256):
        for x in range(256):
            # Deterministic original stone/paint grain; tileable at the boundaries.
            wave=4*math.sin(2*math.pi*x*8/256)*math.cos(2*math.pi*y*8/256)
            grain=int(hashlib.sha256(f'{kind}:{x//8}:{y//8}'.encode()).hexdigest()[:2],16)%9-4
            pixels[x,y]=tuple(max(0,min(255,round(c+wave+grain))) for c in color)
    return im
def load_obj(path):
    scene=trimesh.load(path,force='scene',process=False)
    mesh=scene.dump(concatenate=True)
    if not isinstance(mesh,trimesh.Trimesh) or not len(mesh.faces): raise ValueError(path)
    if not np.isfinite(mesh.vertices).all(): raise ValueError('nonfinite vertices')
    if mesh.faces.min()<0 or mesh.faces.max()>=len(mesh.vertices): raise ValueError('bad indices')
    return mesh
def uv_for(mesh,bounds):
    span=np.maximum(bounds[1]-bounds[0],1e-6)
    verts=np.asarray(mesh.vertices)
    # Continuous planar XZ projection for architecture; visual Studio QA still required.
    return np.column_stack(((verts[:,0]-bounds[0,0])/span[0],(verts[:,2]-bounds[0,2])/span[2]))
def main():
    manifest={'schema':1,'up':'Y','unit':'source OBJ units (Studio scale verification required)','assets':[]}
    for name,region,kind in ASSETS:
        source=BASE/(name+'.obj')
        mesh=load_obj(source)
        bounds=mesh.bounds.copy()
        tex=texture(kind)
        texpath=BASE/(kind+'_albedo_v16.png')
        tex.save(texpath)
        material=trimesh.visual.material.PBRMaterial(baseColorTexture=tex,metallicFactor=0.0,roughnessFactor=0.85,doubleSided=True)
        outputs=[]
        for lod in (0,1):
            obj=mesh.copy()
            if lod:
                target=max(48,int(len(obj.faces)*0.6))
                obj=obj.simplify_quadric_decimation(face_count=target)
                if len(obj.faces)>=len(mesh.faces): raise ValueError('LOD not reduced: '+name)
            obj.visual=trimesh.visual.TextureVisuals(uv=uv_for(obj,bounds),material=material)
            path=BASE/(name+f'_lod{lod}.glb')
            path.write_bytes(obj.export(file_type='glb'))
            check=trimesh.load(path,force='scene')
            if not check.geometry: raise ValueError('GLB readback failed: '+str(path))
            actual=sum(len(g.faces) for g in check.geometry.values())
            if actual!=len(obj.faces): raise ValueError('GLB triangle mismatch')
            outputs.append({'file':path.name,'triangles':int(actual),'bytes':path.stat().st_size})
        span=bounds[1]-bounds[0]
        manifest['assets'].append({'name':name,'region':region,'source':source.name,'texture':texpath.name,'lods':outputs,'bounds':bounds.round(4).tolist(),'pivot':'original source origin, Y-up','collision_proxy':{'shape':'box','center':((bounds[0]+bounds[1])/2).round(4).tolist(),'size':span.round(4).tolist(),'default_collidable':False},'studio_import':'UNVERIFIED'})
    (BASE/'export_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    (BASE/'IMPORT_GLBS.md').write_text('# KAGEBOUND v16 mesh import\n\nImport each *_lod0.glb with Roblox Studio 3D Importer; inspect material, face orientation, pivot and scale against the approved ART-004 reference. Keep *_lod1.glb for distant replacements. Collision proxies in export_manifest.json are metadata only: build and verify physical traversal separately; keep imported decorative MeshParts CanCollide=false. Do not change server combat authority. Confirm mobile budgets, in-game screenshots and ownership before calling these assets shipped.\n')
    print('Exported',len(manifest['assets']),'assets /',sum(len(a['lods']) for a in manifest['assets']),'GLBs')
if __name__=='__main__': main()
