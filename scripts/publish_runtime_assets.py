"""Upload catalogued runtime images to Roblox Open Cloud, idempotently by SHA256.

The committed asset catalog includes historical concepts, but only files marked
robloxUploadEligible are published. Asset IDs are stored by source SHA, not just
name, to avoid silently reusing an old ID for changed artwork.
"""
import hashlib
import json
import os
from pathlib import Path
import time
import requests

BASE = "https://apis.roblox.com/assets/v1"
CATALOG = Path("assets/asset_catalog.json")
OUTPUT = Path("assets/roblox_runtime_assets.json")
def main():
    key = os.environ["ROBLOX_OPEN_CLOUD_API_KEY"]
    user = os.environ.get("ROBLOX_CREATOR_USER_ID", "")
    if not user.isdecimal() or int(user) <= 0:
        raise ValueError("Invalid Roblox creator user ID")
    creator = {"userId": int(user)}
    catalog = json.loads(CATALOG.read_text())["assets"]
    old = json.loads(OUTPUT.read_text()) if OUTPUT.exists() else {"assets": {}}
    mapping = old["assets"]
    headers = {"x-api-key": key}
    for entry in catalog:
        if not entry["robloxUploadEligible"]:
            continue
        path = Path(entry["path"])
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        if digest != entry["sha256"]:
            raise ValueError(f"Catalog hash mismatch for {path}")
        prev = mapping.get(entry["path"])
        if prev and prev.get("sha256") == digest and int(prev.get("assetId", 0)) > 0:
            continue
        request_body = {"assetType": "Image",
                        "displayName": ("KAGEBOUND " + path.stem.replace("_", " ").title())[:50],
                        "description": "Original KAGEBOUND game asset",
                        "creationContext": {"creator": creator}}
        with path.open("rb") as f:
            response = requests.post(BASE + "/assets", headers=headers,
                files={"request": (None, json.dumps(request_body), "application/json"),
                       "fileContent": (path.name, f, "image/png")}, timeout=90)
        if response.status_code not in (200, 201, 202):
            raise RuntimeError(f"Upload rejected for {path}: HTTP {response.status_code}")
        body = response.json()
        asset_id = body.get("assetId") or (body.get("response") or {}).get("assetId")
        op_name = body.get("path") or body.get("name")
        for _ in range(40):
            if asset_id or not op_name:
                break
            url = op_name if op_name.startswith("https://") else (BASE + "/" + op_name.lstrip("/") if op_name.startswith("operations/") else "https://apis.roblox.com/" + op_name.lstrip("/"))
            op = requests.get(url, headers=headers, timeout=30)
            op.raise_for_status()
            state = op.json()
            if state.get("error"):
                raise RuntimeError(f"Roblox rejected operation for {path}")
            if state.get("done"):
                asset_id = (state.get("response") or {}).get("assetId")
                break
            time.sleep(3)
        if not asset_id:
            raise RuntimeError(f"No confirmed Roblox ID for {path}")
        mapping[entry["path"]] = {"sha256": digest, "assetId": int(asset_id)}
        OUTPUT.write_text(json.dumps({"creatorUserId": int(user), "assets": mapping}, indent=2) + "\n")
        print("Published", path, asset_id)
    OUTPUT.write_text(json.dumps({"creatorUserId": int(user), "assets": mapping}, indent=2) + "\n")
    print("Registered", len(mapping), "runtime image assets")
if __name__ == "__main__":
    main()
