# Preview actions

Source: https://demotime.show/actions/preview/

Use this category for: opening slides, showing image/markdown previews, controlling presentation/zen view.

## Actions in this category

| Action | Purpose |
|--------|---------|
| `openSlide` | Display slides from a Markdown file in the DemoTime presentation interface. |
| `markdownPreview` | Render a Markdown file as a preview within the editor. |
| `imagePreview` | Open an image file in a preview pane with optional custom styling. |

---

## `openSlide`

Displays slides from a Markdown file in the DemoTime presentation interface.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `path` | `string` | yes | — | Workspace-relative path to the slide markdown file. |
| `slide` | `number` | no | `1` | 1-based slide index inside the file. |
| `customTheme` | `string` | no | — | Workspace-relative path or URL to a CSS file for custom theming. See `references/slides-themes.md`. |

**Example:**

```yaml
- action: openSlide
  path: .demo/slides/intro.md
  slide: 1
```

**Notes / gotchas:**
- Set `customTheme` here once for the whole demo rather than on every slide's frontmatter. See `references/slides-themes.md` for the supported CSS variables.
- A workspace-wide alternative is the `demoTime.customTheme` VS Code setting. If the repo already sets that in `.vscode/settings.json`, prefer leaving the wire-up there and don't also add `customTheme:` to YAML — the two will conflict.
- CSS file contents are inlined into the webview at panel creation. Edits to the CSS or to the wire-up don't take effect until the slide preview is closed and reopened (or the window is reloaded). See `references/slides-themes.md`.

---

## `markdownPreview`

Renders a Markdown file as a preview within the editor.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `path` | `string` | yes | — | Workspace-relative path to the Markdown file. |

**Example:**

```yaml
- action: markdownPreview
  path: docs/readme.md
```

**Notes / gotchas:** None.

---

## `imagePreview`

Opens an image file in a preview pane with optional custom styling.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `path` | `string` | yes | — | Workspace-relative path to the image file. |
| `theme` | `string` | no | — | Workspace-relative path to a CSS file for custom styling via the `.preview_view` class. |

**Example:**

```yaml
- action: imagePreview
  path: assets/screenshot.png
  theme: .demo/themes/image.css
```

**Notes / gotchas:** None.
