# GitHub Copilot actions

Source: https://demotime.show/actions/copilot/

Use this category for: driving GitHub Copilot chat and inline suggestions during a demo.

## Actions in this category

| Action | Purpose |
|--------|---------|
| `openCopilotChat` | Open the Copilot chat panel. |
| `newCopilotChat` | Start a fresh Copilot chat session. |
| `askCopilotChat` | Send a question to Copilot chat. |
| `editCopilotChat` | Open edit-focused chat mode. |
| `agentCopilotChat` | Start a Copilot agent chat session. |
| `customCopilotChat` | Open a chat with a user-defined Copilot mode. |
| `closeCopilotChat` | Close the Copilot chat panel. |
| `cancelCopilotChat` | Abort an in-progress Copilot request without closing the panel. |

---

## `openCopilotChat`

Opens the GitHub Copilot chat panel in VS Code.

**Parameters:** None documented.

**Example:**

```yaml
- action: openCopilotChat
```

**Notes / gotchas:** None.

---

## `newCopilotChat`

Initiates a fresh Copilot chat session.

**Parameters:** None documented.

**Example:**

```yaml
- action: newCopilotChat
```

**Notes / gotchas:** None.

---

## `askCopilotChat`

Sends a question to the Copilot chat interface.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `message` | `string` | no | — | The question to ask. If omitted, the chat opens without sending. |

**Example:**

```yaml
- action: askCopilotChat
  message: "Write a function that returns 'Hello from Demo Time'."
```

**Notes / gotchas:** None.

---

## `editCopilotChat`

Launches an edit-focused chat mode with Copilot.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `message` | `string` | no | — | The editing instruction to send. |

**Example:**

```yaml
- action: editCopilotChat
  message: "Refactor this function to use async/await."
```

**Notes / gotchas:** None.

---

## `agentCopilotChat`

Starts a Copilot agent chat session for autonomous task handling.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `message` | `string` | no | — | The task or query for the agent. |

**Example:**

```yaml
- action: agentCopilotChat
  message: "Add an endpoint that returns the current time."
```

**Notes / gotchas:** None.

---

## `customCopilotChat`

Opens a chat with a user-defined Copilot mode.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `mode` | `string` | yes | — | The custom chat mode name. |
| `message` | `string` | no | — | The message to send. |

**Example:**

```yaml
- action: customCopilotChat
  mode: "Beast Mode 3.1"
  message: "Write a function that returns 'Hello from Demo Time'."
```

**Notes / gotchas:** None.

---

## `closeCopilotChat`

Closes the Copilot chat panel.

**Parameters:** None documented.

**Example:**

```yaml
- action: closeCopilotChat
```

**Notes / gotchas:** None.

---

## `cancelCopilotChat`

Aborts an in-progress Copilot request while keeping the chat panel open.

**Parameters:** None documented.

**Example:**

```yaml
- action: cancelCopilotChat
```

**Notes / gotchas:** None.
