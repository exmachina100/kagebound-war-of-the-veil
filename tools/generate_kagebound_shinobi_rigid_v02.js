// KAGEBOUND Shinobi #21 static rigid draft generator. Node 18+. Y-up, -Z forward, 1 unit ~1 draft stud.
const fs=require('fs'),path=require('path');
const shapes={
KGB_CHAR_Shinobi_HoodCrown_STATIC_DRAFT_v02:[[0,4.85,0,.85,.32,.75],[0,5.12,.04,.72,.26,.7],[-.42,4.83,-.16,.18,.32,.5],[.42,4.83,-.16,.18,.32,.5]],
KGB_CHAR_Shinobi_NeckGuard_STATIC_DRAFT_v02:[[0,4.55,0,.85,.16,.62],[-.37,4.45,0,.15,.32,.55],[.37,4.45,0,.15,.32,.55],[0,4.43,.28,.56,.18,.15]],
KGB_CHAR_Shinobi_ShoulderPauldron_STATIC_DRAFT_v02:[[.76,4.32,0,.58,.24,.65],[.89,4.18,-.02,.38,.23,.59],[.72,4.44,.04,.45,.12,.48],[.95,4.3,-.29,.17,.17,.12]]};
function obj(parts){let out=['# KAGEBOUND original closed-component geometry; rigid, unrigged; Y up, front -Z'];let count=0;for(let k=0;k<parts.length;k++){const [x,y,z,w,h,d]=parts[k];out.push('o component_'+(k+1));for(const dx of [-1,1])for(const dy of [-1,1])for(const dz of [-1,1])out.push('v '+[x+dx*w/2,y+dy*h/2,z+dz*d/2].map(n=>n.toFixed(5)).join(' '));for(const q of [[0,1,3,2],[4,6,7,5],[0,4,5,1],[2,3,7,6],[0,2,6,4],[1,5,7,3]]){let a=q.map(n=>n+count+1);out.push('f '+a[0]+' '+a[1]+' '+a[2], 'f '+a[0]+' '+a[2]+' '+a[3]);}count+=8;}return out.join('\n')+'\n';}
const dir=path.join('assets','roblox-ready','characters','shinobi');fs.mkdirSync(dir,{recursive:true});for(const [name,parts] of Object.entries(shapes)){fs.writeFileSync(path.join(dir,name+'.obj'),obj(parts));console.log(name,parts.length*12,'triangles');}
