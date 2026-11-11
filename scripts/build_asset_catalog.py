"""Build deterministic asset catalog from all committed KAGEBOUND asset files.

Reference concept art is tracked but never automatically published as an in-game
asset. Runtime PNGs in assets/ui/ and assets/vfx/ are eligible for Roblox upload.
3D source files remain import-required until a verified Roblox mesh workflow exists.
"""
import hashlib
import json
from pathlib import Path

ROOT = Path("assets")
OUTPUT = Path("assets/asset_catalog.json")
EXTENSIONS = {".png", ".jpg", ".jpeg", ".webp", ".obj", ".mtl", ".glb",
              ".gltf", ".fbx", ".rbxm", ".rbxmx", ".json", ".py"}
entries = []
for path in sorted(ROOT.rglob("*")):
    if not path.is_file() or path == OUTPUT or path.suffix.lower() not in EXTENSIONS:
        continue
    rel = path.as_posix()
    category = "ui" if rel.startswith("assets/ui/") else (
        "vfx" if rel.startswith("assets/vfx/") else (
        "concept-reference" if "concept" in path.parts or "concept-" in rel else "production-source"))
    runtime = category in ("ui", "vfx") and path.suffix.lower() == ".png" and path.name != "atlas.png"
    data = path.read_bytes()
    entries.append({"path": rel, "sha256": hashlib.sha256(data).hexdigest(),
                    "bytes": len(data), "category": category,
                    "robloxUploadEligible": runtime,
                    "status": "ready-for-upload" if runtime else "reference-or-import-source"})
OUTPUT.parent.mkdir(parents=True, exist_ok=True)
OUTPUT.write_text(json.dumps({"schemaVersion": 1, "assets": entries}, indent=2) + "\n")
print("Catalogued", len(entries), "files;", sum(x["robloxUploadEligible"] for x in entries), "runtime images")
