"""Validate KAGEBOUND sky-only cubemap edge continuity before Roblox publication.
Checks 12 physical cube edges, 6 face image modes/dimensions and edge RGB deltas.
"""
from pathlib import Path
import argparse
import numpy as np
from PIL import Image
FACES=("Bk","Dn","Ft","Lf","Rt","Up")
def ray(face,u,v):
    return {"Ft":(u,-v,-1),"Bk":(-u,-v,1),"Rt":(1,-v,u),
            "Lf":(-1,-v,-u),"Up":(u,1,v),"Dn":(u,-1,-v)}[face]
def edge_signature(face,side,t):
    u,v=((-1,t) if side=="left" else (1,t) if side=="right" else
         (t,-1) if side=="top" else (t,1))
    d=ray(face,u,v)
    fixed=tuple((i,1 if abs(x-1)<1e-9 else -1)
                for i,x in enumerate(d) if abs(abs(x)-1)<1e-9)
    return fixed,d
def validate(folder,threshold=20):
    imgs={face:np.asarray(Image.open(folder/(face+".png")).convert("RGB"),dtype=np.float32)
          for face in FACES}
    dims={a.shape for a in imgs.values()}
    assert len(dims)==1 and next(iter(dims))[2]==3, dims
    n=next(iter(dims))[0]
    assert next(iter(dims))[1]==n and n>=256
    edges={}
    t=np.linspace(-1+1/n,1-1/n,n)
    for face in FACES:
        for side in ("left","right","top","bottom"):
            a=imgs[face]
            pixels={"left":a[:,0],"right":a[:,-1],"top":a[0],"bottom":a[-1]}[side]
            # Each edge is identified by the two fixed cube-axis signs.
            sig,d=edge_signature(face,side,0)
            key=tuple(sorted(sig))
            # Sort by the free cube axis so reversed face orientations align.
            free=next(i for i in range(3) if i not in [j for j,_ in key])
            d0=edge_signature(face,side,-.5)[1][free]
            d1=edge_signature(face,side,.5)[1][free]
            if d0>d1:pixels=pixels[::-1]
            edges.setdefault(key,[]).append((face,side,pixels))
    assert len(edges)==12, f"Expected 12 edges, got {len(edges)}"
    worst=0.
    for key,pair in edges.items():
        assert len(pair)==2, (key,pair)
        delta=np.abs(pair[0][2]-pair[1][2])
        peak=float(delta.max())
        worst=max(worst,peak)
        if peak>threshold:
            raise AssertionError(f"Seam {key} {pair[0][:2]} vs {pair[1][:2]} peak RGB delta {peak:.1f} > {threshold}")
    print(f"{folder}: 12 cube seams PASS, worst per-channel delta {worst:.1f}, size {n}x{n}")
if __name__=="__main__":
    parser=argparse.ArgumentParser()
    parser.add_argument("--root",default="assets/ui/skybox")
    parser.add_argument("--threshold",type=float,default=20)
    args=parser.parse_args()
    for variant in ("moonfall","veilfall"):
        validate(Path(args.root)/variant/"v01",args.threshold)
