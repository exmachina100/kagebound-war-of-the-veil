// KAGEBOUND static OBJ/MTL validation. Run from repo root:
// node tools/check_kagebound_obj.js
// This does not replace Roblox Studio import, topology, or gameplay QA.
const fs=require("fs");
const path=require("path");
function validate(objText,mtlText,maxTriangles){
 const vertices=[];const mats=new Set();const used=new Set();const bounds=[[Infinity,-Infinity],[Infinity,-Infinity],[Infinity,-Infinity]];
 let triangles=0,parts=0,invalid=0,degenerate=0;
 for(const s of mtlText.split(/\r?\n/)) if(s.startsWith("newmtl ")) mats.add(s.slice(7).trim());
 for(const line of objText.split(/\r?\n/)){
  if(line.startsWith("v ")){
   const xyz=line.trim().split(/\s+/).slice(1).map(Number);
   if(xyz.length!==3||xyz.some(x=>!Number.isFinite(x))) {invalid++;continue}
   vertices.push(xyz);
   xyz.forEach((x,i)=>{bounds[i][0]=Math.min(bounds[i][0],x);bounds[i][1]=Math.max(bounds[i][1],x)});
  }else if(line.startsWith("o ")) parts++;
  else if(line.startsWith("usemtl ")) used.add(line.slice(7).trim());
  else if(line.startsWith("f ")){
   triangles++;const ids=line.trim().split(/\s+/).slice(1).map(x=>Number(x.split("/")[0]));
   if(ids.length!==3||ids.some(i=>!Number.isInteger(i)||i<1||i>vertices.length)){invalid++;continue}
   const [a,b,c]=ids.map(i=>vertices[i-1]);
   const ux=b[0]-a[0],uy=b[1]-a[1],uz=b[2]-a[2];
   const vx=c[0]-a[0],vy=c[1]-a[1],vz=c[2]-a[2];
   if(Math.hypot(uy*vz-uz*vy,uz*vx-ux*vz,ux*vy-uy*vx)<1e-8)degenerate++;
  }
 }
 const missing=[...used].filter(x=>!mats.has(x));
 const pass=vertices.length>0&&triangles>0&&triangles<=maxTriangles&&invalid===0&&degenerate===0&&missing.length===0;
 return {pass,vertices:vertices.length,triangles,parts,invalid,degenerate,missingMaterials:missing,bounds};
}
const assets=[
 ["assets/roblox-ready/weapons/KGB_WPN_Veilblade_Default_GAME_v02",2000],
 ["assets/roblox-ready/environment/KGB_PROP_DojoPracticePost_Default_GAME_v01",1000]
];
let failures=0;
for(const [base,budget] of assets){
 const obj=fs.readFileSync(base+".obj","utf8");
 const mtl=fs.readFileSync(base+".mtl","utf8");
 const report=validate(obj,mtl,budget);
 console.log(report.pass?"PASS":"FAIL",base,JSON.stringify(report));
 if(!report.pass) failures++;
}
if(failures)process.exitCode=1;
