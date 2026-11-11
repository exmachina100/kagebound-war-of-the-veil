"""KAGEBOUND sky-only procedural cubemap. No ground, foliage or structures."""
from pathlib import Path
import numpy as np
from PIL import Image
N=512
q=(np.arange(N)+0.5)*2/N-1
u,v=np.meshgrid(q,q)
directions={
 "Ft":(u,-v,-np.ones_like(u)), "Bk":(-u,-v,np.ones_like(u)),
 "Rt":(np.ones_like(u),-v,u), "Lf":(-np.ones_like(u),-v,-u),
 "Up":(u,np.ones_like(u),v), "Dn":(u,-np.ones_like(u),-v)}
moon=np.array([.42,.51,-.75]);moon/=np.linalg.norm(moon)
axis=np.array([-.18,.87,-.46]);axis/=np.linalg.norm(axis)
def shader(d,veil):
 d=d/np.linalg.norm(d,axis=-1,keepdims=True)
 x,y,z=d[...,0],d[...,1],d[...,2]
 horizon=np.clip((y+.12)/1.2,0,1)
 rgb=np.array([36.,33.,72.])*(1-horizon[...,None])+np.array([6.,10.,36.])*horizon[...,None]
 cloud=np.sin(7*x+3*y+2*np.sin(5*z))*np.cos(8*z-4*y)+.5*np.sin(17*x-11*z+3*y)+.24*np.cos(32*z+13*x+5*y)
 band=np.exp(-((y-.08-.14*np.sin(3*x+2*z))/.34)**2)
 rgb+=np.clip((cloud-.05)*.42*band,0,1)[...,None]*np.array([36,29,61])
 aur=np.exp(-((y-(.44+.13*np.sin(6*x+4*z)))/.18)**2)*(.5+.5*np.sin(17*x+9*z+2*y))
 rgb+=aur[...,None]*np.array([13,29,48])
 dot=np.clip(np.sum(d*moon,axis=-1),-1,1)
 theta=np.arccos(dot)
 rgb+=np.exp(-(theta/.22)**2)[...,None]*np.array([48,43,67])
 rgb=np.where((theta<.105)[...,None],np.array([221,222,236]),rgb)
 if veil:
  ca=np.clip(np.sum(d*axis,axis=-1),-1,1)
  angle=np.arccos(ca)
  tangent=d-ca[...,None]*axis
  tangent/=np.maximum(np.linalg.norm(tangent,axis=-1,keepdims=True),1e-6)
  spin=np.arctan2(tangent[...,2],tangent[...,0])
  ring=np.exp(-((angle-.43-.055*np.sin(9*spin+angle*11))/.065)**2)
  tendril=np.exp(-((angle-(.55+.17*np.sin(5*spin+angle*8)))/.065)**2)
  rgb+=ring[...,None]*np.array([111,37,160])+tendril[...,None]*np.array([44,14,88])
 return np.uint8(np.clip(rgb,0,255))
def build(root=Path("assets/ui/skybox")):
 for variant in ("moonfall","veilfall"):
  folder=root/variant/"v01";folder.mkdir(parents=True,exist_ok=True)
  for face,components in directions.items():
   d=np.stack(components,axis=-1)
   Image.fromarray(shader(d,variant=="veilfall"),"RGB").save(folder/(face+".png"),optimize=True)
if __name__=="__main__":
 build()
 print("Generated 12 sky-only cubemap PNGs, 512x512")
