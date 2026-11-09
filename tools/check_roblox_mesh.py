#!/usr/bin/env python3
"""Static preflight for KAGEBOUND low-poly Roblox mesh handoffs.

Checks real geometry only; cannot verify Roblox Studio import, rigging or moderation.
Requires: pip install trimesh numpy
Supported inspection: GLB, GLTF, OBJ. FBX requires Blender/Studio validation.
"""
import argparse
import json
import sys
from pathlib import Path


def validate(path, max_faces):
    try:
        import numpy as np
        import trimesh
    except ImportError as exc:
        return {"file": str(path), "pass": False, "errors": [f"missing dependency: {exc}"]}
    report = {"file": str(path), "pass": False, "meshes": [], "errors": [], "warnings": []}
    if path.suffix.lower() not in {".glb", ".gltf", ".obj"}:
        report["errors"].append("Use GLB, glTF or OBJ for this preflight; inspect FBX rigs in Blender and Roblox Studio")
        return report
    if not path.is_file():
        report["errors"].append("file does not exist")
        return report
    try:
        scene = trimesh.load(str(path), force="scene", process=False)
    except Exception as exc:
        report["errors"].append(f"mesh import failed: {exc}")
        return report
    if not scene.geometry:
        report["errors"].append("no geometry found")
        return report
    for name, mesh in scene.geometry.items():
        if not isinstance(mesh, trimesh.Trimesh):
            report["warnings"].append(f"{name}: non-triangle geometry ignored")
            continue
        faces = int(len(mesh.faces))
        verts = int(len(mesh.vertices))
        record = {"name": name, "vertices": verts, "triangles": faces,
                  "watertight": bool(mesh.is_watertight),
                  "positive_volume": bool(mesh.is_watertight and mesh.volume > 0)}
        report["meshes"].append(record)
        if not verts or not faces or not np.isfinite(mesh.vertices).all():
            report["errors"].append(f"{name}: empty or non-finite geometry")
        if faces > max_faces:
            report["errors"].append(f"{name}: {faces} triangles exceeds per-mesh {max_faces} limit")
        if np.min(mesh.extents) <= 1e-6:
            report["errors"].append(f"{name}: zero-thickness or collapsed bounds")
        if not mesh.is_watertight:
            report["errors"].append(f"{name}: open/non-watertight surface")
        elif mesh.volume <= 0:
            report["errors"].append(f"{name}: inverted face winding / nonpositive signed volume")
        if faces and (mesh.area_faces <= 1e-10).any():
            report["errors"].append(f"{name}: degenerate zero-area triangles")
    report["total_triangles"] = sum(x["triangles"] for x in report["meshes"])
    report["pass"] = bool(report["meshes"]) and not report["errors"]
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mesh", type=Path)
    parser.add_argument("--max-faces", type=int, default=20000,
                        help="per-mesh triangle ceiling (avatar items can be stricter)")
    args = parser.parse_args()
    result = validate(args.mesh, args.max_faces)
    print(json.dumps(result, indent=2))
    return 0 if result["pass"] else 1


if __name__ == "__main__":
    sys.exit(main())
