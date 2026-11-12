#!/usr/bin/env python3
"""KAGEBOUND sky cubemap production gate. No Roblox publishing or IDs here.

Validates dimensions, alpha, and all twelve physical cube edges by sampling
face directions in world space. Reports errors rather than silently modifying
approved production images. Run: python scripts/validate_skybox_faces.py
"""
from pathlib import Path
from PIL import Image
import argparse
import json
import math

FACES = ("Bk", "Dn", "Ft", "Lf", "Rt", "Up")

# Roblox Skybox faces use conventional cube-map orientation. This mapping
# must also be confirmed with a six-direction Studio orientation test.
def direction(face, u, v):
    if face == "Rt": return (1, -v, -u)
    if face == "Lf": return (-1, -v, u)
    if face == "Up": return (u, 1, v)
    if face == "Dn": return (u, -1, -v)
    if face == "Ft": return (u, -v, 1)
    return (-u, -v, -1)

def edge_samples(face, edge, n):
    for i in range(n):
        t = -1 + 2 * (i + 0.5) / n
        u, v = {"left": (-1, t), "right": (1, t),
                "top": (t, -1), "bottom": (t, 1)}[edge]
        yield direction(face, u, v), (u, v)

def nearest_edge(face, vector):
    x, y, z = vector
    best = None
    for edge in ("left", "right", "top", "bottom"):
        for d, uv in edge_samples(face, edge, 1):
            dot = sum(a*b for a,b in zip(d, vector))
            if best is None or dot > best[0]: best = (dot, edge)
    return best[1]

def validate(folder, samples=64, max_mean=32.0):
    images = {}
    errors = []
    for name in FACES:
        path = folder / (name + ".png")
        if not path.is_file():
            errors.append("missing " + str(path))
            continue
        with Image.open(path) as im:
            if im.width != im.height or im.width < 256:
                errors.append(f"{name}: expected square image >=256px, got {im.size}")
            if im.mode in ("RGBA", "LA") and im.getchannel("A").getextrema() != (255, 255):
                errors.append(f"{name}: transparency prohibited")
            images[name] = im.convert("RGB")
    if len(images) != 6:
        return {"pass": False, "errors": errors, "edges": []}
    sizes = {im.size for im in images.values()}
    if len(sizes) != 1: errors.append("face resolutions differ")
    # Match edge texels by world-space direction; deduplicate 12 cube edges.
    buckets = {}
    for face in FACES:
        im = images[face]
        w, h = im.size
        for edge in ("left", "right", "top", "bottom"):
            pixels = []
            for vec, (u,v) in edge_samples(face, edge, samples):
                px = max(0,min(w-1,round((u+1)*(w-1)/2)))
                py = max(0,min(h-1,round((v+1)*(h-1)/2)))
                pixels.append((vec, im.getpixel((px,py))))
            mid = pixels[samples//2][0]
            # physical cube edge key: fixed signed axes of the midpoint
            key = tuple((i, 1 if value>0 else -1) for i,value in enumerate(mid) if abs(value)>0.99)
            buckets.setdefault(key, []).append((face,edge,pixels))
    reports = []
    for key, pair in sorted(buckets.items()):
        if len(pair) != 2:
            errors.append(f"edge {key} has {len(pair)} contributors instead of 2")
            continue
        a,b = pair
        ordered = sorted(b[2], key=lambda item: sum((item[0][k]-a[2][0][0][k])**2 for k in range(3)))
        # determine orientation by nearest endpoint
        p = b[2]
        if sum((p[-1][0][k]-a[2][0][0][k])**2 for k in range(3)) < sum((p[0][0][k]-a[2][0][0][k])**2 for k in range(3)):
            p = list(reversed(p))
        mean = sum(sum(abs(x-y) for x,y in zip(i[1],j[1]))/3 for i,j in zip(a[2],p))/samples
        reports.append({"faces":[a[0],b[0]],"edges":[a[1],b[1]],"mean_rgb_delta":round(mean,2)})
        if mean > max_mean:
            errors.append(f"seam {a[0]}:{a[1]} / {b[0]}:{b[1]} mean delta {mean:.1f} > {max_mean}")
    if len(reports) != 12: errors.append(f"expected 12 edges, got {len(reports)}")
    return {"pass":not errors,"errors":errors,"edges":reports}

if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("--root", default="assets/ui/skybox")
    p.add_argument("--max-mean",type=float,default=32)
    args = p.parse_args()
    results = {v:validate(Path(args.root)/v/"v01",max_mean=args.max_mean) for v in ("moonfall","veilfall")}
    print(json.dumps(results,indent=2))
    raise SystemExit(0 if all(r["pass"] for r in results.values()) else 1)
