// Original KAGEBOUND low-poly Nodachi and Tanto, Y-up, grip at origin. No external models.
// node tools/generate_kagebound_sword_pair.js > /dev/null (writes files using Node fs)
const fs=require('fs'),path=require('path');
const out=path.join('assets','roblox-ready','weapons');fs.mkdirSync(out,{recursive:true});
const palette={Ink:[0.08,0.09,0.14],Steel:[0.48,0.57,0.66],Edge:[0.74,0.87,0.92],Gold:[0.73,0.51,0.19],Crimson:[0.57,0.08,0.13],Wrap:[0.19,0.20,0.24]};
const mtl=Object.entries(palette).map(([n,c])=>'newmtl '+n+'\nKd '+c.join(' ')+'\nKa 0 0 0\nKs 0.1 0.1 0.1\nNs 16\n').join('\n');
function make(kind){
const long=kind==='Nodachi';const name='KGB_WPN_'+kind+'_Default_DRAFT_v01';
let verts=[],faces=[],parts=[];
function box(n,x0,x1,y0,y1,z0,z1,mat){const v=[[x0,y0,z0],[x1,y0,z0],[x1,y1,z0],[x0,y1,z0],[x0,y0,z1],[x1,y0,z1],[x1,y1,z1],[x0,y1,z1]];let b=verts.length;verts.push(...v);let tris=[[0,2,1],[0,3,2],[4,5,6],[4,6,7],[0,1,5],[0,5,4],[3,7,6],[3,6,2],[0,4,7],[0,7,3],[1,2,6],[1,6,5]];parts.push({n,mat,start:faces.length});faces.push(...tris.map(t=>t.map(i=>b+i+1)));}
const grip=long?1.05:0.58,blade=long?3.15:1.12,w=long?0.19:0.13;
box('pommel',-0.15,0.15,-0.14,0.02,-0.14,0.14,'Gold');
box('handle',-0.115,0.115,0,grip,-0.105,0.105,'Ink');
for(let i=0;i<(long?8:5);i++){let y=.08+i*(grip-.16)/(long?8:5);box('grip_wrap_'+i,-.13,.13,y,y+.035,-.12,.12,'Crimson');}
box('guard',-w*1.9,w*1.9,grip,grip+.11,-.21,.21,'Gold');
box('blade_spine',-w*.65,w*.65,grip+.11,grip+blade,-.075,.075,'Steel');
box('blade_edge',w*.65,w,grip+.13,grip+blade*.94,-.06,.06,'Edge');
box('tip',-w*.40,w*.40,grip+blade-.08,grip+blade+.10,-.04,.04,'Steel');
let lines=['# KAGEBOUND original low-poly '+kind,'# Y up; -Z forward; grip base at 0 0 0','mtllib '+name+'.mtl'];verts.forEach(v=>lines.push('v '+v.join(' ')));parts.forEach((p,i)=>{lines.push('o '+p.n,'usemtl '+p.mat);let end=i+1<parts.length?parts[i+1].start:faces.length;for(let j=p.start;j<end;j++)lines.push('f '+faces[j].join(' '));});
fs.writeFileSync(path.join(out,name+'.obj'),lines.join('\n')+'\n');fs.writeFileSync(path.join(out,name+'.mtl'),mtl);console.log(name,verts.length,faces.length);
}make('Nodachi');make('Tanto');
