// Offline integrity of recorded imports; does not execute Roblox or prove visual parity.
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const assert = require('assert');
const root = path.resolve(__dirname, '..');
const batch = path.join(root, 'assets/studio-import-batch');
const read = name => JSON.parse(fs.readFileSync(path.join(batch, name), 'utf8'));
const sha = bytes => crypto.createHash('sha256').update(bytes).digest('hex');
const manifest = read('manifest.json');
const snapshot = read('studio-snapshot-2026-11-12.json');
const report = read('studio-validation-2026-11-12.json');
const rows = value => Array.isArray(value) ? value : Object.values(value);
assert.equal(snapshot.models.length, 22);
assert.equal(report.validation.meshCount, 328);
assert.equal(rows(report.validation.errors).length, 0);
assert.equal(report.toleranceStuds, 0.001);
for (const m of rows(report.validation.models)) {
  assert(m.maxPrimitiveDeviation <= report.toleranceStuds, m.name);
}
for (const entry of [...manifest.assets, ...read('npc-manifest.json').assets]) {
  const bytes = fs.readFileSync(path.join(batch, entry.file));
  assert.equal(sha(bytes), entry.sha256, entry.file);
  assert.equal(bytes.readUInt32LE(0), 0x46546c67, entry.file);
  assert.equal(bytes.readUInt32LE(8), bytes.length, entry.file);
  const json = JSON.parse(bytes.subarray(20, 20 + bytes.readUInt32LE(12)));
  const primitives = json.meshes.flatMap(m => m.primitives);
  assert.equal(primitives.length, entry.primitives, entry.file);
  assert.equal(primitives.reduce((s,p)=>s+json.accessors[p.indices].count/3,0), entry.triangles, entry.file);
  if (entry.group !== 'npc') {
    assert(/^\d+$/.test(entry.robloxAssetId), entry.file);
    const name = entry.file.replace(/_lod0\.glb$|\.glb$/, '');
    const model = snapshot.models.find(m=>m.name===name);
    assert(model, name);
    assert.equal(rows(model.parts).length, entry.primitives, name);
    for (const part of rows(model.parts)) assert(/^rbxassetid:\/\/\d+$/.test(part.meshId), name);
  }
}
console.log('PASS: 22 recorded Studio models, 328 MeshParts, 25 GLB hashes/counts; NPC imports remain pending.');
