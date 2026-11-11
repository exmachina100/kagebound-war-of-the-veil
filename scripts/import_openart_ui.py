"""Import OpenArt 4x4 KAGEBOUND UI atlas; validate, crop and commit via GitHub Actions."""
import io
import json
import os
from pathlib import Path
import requests
from PIL import Image

URL = os.environ["OPENART_IMAGE_URL"]
if not URL.startswith("https://cdn.openart.ai/"):
    raise ValueError("Only OpenArt CDN URLs are accepted")
names = [
    "slash", "parry", "dash", "veilfall",
    "kitsune", "oni", "tengu", "ofuda",
    "world_map", "quest", "inventory", "weapon",
    "spirit_shard", "dojo", "clan", "settings",
]
response = requests.get(URL, timeout=45)
response.raise_for_status()
if len(response.content) > 15_000_000:
    raise ValueError("Image exceeds 15MB")
image = Image.open(io.BytesIO(response.content)).convert("RGBA")
if image.width != image.height or image.width < 512 or image.width % 4:
    raise ValueError(f"Expected square atlas divisible by four, got {image.size}")
output = Path("assets/ui/icons/v01")
output.mkdir(parents=True, exist_ok=True)
image.save(output / "atlas.png", optimize=True)
tile = image.width // 4
manifest = {"source": URL, "atlas": "atlas.png", "size": list(image.size), "tileSize": tile, "icons": {}}
for index, name in enumerate(names):
    x, y = index % 4, index // 4
    sprite = image.crop((x * tile, y * tile, (x + 1) * tile, (y + 1) * tile))
    sprite.save(output / f"{name}.png", optimize=True)
    manifest["icons"][name] = {"file": f"{name}.png", "rect": [x * tile, y * tile, tile, tile]}
(output / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
print("Imported", len(names), "UI sprites at", image.size)
