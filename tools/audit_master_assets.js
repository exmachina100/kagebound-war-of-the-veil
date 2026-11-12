// Offline inventory: records bytes/hashes and exact duplicates, never deletes assets.
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const root = path.resolve(__dirname, '..');
const entries = [];
function visit(dir) {
  for (const item of fs.readdirSync(dir, {withFileTypes:true})) {
    const file = path.join(dir,item.name);
    if (item.isDirectory()) visit(file);
    else {
      const bytes = fs.readFileSync(file);
      entries.push({path:path.relative(root,file).replaceAll('\\','/'),bytes:bytes.length,
        sha256:crypto.createHash('sha256').update(bytes).digest('hex')});
    }
  }
}
visit(path.join(root,'assets'));
entries.sort((a,b)=>a.path.localeCompare(b.path));
const hashes = new Map();
const formats = {};
for (const entry of entries) {
  const ext = path.extname(entry.path).toLowerCase();
  formats[ext] = (formats[ext] || 0)+1;
  if (!hashes.has(entry.sha256)) hashes.set(entry.sha256,[]);
  hashes.get(entry.sha256).push(entry.path);
}
const report = {scope:'Local bytes only; import and visual status require live Studio evidence',
  files:entries.length,formats,exactDuplicateGroups:[...hashes.values()].filter(x=>x.length>1),entries};
fs.writeFileSync(path.join(root,'docs/assets/MASTER_ASSET_INVENTORY.json'),JSON.stringify(report,null,2)+'\n');
console.log(JSON.stringify({files:report.files,formats,exactDuplicateGroups:report.exactDuplicateGroups.length}));
