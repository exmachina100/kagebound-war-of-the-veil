// Structural import preflight for the existing v05 GLB batch, not visual approval.
const fs = require('fs');
const path = require('path');
const assert = require('assert');
const base = path.resolve(__dirname, '../assets/world/dojo_moonfall/v05');
const manifest = JSON.parse(fs.readFileSync(path.join(base, 'manifest.json'), 'utf8'));
const report = [];
for (const [name, asset] of Object.entries(manifest.assets)) {
  const file = path.join(base, asset.lod0);
  const data = fs.readFileSync(file);
  assert(data.toString('ascii', 0, 4) === 'glTF', `${name}: invalid GLB magic`);
  assert(data.readUInt32LE(4) === 2, `${name}: GLB 2 required`);
  assert(data.readUInt32LE(8) === data.length, `${name}: incorrect file length`);
  assert(data.length <= 20 * 1024 * 1024, `${name}: upload size limit`);
  assert(data.readUInt32LE(16) === 0x4e4f534a, `${name}: missing JSON chunk`);
  const json = JSON.parse(data.toString('utf8', 20, 20 + data.readUInt32LE(12)));
  const meshCounts = [];
  let coloredPrimitives = 0;
  const bounds = { min: [Infinity, Infinity, Infinity], max: [-Infinity, -Infinity, -Infinity] };
  for (const mesh of json.meshes) {
    let triangles = 0;
    for (const primitive of mesh.primitives) {
      assert((primitive.mode ?? 4) === 4, `${name}: triangle primitive required`);
      const indices = json.accessors[primitive.indices];
      assert(indices && indices.count % 3 === 0, `${name}: invalid triangle indices`);
      triangles += indices.count / 3;
      const positions = json.accessors[primitive.attributes.POSITION];
      assert(positions && positions.type === 'VEC3', `${name}: missing positions`);
      assert(positions.min?.length === 3 && positions.max?.length === 3, `${name}: missing bounds`);
      for (let axis = 0; axis < 3; axis++) {
        assert(Number.isFinite(positions.min[axis]) && Number.isFinite(positions.max[axis]), `${name}: invalid bounds`);
        bounds.min[axis] = Math.min(bounds.min[axis], positions.min[axis]);
        bounds.max[axis] = Math.max(bounds.max[axis], positions.max[axis]);
      }
      if (primitive.attributes.COLOR_0 !== undefined) coloredPrimitives++;
    }
    assert(triangles <= 20000, `${name}: per-mesh triangle limit exceeded`);
    meshCounts.push(triangles);
  }
  const triangles = meshCounts.reduce((a, b) => a + b, 0);
  assert(triangles === asset.triangles, `${name}: manifest triangle count differs`);
  report.push({name, file: asset.lod0, bytes: data.length, meshes: meshCounts.length,
    triangles, maxMeshTriangles: Math.max(...meshCounts), coloredPrimitives,
    images: (json.images || []).length, localAccessorBounds: bounds});
}
console.log(JSON.stringify({stage: 'structural-preflight', units: manifest.units,
  limits: 'Does not verify normals, watertightness, transformed bounds, Studio scale, colors or visual parity.',
  assets: report}, null, 2));
