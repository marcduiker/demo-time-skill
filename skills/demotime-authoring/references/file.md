# File actions

Source: https://demotime.show/actions/file/

Use this category for: opening, renaming, creating, deleting, copying, moving files in the workspace.

## Actions in this category

| Action | Purpose |
|--------|---------|
| `open` | Open a file in the editor. |
| `create` | Create a new file (with optional content). |
| `save` | Save the currently open file. |
| `rename` | Rename a file. |
| `move` | Move a file to a new location. |
| `copy` | Duplicate a file to a new location. |
| `deleteFile` | Delete a file from the workspace. |
| `close` | Close the currently open file. |
| `closeAll` | Close all open files. |

---

## `open`

Opens a file in the editor at the specified path.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `path` | `string` | yes | — | Workspace-relative path to the file. |
| `focusTop` | `boolean` | no | `true` | Whether the editor focuses the top of the file when opened. |

**Example:**

```yaml
- action: open
  path: README.md
  focusTop: true
```

**Notes / gotchas:** None.

---

## `create`

Creates a new file with optional content.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `path` | `string` | yes | — | Workspace-relative path for the new file. |
| `content` | `string` | no | — | Inline file content; best for single-line text. |
| `contentPath` | `string` | no | — | Path to a file (e.g. under `.demo/`) whose contents are used as the new file's body. |

**Example:**

```yaml
- action: create
  path: src/new-file.ts
  contentPath: .demo/inserts/new-file.txt
```

**Notes / gotchas:** Use `contentPath` for multi-line content; use `content` only for short single-line text.

---

## `save`

Saves the currently open file in the editor.

**Parameters:** None documented.

**Example:**

```yaml
- action: save
```

**Notes / gotchas:** None.

---

## `rename`

Renames a file.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `path` | `string` | yes | — | Workspace-relative path to the source file. |
| `dest` | `string` | yes | — | New name or path. |
| `overwrite` | `boolean` | no | `false` | Whether to overwrite the destination if it exists. |

**Example:**

```yaml
- action: rename
  path: src/old.ts
  dest: src/new.ts
```

**Notes / gotchas:** None.

---

## `move`

Moves a file to a new location.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `path` | `string` | yes | — | Workspace-relative path to the source file. |
| `dest` | `string` | yes | — | New location path. |
| `overwrite` | `boolean` | no | `false` | Whether to overwrite the destination if it exists. |

**Example:**

```yaml
- action: move
  path: src/old/file.ts
  dest: src/new/file.ts
```

**Notes / gotchas:** None.

---

## `copy`

Duplicates a file to a new location.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `path` | `string` | yes | — | Workspace-relative path to the source file. |
| `dest` | `string` | yes | — | Destination path for the copy. |
| `overwrite` | `boolean` | no | `false` | Whether to overwrite the destination if it exists. |

**Example:**

```yaml
- action: copy
  path: templates/component.tsx
  dest: src/components/Button.tsx
```

**Notes / gotchas:** None.

---

## `deleteFile`

Deletes a file from the workspace.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `path` | `string` | yes | — | Workspace-relative path to the file to delete. |

**Example:**

```yaml
- action: deleteFile
  path: tmp/scratch.txt
```

**Notes / gotchas:** Irreversible — be careful when scripting demos that delete user files.

---

## `close`

Closes the currently open file in the editor.

**Parameters:** None documented.

**Example:**

```yaml
- action: close
```

**Notes / gotchas:** None.

---

## `closeAll`

Closes all open files in the editor.

**Parameters:** None documented.

**Example:**

```yaml
- action: closeAll
```

**Notes / gotchas:** None.
