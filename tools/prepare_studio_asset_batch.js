// Prepare source-preserving GLB imports and an audit manifest. No Roblox uploads.
// Run from the repository root: node tools/prepare_studio_asset_batch.js
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const root = path.resolve(__dirname, '..');
const output = path.join(root, 'assets', 'studio-import-batch');
fs.mkdirSync(output, {recursive: true});
const sha = data => crypto.createHash('sha256').update(data).digest('hex');
function glb(json, bin) {
  let j = Buffer.from(JSON.stringify(json));
  j = Buffer.concat([j, Buffer.alloc((4-j.length%4)%4, 32)]);
  bin = Buffer.concat([bin, Buffer.alloc((4-bin.length%4)%4)]);
  const header = Buffer.alloc(20);
  header.writeUInt32LE(0x46546c67,0); header.writeUInt32LE(2,4);
  header.writeUInt32LE(28+j.length+bin.length,8);
  header.writeUInt32LE(j.length,12); header.writeUInt32LE(0x4e4f534a,16);
  const bh = Buffer.alloc(8); bh.writeUInt32LE(bin.length,0); bh.writeUInt32LE(0x004e4942,4);
  return Buffer.concat([header,j,bh,bin]);
}
function objToGlb(file) {
  const text = fs.readFileSync(file,'utf8'), vertices=[], groups=new Map(), palette={};
  let current='default';
  const mtl = text.match(/^mtllib\s+(.+)$/m);
  if (mtl) {
    let name='default';
    for(const line of fs.readFileSync(path.join(path.dirname(file),mtl[1].trim()),'utf8').split(/\r?\n/)) {
      const p=line.trim().split(/\s+/);
      if(p[0]==='newmtl') name=p.slice(1).join(' ');
      if(p[0]==='Kd') palette[name]=p.slice(1).map(Number);
      if(p[0]==='map_Kd') throw Error('Textured OBJ requires a texture-preserving exporter: '+file);
    }
  }
  for(const line of text.split(/\r?\n/)) {
    const p=line.trim().split(/\s+/);
    if(p[0]==='v') vertices.push(p.slice(1,4).map(Number));
    if(p[0]==='usemtl') current=p.slice(1).join(' ');
    if(p[0]==='f') {
      const ids=p.slice(1).map(x=>{const n=Number(x.split('/')[0]); return n<0?vertices.length+n:n-1;});
      if(!groups.has(current)) groups.set(current,[]);
      for(let i=1;i<ids.length-1;i++) groups.get(current).push(ids[0],ids[i],ids[i+1]);
    }
  }
  if(!vertices.length || !vertices.flat().every(Number.isFinite)) throw Error('Invalid vertices: '+file);
  const min=[0,1,2].map(i=>Math.min(...vertices.map(v=>v[i]))), max=[0,1,2].map(i=>Math.max(...vertices.map(v=>v[i])));
  const chunks=[], views=[], accessors=[], materials=[], primitives=[]; let offset=0;
  function add(buffer,target,accessor) {
    views.push({buffer:0,byteOffset:offset,byteLength:buffer.length,target});
    chunks.push(buffer); offset+=buffer.length;
    accessors.push({...accessor,bufferView:views.length-1}); return accessors.length-1;
  }
  const positions=Buffer.alloc(vertices.length*12); vertices.flat().forEach((n,i)=>positions.writeFloatLE(n,i*4));
  const position=add(positions,34962,{componentType:5126,count:vertices.length,type:'VEC3',min,max});
  for(const [name,ids] of groups) {
    const indices=Buffer.alloc(ids.length*4);
    ids.forEach((n,i)=>{if(n<0 || n>=vertices.length) throw Error('Invalid index');indices.writeUInt32LE(n,i*4);});
    for(let i=0;i<ids.length;i+=3) {
      const [a,b,c]=ids.slice(i,i+3).map(n=>vertices[n]);
      const u=b.map((x,j)=>x-a[j]), v=c.map((x,j)=>x-a[j]);
      if(Math.hypot(u[1]*v[2]-u[2]*v[1],u[2]*v[0]-u[0]*v[2],u[0]*v[1]-u[1]*v[0])<1e-10) throw Error('Degenerate triangle: '+file);
    }
    const linear=(palette[name]||[0.5,0.5,0.5]).map(c=>c<=0.04045?c/12.92:((c+0.055)/1.055)**2.4);
    materials.push({name,pbrMetallicRoughness:{baseColorFactor:[...linear,1],metallicFactor:0,roughnessFactor:0.8}});
    primitives.push({attributes:{POSITION:position},indices:add(indices,34963,{componentType:5125,count:ids.length,type:'SCALAR'}),material:materials.length-1});
  }
  return glb({asset:{version:'2.0',generator:'KAGEBOUND source-preserving import preparation'},scene:0,scenes:[{nodes:[0]}],nodes:[{name:path.basename(file,'.obj'),mesh:0}],meshes:[{primitives}],materials,buffers:[{byteLength:offset}],bufferViews:views,accessors},Buffer.concat(chunks));
}
const files=[];
for(const version of ['v08','v07']) {
  const dir=path.join(root,'assets/world/dojo_moonfall',version);
  for(const name of fs.readdirSync(dir).filter(n=>/_lod0\.(glb|gltf)$/.test(n))) files.push({file:path.join(dir,name),group:version});
}
for(const name of ['KGB_WPN_Veilblade_Default_GAME_v02','KGB_WPN_Nodachi_Default_DRAFT_v01','KGB_WPN_Tanto_Default_DRAFT_v01','KGB_WPN_Naginata_CLOSED_DRAFT_v02','KGB_WPN_Yari_CLOSED_DRAFT_v02']) files.push({file:path.join(root,'assets/roblox-ready/weapons',name+'.obj'),group:'weapon'});
for(const kind of ['Kitsune','Oni','Tengu']) files.push({file:path.join(root,'assets/roblox-ready/masks',`KGB_MASK_${kind}_Wearable_DRAFT_v01.obj`),group:'mask'});
const records=[];
for(const {file,group} of files) {
  const data=fs.readFileSync(file); let prepared=data;
  if(file.endsWith('.obj')) prepared=objToGlb(file);
  if(file.endsWith('.gltf')) {
    const json=JSON.parse(data); if(json.buffers.length!==1 || !json.buffers[0].uri.startsWith('data:')) throw Error('External buffer');
    const bin=Buffer.from(json.buffers[0].uri.split(',')[1],'base64'); delete json.buffers[0].uri; prepared=glb(json,bin);
  }
  const json=JSON.parse(prepared.subarray(20,20+prepared.readUInt32LE(12)).toString());
  const primitives=json.meshes.flatMap(m=>m.primitives);
  const triangles=primitives.reduce((sum,p)=>sum+json.accessors[p.indices].count/3,0);
  if(primitives.some(p=>json.accessors[p.indices].count/3>20000)) throw Error('Triangle budget exceeded');
  const name=group+'_'+path.basename(file).replace(/\.(obj|gltf|glb)$/,'.glb');
  fs.writeFileSync(path.join(output,name),prepared);
  records.push({source:path.relative(root,file).replaceAll('\\','/'),sourceSha256:sha(data),file:name,sha256:sha(prepared),bytes:prepared.length,group,primitives:primitives.length,triangles,materials:json.materials||[],status:'prepared; not uploaded or Studio validated'});
}
fs.writeFileSync(path.join(output,'manifest.json'),JSON.stringify({sourceUnits:'preserved; world v08 authored in approximate studs; verify in Studio',assets:records},null,2)+'\n');
console.log(JSON.stringify(records.map(({file,triangles,primitives})=>({file,triangles,primitives})),null,2));
