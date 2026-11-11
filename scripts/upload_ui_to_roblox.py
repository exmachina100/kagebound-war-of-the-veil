"""Upload KAGEBOUND PNG icons via Roblox Open Cloud Assets API.

Requires ROBLOX_OPEN_CLOUD_API_KEY and ROBLOX_CREATOR_GROUP_ID or
ROBLOX_CREATOR_USER_ID in GitHub Actions secrets. Only reports IDs after
Roblox confirms the asynchronous operation; moderation can still delay display.
Never place keys in Luau, generated files, logs or Git history.
"""
import json
import os
from pathlib import Path
import time
import requests

BASE = "https://apis.roblox.com/assets/v1"
DIRECTORY = Path("assets/ui/icons/v01")
NAMES = ("slash", "parry", "dash", "veilfall", "kitsune", "oni", "tengu",
         "ofuda", "world_map", "quest", "inventory", "weapon",
         "spirit_shard", "dojo", "clan", "settings")

def main():
    key = os.environ["ROBLOX_OPEN_CLOUD_API_KEY"]
    group = os.environ.get("ROBLOX_CREATOR_GROUP_ID", "").strip()
    user = os.environ.get("ROBLOX_CREATOR_USER_ID", "").strip()
    if bool(group) == bool(user):
        raise RuntimeError("Configure exactly one creator ID: group or user")
    creator = {"groupId": group} if group else {"userId": user}
    headers = {"x-api-key": key}
    result_path = DIRECTORY / "roblox_asset_ids.json"
    known = json.loads(result_path.read_text()) if result_path.exists() else {}
    ids = dict(known.get("ids", {}))
    for name in NAMES:
        if isinstance(ids.get(name), int) and ids[name] > 0:
            continue
        path = DIRECTORY / (name + ".png")
        if not path.exists():
            raise FileNotFoundError(path)
        request_body = {"assetType": "Image", "displayName": "KAGEBOUND UI " + name.replace("_", " ").title(),
                        "description": "Original game interface icon for KAGEBOUND: War of the Veil",
                        "creationContext": {"creator": creator}}
        with path.open("rb") as image:
            response = requests.post(BASE + "/assets",
                headers=headers,
                files={"request": (None, json.dumps(request_body), "application/json"),
                       "fileContent": (path.name, image, "image/png")},
                timeout=90)
        if response.status_code not in (200, 201, 202):
            raise RuntimeError(f"Roblox upload for {name} failed: HTTP {response.status_code} (response omitted to protect secrets)")
        body = response.json()
        asset_id = (body.get("assetId") or body.get("response", {}).get("assetId"))
        operation = body.get("path") or body.get("name")
        for attempt in range(30):
            if asset_id or not operation:
                break
            op_url = ("https://apis.roblox.com/" + operation.lstrip("/")) if not operation.startswith("http") else operation
            op = requests.get(op_url, headers=headers, timeout=30)
            op.raise_for_status()
            state = op.json()
            if state.get("error"):
                raise RuntimeError(f"Roblox operation failed for {name}")
            if state.get("done"):
                asset_id = (state.get("response") or {}).get("assetId")
                break
            time.sleep(3)
        if not asset_id:
            raise RuntimeError(f"No confirmed asset ID for {name}; operation {operation!r}")
        ids[name] = int(asset_id)
        # Checkpoint each confirmed upload to workflow artifacts even on a later failure.
        result_path.write_text(json.dumps({"ids": ids, "creator": creator}, indent=2) + "\n")
        print("Roblox asset confirmed:", name, ids[name])
    print("Uploaded/verified", len(ids), "asset IDs. Review Roblox moderation before enabling UI.")

if __name__ == "__main__":
    main()
