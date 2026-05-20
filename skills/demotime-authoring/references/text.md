# Text actions

Source: https://demotime.show/actions/text/

Use this category for: transforming text in the active editor — inserting, replacing, deleting, highlighting, selecting, positioning the cursor, writing single lines, and formatting.

## Actions in this category

| Action | Purpose |
|--------|---------|
| `highlight` | Visually emphasize a range, dim/blur the rest. |
| `selection` | Programmatically select a range (enabling copy/cut/delete). |
| `positionCursor` | Move the cursor to a specific location. |
| `insert` | Insert text at a location (with optional typing animation). |
| `replace` | Replace text in a range (with optional typing animation). |
| `write` | Write a single line of text. |
| `format` | Run the editor's format-document command on the active file. |
| `unselect` | Clear any selection or highlight. |
| `delete` | Delete text in a range. |

---

## `highlight`

Visually emphasizes text in the editor at a specific location with optional blur and opacity effects.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `path` | `string` | yes | — | Workspace-relative path to the file. |
| `position` | `string` | conditional | — | Required if `startPlaceholder`/`endPlaceholder` are not used. Line/character range, e.g. `"10,5:20,10"`. |
| `startPlaceholder` | `string` | conditional | — | Text marker for the range start (used when `position` is omitted). |
| `endPlaceholder` | `string` | conditional | — | Text marker for the range end. |
| `zoom` | `number` | no | — | Zoom level. |
| `highlightBlur` | `number` | no | — | Blur (in pixels) applied to non-highlighted content. |
| `highlightOpacity` | `number` | no | — | Opacity (0–1) for non-highlighted content. |
| `highlightWholeLine` | `boolean` | no | `true` | Whether to highlight the entire line. |

**Example:**

```yaml
- action: highlight
  path: src/index.js
  position: "10,5:20,10"
  zoom: 2
  highlightBlur: 2
  highlightOpacity: 0.5
```

**Notes / gotchas:** Pair with `unselect` to clear the highlight later.

---

## `selection`

Selects text in the editor as if manually selected, enabling copy, cut, or delete operations.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `path` | `string` | yes | — | Workspace-relative path to the file. |
| `position` | `string` | conditional | — | Line/character range (use if not using placeholders). |
| `startPlaceholder` | `string` | conditional | — | Text marker for the range start. |
| `endPlaceholder` | `string` | conditional | — | Text marker for the range end. |
| `zoom` | `number` | no | — | Zoom level. |

**Example:**

```yaml
- action: selection
  path: src/index.js
  position: "10,5:20,10"
  zoom: 1.5
```

**Notes / gotchas:** None.

---

## `positionCursor`

Positions the editor cursor at a specific location in a file.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `path` | `string` | yes | — | Workspace-relative path to the file. |
| `position` | `string` | conditional | — | Line/character position, e.g. `"10,5"`. |
| `startPlaceholder` | `string` | conditional | — | Text marker (used if `position` is omitted). |

**Example:**

```yaml
- action: positionCursor
  path: src/index.js
  position: "10,5"
```

**Notes / gotchas:** None.

---

## `insert`

Inserts text into the editor at a specified location with optional typing animations.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `path` | `string` | yes | — | Workspace-relative path to the file. |
| `position` | `string` | conditional | — | Line/character position (use if not using placeholders). |
| `startPlaceholder` | `string` | conditional | — | Text marker for insert start. |
| `endPlaceholder` | `string` | conditional | — | Text marker for insert end. |
| `content` | `string` | no | — | Inline text content to insert. |
| `contentPath` | `string` | no | — | Path to a file whose contents are inserted (typical for multi-line content). |
| `insertTypingMode` | `string` | no | `"instant"` | One of `instant`, `line-by-line`, `character-by-character`, `hacker-typer`. |
| `insertTypingSpeed` | `number` | no | — | Delay (ms) between typing units. |

**Example:**

```yaml
- action: insert
  path: src/index.js
  position: "10,5"
  content: "const greeting = 'Hello';"
  insertTypingMode: character-by-character
  insertTypingSpeed: 50
```

**Notes / gotchas:** Either `content` or `contentPath` should be provided. Prefer `contentPath` for multi-line snippets — put the snippet in `.demo/inserts/<NN>-<desc>.txt`.

---

## `replace`

Replaces text in the editor at a specified location with optional typing animations.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `path` | `string` | yes | — | Workspace-relative path to the file. |
| `position` | `string` | conditional | — | Line/character range. |
| `startPlaceholder` | `string` | conditional | — | Text marker for the start of the range. |
| `endPlaceholder` | `string` | conditional | — | Text marker for the end of the range. |
| `content` | `string` | no | — | Inline replacement text. |
| `contentPath` | `string` | no | — | Path to a file whose contents are the replacement. |
| `insertTypingMode` | `string` | no | `"instant"` | One of `instant`, `line-by-line`, `character-by-character`, `hacker-typer`. |
| `insertTypingSpeed` | `number` | no | — | Delay (ms) between typing units. |

**Example:**

```yaml
- action: replace
  path: src/index.js
  startPlaceholder: "// Old code"
  endPlaceholder: "// End old code"
  content: "const newVar = 42;"
  insertTypingMode: line-by-line
```

**Notes / gotchas:** None.

---

## `write`

Writes a single line of text to the editor at the current or specified location.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `content` | `string` | yes | — | The text to write. |
| `path` | `string` | no | — | Workspace-relative path to the file. |
| `position` | `string` | no | — | Line/character position. |
| `startPlaceholder` | `string` | no | — | Text marker. |

**Example:**

```yaml
- action: write
  content: "Hello World"
  path: src/index.js
  position: "5,0"
```

**Notes / gotchas:** Best for single-line content. Use `insert` for multi-line.

---

## `format`

Formats the content of the currently active file.

**Parameters:** None documented.

**Example:**

```yaml
- action: format
```

**Notes / gotchas:** Uses VS Code's configured formatter for the file's language.

---

## `unselect`

Clears text selection or highlight in a specific file.

**Parameters:** None documented.

**Example:**

```yaml
- action: unselect
```

**Notes / gotchas:** Use after a `highlight` or `selection` action to reset the visual state.

---

## `delete`

Deletes text in the editor at a specified location.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `path` | `string` | yes | — | Workspace-relative path to the file. |
| `position` | `string` | conditional | — | Line/character range. |
| `startPlaceholder` | `string` | conditional | — | Text marker for start. |
| `endPlaceholder` | `string` | conditional | — | Text marker for end. |

**Example:**

```yaml
- action: delete
  path: src/index.js
  position: "10:15"
```

**Notes / gotchas:** None.
