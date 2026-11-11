# Roblox-compliant UI asset publishing

KAGEBOUND's UI assets must be imported into the Roblox creator account or group before in-game ImageLabels can render them. An OpenArt CDN URL or a GitHub PNG URL is **not** a Roblox image asset ID.

## One-time configuration
1. In Roblox Creator Dashboard, create a narrowly scoped Open Cloud API key with permission to create image assets for the game's owning creator/group. Restrict access to the required scope and configure Roblox's applicable IP restrictions as supported. Keep the key private and rotate it if exposed.
2. Add GitHub Actions repository secret `ROBLOX_OPEN_CLOUD_API_KEY`.
3. Add exactly one secret: `ROBLOX_CREATOR_GROUP_ID` (group-owned game) **or** `ROBLOX_CREATOR_USER_ID` (user-owned game).
4. Confirm the GitHub repository allows GitHub Actions to push commits to `main`. Use a PR-based flow if branch protection forbids direct pushes.
5. Verify the experience's actual owner matches the creator used to upload the assets; ownership/permission rules can prevent an asset from appearing in a different creator's experience.

## Pipeline
- Workflow A: [Import OpenArt UI atlas](../.github/workflows/import-openart-ui.yml) downloads the known completed OpenArt PNG and slices sixteen tiles. It writes `assets/ui/icons/v01/atlas.png`, individual PNGs and `manifest.json`.
- Workflow B: [Publish KAGEBOUND UI to Roblox](../.github/workflows/publish-ui-roblox.yml) is manually dispatched **after** A succeeds. It uploads sixteen PNGs through Roblox Open Cloud Assets API, polls for confirmed IDs, writes `roblox_asset_ids.json`, generates `src/shared/UIIconRegistry.lua`, and commits the results.
- Roblox Studio/Rojo then syncs the Luau registry. The game displays uploaded images only after the assets are available to the experience and approved/usable.
- If Open Cloud rejects upload or confirmation, fail the job. Never invent an asset ID. Existing HUD stays usable via native UI fallback.

## Roblox safety and policy requirements
- Upload original artwork only; review generated imagery for copyright, trademark, impersonation, prohibited or inappropriate content before publishing.
- Uploaded images may be moderated; successful API upload does not guarantee immediate rendering or approval.
- No secret, private key or API token in `src/`, `ReplicatedStorage`, client code or public GitHub history.
- Only server code can grant rewards, damage, currency, items or trading outcomes; decorative UI icons never grant authority.
- Prefer Roblox native GUI for controls and accessibility, including safe areas, text scale, mobile input, controller focus and readable low-graphics variants.
- Do not auto-publish unreviewed AI imagery or spam upload retries; review the icon atlas and Roblox creator permissions first.

## Known limitations / verification gate
- No Roblox account/group API credential is available in this ChatGPT connection, so publishing cannot yet be executed or verified here.
- GitHub Actions import and publish job outcomes must be checked; a committed workflow is not proof it has run.
- The first atlas was generated as a 4x4 sheet; verify each cell visually before treating cropped sprites as finished production assets.
- Asset IDs are not populated until the upload workflow succeeds; the registry currently returns nil for unset IDs.
- Roblox Studio rendering, asset permissions and moderation must be checked before marking the UI integrated.
