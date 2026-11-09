// KAGEBOUND ORIGINAL low-poly OBJ+MTL generator (no external assets).
// Run: node tools/generate_kagebound_obj.js
const fs = require("fs");
const path = require("path");
const build = function build(kind){
  const V=[],F=[],groups=[];let triangles=0;
  function group(name,mat,v,f){
    const offset=V.length;for(const a of v)V.push(a);
    const lines=[`o ${name}`,`usemtl ${mat}`];
    for(const face of f){for(let i=1;i+1<face.length;i++){lines.push(`f ${face[0]+offset+1} ${face[i]+offset+1} ${face[i+1]+offset+1}`);triangles++;}}
    groups.push(lines.join("\n"));
  }
  function cube(name,mat,c,s,rot=0){
    const [x,y,z]=c,[a,b,d]=s.map(v=>v/2);
    const raw=[[-a,-b,-d],[a,-b,-d],[a,b,-d],[-a,b,-d],[-a,-b,d],[a,-b,d],[a,b,d],[-a,b,d]];
    const vs=raw.map(([xx,yy,zz])=>[x+xx*Math.cos(rot)-yy*Math.sin(rot),y+xx*Math.sin(rot)+yy*Math.cos(rot),z+zz]);
    group(name,mat,vs,[[0,3,2,1],[4,5,6,7],[0,4,7,3],[1,2,6,5],[0,1,5,4],[3,7,6,2]]);
  }
  function loft(name,mat,rings,sides=8){
    const verts=[];for(const r of rings){const [x,y,z,rx,rz]=r;for(let i=0;i<sides;i++){const a=i*2*Math.PI/sides;verts.push([x+rx*Math.cos(a),y,z+rz*Math.sin(a)]);}}
    const faces=[];faces.push(Array.from({length:sides},(_,i)=>sides-1-i));
    for(let j=0;j<rings.length-1;j++)for(let i=0;i<sides;i++){const k=j*sides+i,n=j*sides+(i+1)%sides;faces.push([k,n,n+sides,k+sides]);}
    const start=(rings.length-1)*sides;faces.push(Array.from({length:sides},(_,i)=>start+i));
    group(name,mat,verts,faces);
  }
  function torus(name,mat,cy,major,minor){
    const u=16,v=6,vs=[],fs=[];
    for(let i=0;i<u;i++){const a=2*Math.PI*i/u;for(let j=0;j<v;j++){const b=2*Math.PI*j/v,rr=major+minor*Math.cos(b);vs.push([rr*Math.cos(a),cy+minor*Math.sin(b),rr*Math.sin(a)]);}}
    for(let i=0;i<u;i++)for(let j=0;j<v;j++){const a=i*v+j,b=i*v+(j+1)%v,c=((i+1)%u)*v+(j+1)%v,d=((i+1)%u)*v+j;fs.push([a,b,c,d]);}
    group(name,mat,vs,fs);
  }
  function ribbon(name,mat,points,width=.045){
    const vs=[],fs=[];
    for(const [x,y,z] of points){vs.push([x-width/2,y,z-.014],[x+width/2,y,z-.014],[x+width/2,y,z+.014],[x-width/2,y,z+.014]);}
    for(let i=0;i<points.length-1;i++)for(let j=0;j<4;j++){const k=i*4+j,n=i*4+(j+1)%4;fs.push([k,n,n+4,k+4]);}
    fs.push([3,2,1,0]);const s=(points.length-1)*4;fs.push([s,s+1,s+2,s+3]);
    group(name,mat,vs,fs);
  }
  if(kind==="veilblade"){
    loft("DarkTsuka_Hilt","Ink",[[-.025,-1.12,0,.23,.18],[-.025,1.1,0,.23,.18]],10);
    loft("PommelGold","Gold",[[0,-1.28,0,.29,.23],[0,-1.05,0,.29,.23]],12);
    loft("HiltFerruleGold","Gold",[[0,.9,0,.28,.23],[0,1.12,0,.28,.23]],12);
    for(let i=0;i<8;i++){
      const y=-.89+i*.22,shift=i%2===0?-.10:.10;
      cube(`CrimsonDiamondWrap_${i+1}`,"Crimson",[shift,y,-.196],[.36,.095,.05],i%2===0?.42:-.42);
      cube(`BackWrap_${i+1}`,"Crimson",[-shift,y,.194],[.30,.085,.05],i%2===0?-.38:.38);
    }
    torus("GoldTsubaOuter","Gold",1.17,.66,.10);
    torus("BlackTsubaInner","Ink",1.17,.37,.075);
    loft("GuardHub","Gold",[[0,1.1,0,.31,.27],[0,1.29,0,.31,.27]],10);
    const profile=[[0,1.32,0,.34,.105],[.015,1.8,0,.38,.105],[.045,2.5,0,.35,.10],[.10,3.3,0,.32,.09],[.19,4.2,0,.30,.08],[.33,5.04,0,.25,.065],[.49,5.75,0,.16,.055],[.58,6.01,0,.011,.02]];
    loft("GraphiteKatanaCore","Ink",profile,6);
    const edge=profile.map(([x,y,z,w])=>[x-w-.012,y,z-.004,.045,.041]);
    loft("MagentaVeilbladeEdge","HotPink",edge,4);
    const inner=profile.slice(1,-1).map(([x,y,z,w])=>[x-w*.47,y,-.092,.026,.026]);
    loft("CrimsonInnerCut","Crimson",inner,4);
    cube("GoldBladeCollar","Gold",[0,1.44,0],[.66,.18,.34]);
    // Original shrine hanging talisman and red cloth tassels on the pommel.
    torus("TasselCordRing","Gold",-1.15,.19,.052);
    ribbon("TasselCord","Crimson",[[.20,-1.18,0],[.49,-1.46,0],[.68,-1.75,0]],.09);
    ribbon("RedTasselA","Crimson",[[.68,-1.74,0],[.85,-2.35,-.08],[.99,-2.72,-.14]],.19);
    ribbon("RedTasselB","Crimson",[[.69,-1.73,0],[.57,-2.17,.07],[.46,-2.48,.09]],.14);
    cube("IvoryFoxOmamori","Ivory",[.58,-1.70,-.05],[.29,.45,.10],-.14);
    cube("SealOnOmamori","Crimson",[.58,-1.71,-.112],[.15,.22,.025],-.14);
  }else if(kind==="practicepost"){
    loft("StonePedestal","Stone",[[0,.1,0,2.20,2.20],[0,.44,0,2.0,2.0]],12);
    loft("GoldPedestalRim","Gold",[[0,.40,0,2.03,2.03],[0,.53,0,2.03,2.03]],12);
    cube("CharcoalWoodTrainingBody","Ink",[0,2.7,0],[2.8,4.1,2.2]);
    cube("BodyInset","Graphite",[0,2.77,-1.15],[2.22,3.7,.18]);
    for(let i=0;i<3;i++){
      cube(`CrimsonWrap_${i}`,"Crimson",[0,1.68+i*1.18,-1.29],[2.86,.19,.16],(i%2===0)?.09:-.09);
    }
    cube("GoldBelt","Gold",[0,1.51,-1.3],[2.98,.18,.20]);
    cube("IvoryFoxMask","Ivory",[0,3.66,-1.33],[1.70,1.41,.24]);
    cube("FoxNose","Ink",[0,3.26,-1.49],[.26,.25,.05]);
    cube("EyeMarkL","Crimson",[-.45,3.72,-1.5],[.40,.12,.05],.19);
    cube("EyeMarkR","Crimson",[.45,3.72,-1.5],[.40,.12,.05],-.19);
    cube("FoxEarL","Ivory",[-.65,4.50,-1.34],[.41,.81,.22],.25);
    cube("FoxEarR","Ivory",[.65,4.50,-1.34],[.41,.81,.22],-.25);
    cube("SpiritCore","Violet",[0,2.68,-1.37],[.72,.49,.13]);
    cube("GoldTopCap","Gold",[0,4.89,0],[3.08,.22,2.40]);
    ribbon("CeremonialRibbonA","Crimson",[[1.1,4.85,0],[1.62,4.53,0],[1.76,3.91,0]],.19);
    ribbon("CeremonialRibbonB","Crimson",[[-1.1,4.85,0],[-1.67,4.34,0],[-1.78,3.73,0]],.17);
  }else throw Error("Unknown asset");
  const mats={Ink:[.105,.104,.16],Graphite:[.23,.22,.31],Crimson:[.62,.10,.25],HotPink:[1,.24,.56],Gold:[.93,.67,.31],Ivory:[.97,.91,.96],Violet:[.62,.30,.89],Stone:[.32,.33,.43]};
  const base=kind==="veilblade"?"KGB_WPN_Veilblade_Default_GAME_v02":"KGB_PROP_DojoPracticePost_Default_GAME_v01";
  const obj=[`# KAGEBOUND original low-poly asset ${base}`,"# Gameplay scale: 1 model unit = 1 Roblox stud (validate in Studio)",`mtllib ${base}.mtl`,...V.map(v=>`v ${v.map(n=>n.toFixed(5)).join(" ")}`),...groups].join("\n")+"\n";
  const mtl=Object.entries(mats).map(([n,c])=>[`newmtl ${n}`,`Kd ${c.join(" ")}`,"Ka 0.1 0.1 0.1",`Ks ${n==="Gold"?"0.4 0.4 0.4":"0.08 0.08 0.08"}`,`Ns ${n==="Gold"?"24":"7"}`,"illum 2"].join("\n")).join("\n\n")+"\n";
  const bounds=[0,1,2].map(i=>[Math.min(...V.map(v=>v[i])),Math.max(...V.map(v=>v[i]))]);
  return {base,obj,mtl,vertices:V.length,triangles,bounds,parts:groups.length};
};
for(const kind of ["veilblade","practicepost"]){
  const result=build(kind);
  const folder=path.join("assets","roblox-ready",kind==="veilblade"?"weapons":"environment");
  fs.mkdirSync(folder,{recursive:true});
  fs.writeFileSync(path.join(folder,result.base+".obj"),result.obj,"utf8");
  fs.writeFileSync(path.join(folder,result.base+".mtl"),result.mtl,"utf8");
  console.log(result.base,result.vertices+" vertices",result.triangles+" triangles",result.bounds);
}
