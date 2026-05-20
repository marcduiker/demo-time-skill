# Patch actions

Source: https://demotime.show/actions/patch/

Use this category for: applying a precomputed patch to a file (snapshot + diff workflow). For live insert/replace edits authored inline, see `references/text.md`.

## Actions in this category

| Action | Purpose |
|--------|---------|
| `applyPatch` | Update a file by applying a unified diff against a snapshot. |

---

## `applyPatch`

Updates file contents using a patch file, eliminating the need to specify exact text positions by comparing against a snapshot.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `path` | `string` | yes | — | Workspace-relative path to the file being updated. |
| `contentPath` | `string` | yes | — | Path to the snapshot file (typically under `.demo/snapshots/`). |
| `patch` | `string` | yes | — | Path to the patch file (typically under `.demo/patches/`). |
| `insertTypingMode` | `string` | no | `"instant"` | One of `instant`, `line-by-line`, `character-by-character`, `hacker-typer`. |
| `insertTypingSpeed` | `number` | no | — | Delay (ms) between typing units. |

**Example:**

```yaml
- action: applyPatch
  path: src/main.js
  contentPath: .demo/snapshots/main-snapshot.js
  patch: .demo/patches/main-changes.patch
  insertTypingMode: line-by-line
  insertTypingSpeed: 100
```

**Notes / gotchas:** Use this when you have a precomputed diff and don't want to hard-code line positions. For ad-hoc edits, use `insert`/`replace` from `references/text.md`.
