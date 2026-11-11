"""KAGEBOUND v02 UV draft conversion. Run with original v01 zip archives in parent directory.
Dependencies: trimesh, numpy, Pillow. Static models only; not rigged or Studio-tested.
"""
import os, zipfile, io, json
import numpy as np
import trimesh
from PIL import Image

ROOT = os.path.dirname(os.path.abspath(__file__))
PACKS = [
    "KAGEBOUND_Weapon_Batch_Naginata_Yari_Kanabo_v01.zip",
    "KAGEBOUND_Asset_Batch_Kusarigama_Yumi_Masks_Yokai_20261111.zip",
]
records = []
for archive in PACKS:
    with zipfile.ZipFile(os.path.join(os.path.dirname(ROOT), archive)) as source:
        for member in source.namelist():
            if not member.endswith(".glb"):
                continue
            scene = trimesh.load(io.BytesIO(source.read(member)), file_type="glb", force="scene")
            for mesh in scene.geometry.values():
                if not isinstance(mesh, trimesh.Trimesh) or not len(mesh.vertices):
                    continue
                vertices = np.asarray(mesh.vertices)
                ext = np.ptp(vertices, axis=0)
                axes = np.argsort(ext)[-2:]
                uv = (vertices[:, axes] - vertices[:, axes].min(axis=0)) / np.maximum(ext[axes], 1e-7)
                color = np.array([180, 180, 185, 255], dtype=np.uint8)
                try:
                    visual = mesh.visual
                    if hasattr(visual, "vertex_colors") and len(visual.vertex_colors):
                        color = np.asarray(visual.vertex_colors, dtype=np.uint8).reshape(-1, 4).mean(axis=0).astype(np.uint8)
                    elif hasattr(visual, "material") and getattr(visual.material, "baseColorFactor", None) is not None:
                        color = np.clip(np.asarray(visual.material.baseColorFactor, dtype=float) * 255, 0, 255).astype(np.uint8)
                except Exception:
                    pass
                texture = Image.new("RGBA", (4, 4), tuple(int(x) for x in color))
                mesh.visual = trimesh.visual.TextureVisuals(
                    uv=uv, material=trimesh.visual.material.PBRMaterial(
                        baseColorTexture=texture, metallicFactor=0, roughnessFactor=0.9))
            filename = os.path.basename(member).replace("_DRAFT_v01", "_UV_DRAFT_v02")
            output = os.path.join(ROOT, filename)
            scene.export(output)
            verified = trimesh.load(output, force="scene")
            meshes = [m for m in verified.geometry.values() if isinstance(m, trimesh.Trimesh)]
            records.append({
                "asset": filename, "file_bytes": os.path.getsize(output),
                "components": len(meshes), "triangles": sum(len(m.faces) for m in meshes),
                "watertight_components": sum(m.is_watertight for m in meshes),
                "uv_components": sum(hasattr(m.visual, "uv") and m.visual.uv is not None
                                     and len(m.visual.uv) == len(m.vertices) for m in meshes),
                "degenerate_faces": sum(int(np.sum(m.area_faces <= 1e-12)) for m in meshes),
                "source_archive": archive, "source_member": member,
                "status": "static 3d-draft; not Studio imported",
            })
with open(os.path.join(ROOT, "validation.json"), "w") as handle:
    json.dump(records, handle, indent=2)
print(json.dumps(records, indent=2))
