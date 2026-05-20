# DemoTime extension actions

Source: https://demotime.show/actions/demotime/

Use this category for: controlling the DemoTime extension itself — triggering another demo by its ID.

Other DemoTime extension features (start/next/previous/reset, presentation/zen view, the countdown timer) are **not** exposed as YAML actions in this category. Where applicable they are reachable as:
- `setPresentationView` / `unsetPresentationView` (see `references/setting.md`)
- `enableZenMode` / `disableZenMode` (see `references/vscode.md`)
- Manual UI interaction (the countdown timer is started/paused by clicking the status-bar clock)
- `executeVSCodeCommand` with the corresponding command ID (see `references/vscode.md`)

## Actions in this category

| Action | Purpose |
|--------|---------|
| `runDemoById` | Trigger another demo by referencing its unique identifier. |

---

## `runDemoById`

Triggers the execution of another demo by referencing its unique identifier.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `id` | `string` | yes | — | The unique identifier of the demo to execute. |

**Example:**

```yaml
- action: runDemoById
  id: my-demo-id
```

**Notes / gotchas:** Useful for composing reusable demo modules — keep small reusable demos in their own YAML files and chain them with `runDemoById`.
