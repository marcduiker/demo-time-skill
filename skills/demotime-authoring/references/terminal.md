# Terminal actions

Source: https://demotime.show/actions/terminal/

Use this category for: running shell commands in a VS Code terminal, sending keybindings to it, focusing it.

## Actions in this category

| Action | Purpose |
|--------|---------|
| `openTerminal` | Open a terminal, optionally with a named id. |
| `focusTerminal` | Bring focus to the active terminal view. |
| `executeTerminalCommand` | Run a command with optional typing animation. |
| `sendKeybinding` | Send a keyboard shortcut to the focused terminal. |
| `executeScript` | Run a background script and capture its output. |
| `closeTerminal` | Close a terminal. |

---

## `openTerminal`

Opens a terminal in the editor, optionally targeting a specific terminal instance.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `terminalId` | `string` | no | — | Identifier for a specific terminal to open. |

**Example:**

```yaml
- action: openTerminal
  terminalId: app-run
```

**Notes / gotchas:** Reuse the same `terminalId` across scenes that share a shell — see the repo convention in `SKILL.md`.

---

## `focusTerminal`

Brings focus to the active terminal view within the editor.

**Parameters:** None documented.

**Example:**

```yaml
- action: focusTerminal
```

**Notes / gotchas:** Often paired with `sendKeybinding` so the keystrokes land in the terminal.

---

## `executeTerminalCommand`

Runs a command within the terminal with optional typing animation and auto-execution control.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `command` | `string` | yes | — | The command to execute. |
| `terminalId` | `string` | no | `"DemoTime"` | Custom terminal identifier. |
| `autoExecute` | `boolean` | no | `true` | Whether to run the command automatically after typing. |
| `insertTypingMode` | `string` | no | `"instant"` | `instant` or `character-by-character`. |
| `insertTypingSpeed` | `number` | no | — | Delay (ms) between typed characters. |

**Example:**

```yaml
- action: executeTerminalCommand
  terminalId: app-run
  command: npm run dev
  insertTypingMode: character-by-character
  insertTypingSpeed: 75
  autoExecute: true
```

**Notes / gotchas:** For commands the audience should **see typed**, use `character-by-character` with `insertTypingSpeed: 75–100`. For setup, use `instant`.

---

## `sendKeybinding`

Transmits a keyboard shortcut to the terminal after focusing it.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `keybinding` | `string` | yes | — | The key combination, e.g. `ctrl+c`. |

**Example:**

```yaml
- action: focusTerminal
- action: sendKeybinding
  keybinding: ctrl+c
```

**Notes / gotchas:** Always `focusTerminal` first — the keystroke needs an active target.

---

## `executeScript`

Runs a background script and captures its output for use in subsequent steps via `{SCRIPT_<id>}`.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `id` | `string` | yes | — | Identifier for referencing the script's output. |
| `path` | `string` | yes | — | Script file location. |
| `command` | `string` | yes | — | Interpreter — e.g. `node`, `python`, `bash`, `powershell`. |
| `args` | `array<string>` | no | — | Command-line arguments to pass to the script. |

**Example:**

```yaml
- action: executeScript
  id: greeting
  path: greet.mjs
  command: node
  args:
    - Alice
    - "25"
```

**Notes / gotchas:** Reference output downstream as `{SCRIPT_greeting}`.

---

## `closeTerminal`

Closes a terminal, optionally targeting a specific instance by identifier.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `terminalId` | `string` | no | — | Specific terminal to close. If omitted, closes the default terminal. |

**Example:**

```yaml
- action: closeTerminal
  terminalId: app-run
```

**Notes / gotchas:** None.
