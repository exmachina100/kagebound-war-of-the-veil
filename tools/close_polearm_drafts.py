"""Close convex boundary loops in the two existing polearm drafts; preserve v01.

Run from the repository root. Standard library only. No Roblox import claim.
The caps preserve existing vertices, bounds, materials and origin. Components
remain overlapping separate solids, not a Boolean union. Not a general remesher.
"""
from collections import Counter, defaultdict
import hashlib
import json
from pathlib import Path


def edges(faces):
    return Counter(tuple(sorted((a, b))) for f in faces
                   for a, b in zip(f, f[1:] + f[:1]))


def volume(vertices, faces):
    result = 0.0
    for f in faces:
        a, b, c = (vertices[i] for i in f)
        result += (a[0]*(b[1]*c[2]-b[2]*c[1])
                   + a[1]*(b[2]*c[0]-b[0]*c[2])
                   + a[2]*(b[0]*c[1]-b[1]*c[0])) / 6
    return result


def repair(kind):
    root = Path('assets/roblox-ready/weapons')
    source = root / f'KGB_WPN_{kind}_GAME_v01.obj'
    target = root / f'KGB_WPN_{kind}_CLOSED_DRAFT_v02.obj'
    vertices, records = [], []
    material = None
    for line in source.read_text().splitlines():
        fields = line.split()
        if not fields:
            continue
        if fields[0] == 'v':
            vertices.append(tuple(map(float, fields[1:])))
        elif fields[0] == 'usemtl':
            material = fields[1]
        elif fields[0] == 'f':
            face = [int(i) - 1 for i in fields[1:]]
            assert len(face) == 3 and material
            records.append((face, material))
    # Separate connected solids by their original vertex indices.
    remaining = set(range(len(records)))
    components = []
    while remaining:
        chosen = {min(remaining)}
        used = set(records[min(remaining)][0])
        while True:
            adjacent = {i for i in remaining - chosen if used.intersection(records[i][0])}
            if not adjacent:
                break
            chosen.update(adjacent)
            used.update(v for i in adjacent for v in records[i][0])
        remaining.difference_update(chosen)
        components.append([records[i] for i in sorted(chosen)])
    report = []
    output = ['# Versioned closure repair; original silhouette/materials preserved.',
              '# Y-up; source origin retained. Not Studio imported.',
              'mtllib ' + target.with_suffix('.mtl').name]
    output += ['v ' + ' '.join(format(n, '.8g') for n in v) for v in vertices]
    for index, component in enumerate(components):
        faces = [r[0] for r in component]
        counts = edges(faces)
        boundary = [(a, b) for f in faces for a, b in zip(f, f[1:] + f[:1])
                    if counts[tuple(sorted((a, b)))] == 1]
        original_boundary_count = len(boundary)
        successor = dict(boundary)
        assert len(successor) == len(boundary), 'branched boundary'
        while successor:
            first = min(successor)
            loop, current = [first], successor.pop(first)
            while current != first:
                loop.append(current)
                current = successor.pop(current)
            # All source loops are planar convex rings or a triangle.
            # Reverse boundary direction to keep adjacent edge winding paired.
            caps = [[loop[0], loop[i+1], loop[i]] for i in range(1, len(loop)-1)]
            component.extend((f, component[0][1]) for f in caps)
            faces.extend(caps)
        signed = volume(vertices, faces)
        if signed < 0:
            component = [(list(reversed(f)), m) for f, m in component]
            faces = [r[0] for r in component]
        assert volume(vertices, faces) > 1e-9
        assert all(n == 2 for n in edges(faces).values())
        directed = Counter((a, b) for f in faces for a, b in zip(f, f[1:] + f[:1]))
        assert all(n == directed[(b, a)] for (a, b), n in directed.items())
        output.append(f'o {kind}_solid_{index+1}')
        last = None
        for face, mat in component:
            if mat != last:
                output.append('usemtl ' + mat)
                last = mat
            output.append('f ' + ' '.join(str(i+1) for i in face))
        report.append({'triangles': len(faces), 'source_boundary_edges': original_boundary_count,
                       'boundary_edges': 0, 'signed_volume': volume(vertices, faces),
                       'consistent_winding': True})
    target.write_bytes(('\n'.join(output) + '\n').encode('utf-8'))
    target.with_suffix('.mtl').write_bytes(source.with_suffix('.mtl').read_bytes())
    return {'sha256_normalization': 'UTF-8 LF (Git content, independent of checkout line endings)',
            'source': source.as_posix(), 'source_sha256': hashlib.sha256(source.read_bytes().replace(b'\r\n', b'\n')).hexdigest(),
            'output': target.as_posix(), 'output_sha256': hashlib.sha256(target.read_bytes()).hexdigest(),
            'vertices': len(vertices), 'triangles': sum(c['triangles'] for c in report),
            'bounds': [[min(v[i] for v in vertices), max(v[i] for v in vertices)] for i in range(3)],
            'components': report, 'studio_imported': False, 'visual_approved': False}


if __name__ == '__main__':
    result = [repair(kind) for kind in ('Naginata', 'Yari')]
    path = Path('assets/roblox-ready/weapons/POLEARMS_v02_validation.json')
    path.write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(result, indent=2))
