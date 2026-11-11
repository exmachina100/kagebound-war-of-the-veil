// KAGEBOUND mask authoring: standalone Node.js source, original geometry.
// Reproducible generator: run node generate_kagebound_wearable_masks.js
const fs=require('fs');
function makeMask(kind){
const V=[],F=[],M=[];const add=(x,y,z)=>{V.push([x,y,z]);return V.length};const face=(a,b,c,mat)=>{F.push([a,b,c]);M.push(mat)};
const N=6,front=[],back=[];const arch=(u,v)=>{let x=(u-.5)*1.45,y=1.3+(v-.5)*1.05;let z=.12+.24*(1-(2*u-1)**2)-.09*(2*v-1)**2;return [x,y,z]};
for(let j=0;j<=N;j++)for(let i=0;i<=N;i++){let p=arch(i/N,j/N);front.push(add(...p));back.push(add(p[0],p[1],p[2]-.105))}
const idx=(a,i,j)=>a[j*(N+1)+i];for(let j=0;j<N;j++)for(let i=0;i<N;i++){let a=idx(front,i,j),b=idx(front,i+1,j),c=idx(front,i+1,j+1),d=idx(front,i,j+1);face(a,b,c,"ivory");face(a,c,d,"ivory");a=idx(back,i,j);b=idx(back,i+1,j);c=idx(back,i+1,j+1);d=idx(back,i,j+1);face(a,c,b,"ink");face(a,d,c,"ink")}
for(let i=0;i<N;i++){let a=idx(front,i,0),b=idx(front,i+1,0),c=idx(back,i+1,0),d=idx(back,i,0);face(a,c,b,"ink");face(a,d,c,"ink");a=idx(front,i,N);b=idx(front,i+1,N);c=idx(back,i+1,N);d=idx(back,i,N);face(a,b,c,"ink");face(a,c,d,"ink")}
for(let j=0;j<N;j++){let a=idx(front,0,j),b=idx(front,0,j+1),c=idx(back,0,j+1),d=idx(back,0,j);face(a,b,c,"ink");face(a,c,d,"ink");a=idx(front,N,j);b=idx(front,N,j+1);c=idx(back,N,j+1);d=idx(back,N,j);face(a,c,b,"ink");face(a,d,c,"ink")}
function tetra(points,mat){const ids=points.map(p=>add(...p));for(const [a,b,c] of [[0,2,1],[0,1,3],[1,2,3],[2,0,3]])face(ids[a],ids[b],ids[c],mat)}
if(kind==="Kitsune"){for(const s of [-1,1])tetra([[s*.42,1.79,.23],[s*.69,1.76,.23],[s*.55,2.3,.15],[s*.54,1.87,.48]],"crimson")}
if(kind==="Oni"){for(const s of [-1,1])tetra([[s*.36,1.77,.25],[s*.57,1.74,.25],[s*.52,2.24,.1],[s*.47,1.83,.45]],"gold")}
if(kind==="Tengu"){tetra([[-.19,1.24,.4],[.19,1.24,.4],[0,1.37,1.05],[0,1.11,.48]],"crimson")}
let lines=["# KAGEBOUND original wearable-mask geometry draft",`# ${kind}; Y-up; front +Z; ground origin`, "mtllib KGB_MASK_Materials_DRAFT_v01.mtl",`o KGB_MASK_${kind}_Wearable_DRAFT_v01`];for(const v of V)lines.push("v "+v.map(n=>n.toFixed(5)).join(" "));let prev="";for(let i=0;i<F.length;i++){if(M[i]!==prev){lines.push("usemtl "+M[i]);prev=M[i]}lines.push("f "+F[i].join(" "))}return {obj:lines.join("\n")+"\n",verts:V.length,tri:F.length};
}
for(const k of ['Kitsune','Oni','Tengu'])fs.writeFileSync('KGB_MASK_'+k+'_Wearable_DRAFT_v01.obj',makeMask(k).obj);
