# VS Code actions

Source: https://demotime.show/actions/vscode/

Use this category for: running VS Code commands, sending keybindings, opening files in editor groups.

## Actions in this category

| Action | Purpose |
|--------|---------|
| `executeVSCodeCommand` | Run a VS Code command by ID. |
| `showInfoMessage` | Show an informational message dialog. |
| `setState` | Store a key/value in extension state for later interpolation. |
| `zoomIn` | Increase editor zoom. |
| `zoomOut` | Decrease editor zoom. |
| `zoomReset` | Restore default editor zoom. |
| `openWebsite` | Open a URL in the browser or VS Code editor. |
| `enableZenMode` | Activate Zen Mode. |
| `disableZenMode` | Deactivate Zen Mode. |

---

## `executeVSCodeCommand`

Executes a Visual Studio Code command with optional arguments or file path.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `command` | `string` | yes | — | The command ID to execute. |
| `args` | `any` | no | — | Arguments to pass to the command. |
| `path` | `string` | no | — | Workspace-relative file path. When defined, overrides `args`. |

**Example:**

```yaml
- action: executeVSCodeCommand
  command: editor.action.formatDocument
```

**Notes / gotchas:** None.

---

## `showInfoMessage`

Displays an informational message dialog in Visual Studio Code.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `message` | `string` | yes | — | The text content of the message. |

**Example:**

```yaml
- action: showInfoMessage
  message: "Demo started successfully"
```

**Notes / gotchas:** For prompts and warnings, see `references/interactions.md`.

---

## `setState`

Stores a key-value pair in extension state for reference in subsequent actions using `{STATE_<key>}` syntax.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `state.key` | `string` | yes | — | The state variable identifier. |
| `state.value` | `string` | yes | — | The value to store. |

**Example:**

```yaml
- action: setState
  state:
    key: resourceID
    value: "{DT_CLIPBOARD}"
```

**Notes / gotchas:** Reference downstream as `{STATE_resourceID}`.

---

## `zoomIn`

Magnifies the editor view by a specified increment.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `zoom` | `number` | no | (`demoTime.zoom` setting or `1`) | Magnification level. |

**Example:**

```yaml
- action: zoomIn
  zoom: 3
```

**Notes / gotchas:** None.

---

## `zoomOut`

Reduces the editor view magnification by a specified increment.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `zoom` | `number` | no | (`demoTime.zoom` setting or `1`) | Reduction level. |

**Example:**

```yaml
- action: zoomOut
  zoom: 3
```

**Notes / gotchas:** None.

---

## `zoomReset`

Restores the editor zoom level to its default state.

**Parameters:** None documented.

**Example:**

```yaml
- action: zoomReset
```

**Notes / gotchas:** None.

---

## `openWebsite`

Opens a URL in the browser or within the Visual Studio Code editor.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `url` | `string` | yes | — | The website URL. |
| `openInVSCode` | `boolean` | yes | — | `true` opens inside VS Code; `false` opens in the system browser. |

**Example:**

```yaml
- action: openWebsite
  url: https://demotime.show
  openInVSCode: false
```

**Notes / gotchas:** None.

---

## `enableZenMode`

Activates Zen Mode to provide a distraction-free editing environment.

**Parameters:** None documented.

**Example:**

```yaml
- action: enableZenMode
```

**Notes / gotchas:** None.

---

## `disableZenMode`

Deactivates Zen Mode and returns to normal editor view.

**Parameters:** None documented.

**Example:**

```yaml
- action: disableZenMode
```

**Notes / gotchas:** None.
