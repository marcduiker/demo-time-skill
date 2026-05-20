# Snippet actions

Source: https://demotime.show/actions/snippet/

Use this category for: inserting reusable snippet sequences and parameterised macro-style snippets.

## Actions in this category

| Action | Purpose |
|--------|---------|
| `snippet` | Inline a reusable move sequence from a snippet file, with optional argument substitution. |

---

## `snippet`

References a reusable snippet file containing moves that can be used across multiple demos.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `contentPath` | `string` | yes | — | Workspace-relative path to the snippet file. Supports `.json`, `.jsonc`, `.yaml`, `.yml`. |
| `args` | `object` | no | — | Key/value pairs substituted into the snippet via `{argumentName}` placeholders. |

**Example:**

```yaml
- action: snippet
  contentPath: ./snippets/insert_and_highlight.json
  args:
    MAIN_FILE: sample.json
    CONTENT_PATH: content.txt
    CONTENT_POSITION: "3"
    HIGHLIGHT_POSITION: "4"
```

**Notes / gotchas:** Snippet files use `{argumentName}` curly-brace placeholders. Format is auto-detected from the file extension.
