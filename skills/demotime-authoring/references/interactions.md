# Interaction actions

Source: https://demotime.show/actions/interactions/

Use this category for: clipboard ops, simulated typing, OS-level keystrokes (Enter, Tab, arrows, etc.).

## Actions in this category

| Action | Purpose |
|--------|---------|
| `copyToClipboard` | Copy text or file content to the clipboard. |
| `pasteFromClipboard` | Paste clipboard content at the cursor. |
| `copyFromSelection` | Copy the active editor's current selection. |
| `typeText` | Simulate typing text character-by-character. |
| `sendKeybinding` | Trigger an OS-level keyboard shortcut. |
| `pressEnter` | Simulate pressing Enter. |
| `pressTab` | Simulate pressing Tab. |
| `pressArrowLeft` | Simulate pressing the Left arrow. |
| `pressArrowRight` | Simulate pressing the Right arrow. |
| `pressArrowUp` | Simulate pressing the Up arrow. |
| `pressArrowDown` | Simulate pressing the Down arrow. |
| `pressEscape` | Simulate pressing Escape. |
| `pressBackspace` | Simulate pressing Backspace. |
| `pressDelete` | Simulate pressing Delete. |

---

## `copyToClipboard`

Copies text or file content to the clipboard for use in subsequent paste operations.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `content` | `string` | no | — | Inline text to copy. |
| `contentPath` | `string` | no | — | Path to a file whose contents are copied. |

**Example:**

```yaml
- action: copyToClipboard
  content: "Hello from Demo Time!"
```

**Notes / gotchas:** Provide either `content` or `contentPath`.

---

## `pasteFromClipboard`

Pastes the current clipboard contents at the cursor position in the active editor.

**Parameters:** None documented.

**Example:**

```yaml
- action: pasteFromClipboard
```

**Notes / gotchas:** None.

---

## `copyFromSelection`

Copies currently selected text in the active editor, equivalent to pressing Ctrl/Cmd+C.

**Parameters:** None documented.

**Example:**

```yaml
- action: copyFromSelection
```

**Notes / gotchas:** None.

---

## `typeText`

Simulates typing text character by character at the current cursor position.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `content` | `string` | yes | — | The text to type. |
| `insertTypingSpeed` | `number` | no | — | Milliseconds between each character. |

**Example:**

```yaml
- action: typeText
  content: "This is typed slowly..."
  insertTypingSpeed: 100
```

**Notes / gotchas:** None.

---

## `sendKeybinding`

Triggers a keyboard shortcut at the OS level (e.g. `ctrl+shift+p`). Distinct from the terminal-scoped `sendKeybinding` in `references/terminal.md` — this one fires OS-wide, not into a specific terminal.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `keybinding` | `string` | yes | — | Keyboard shortcut, `+` separated. |

**Example:**

```yaml
- action: sendKeybinding
  keybinding: ctrl+shift+p
```

**Notes / gotchas:** Same action name as the terminal-category `sendKeybinding`. Which scope applies depends on what's focused.

---

## `pressEnter`

Simulates pressing the Enter key to confirm commands or move to the next line.

**Parameters:** None documented.

**Example:**

```yaml
- action: pressEnter
```

**Notes / gotchas:** None.

---

## `pressTab`

Simulates pressing the Tab key for field navigation or code indentation.

**Parameters:** None documented.

**Example:**

```yaml
- action: pressTab
```

**Notes / gotchas:** None.

---

## `pressArrowLeft`

Simulates pressing the Left arrow key.

**Parameters:** None documented.

**Example:**

```yaml
- action: pressArrowLeft
```

**Notes / gotchas:** None.

---

## `pressArrowRight`

Simulates pressing the Right arrow key.

**Parameters:** None documented.

**Example:**

```yaml
- action: pressArrowRight
```

**Notes / gotchas:** None.

---

## `pressArrowUp`

Simulates pressing the Up arrow key.

**Parameters:** None documented.

**Example:**

```yaml
- action: pressArrowUp
```

**Notes / gotchas:** None.

---

## `pressArrowDown`

Simulates pressing the Down arrow key.

**Parameters:** None documented.

**Example:**

```yaml
- action: pressArrowDown
```

**Notes / gotchas:** None.

---

## `pressEscape`

Simulates pressing the Escape key to close dialogs or cancel operations.

**Parameters:** None documented.

**Example:**

```yaml
- action: pressEscape
```

**Notes / gotchas:** None.

---

## `pressBackspace`

Deletes the character before the cursor position.

**Parameters:** None documented.

**Example:**

```yaml
- action: pressBackspace
```

**Notes / gotchas:** None.

---

## `pressDelete`

Deletes the character after the cursor position.

**Parameters:** None documented.

**Example:**

```yaml
- action: pressDelete
```

**Notes / gotchas:** None.
