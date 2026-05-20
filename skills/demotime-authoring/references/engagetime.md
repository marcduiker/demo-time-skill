# EngageTime actions

Source: https://demotime.show/actions/engagetime/

Use this category for: audience engagement (sessions, polls, timeline messages) via the EngageTime companion.

All EngageTime actions require a top-level `sessionId:` key in the demo file (set once for the demo, not per move). The per-move params listed here are in addition to `sessionId`.

## Actions in this category

| Action | Purpose |
|--------|---------|
| `startEngageTimeSession` | Start a new EngageTime session. |
| `closeEngageTimeSession` | Terminate the active session. |
| `showEngageTimeSession` | Show the session link and QR code. |
| `startEngageTimePoll` | Start a poll within an active session. |
| `closeEngageTimePoll` | Close an ongoing poll. |
| `showEngageTimePoll` | Display poll results in the presenter view. |
| `sendEngageTimeMessage` | Post a message to the session timeline. |

---

## `startEngageTimeSession`

Initiates a new EngageTime session for audience engagement.

**Parameters:** None per-move (relies on the demo-level `sessionId`).

**Example:**

```yaml
- action: startEngageTimeSession
```

**Notes / gotchas:** Set `sessionId` at the top level of the demo file.

---

## `closeEngageTimeSession`

Terminates an active EngageTime session.

**Parameters:** None per-move.

**Example:**

```yaml
- action: closeEngageTimeSession
```

**Notes / gotchas:** None.

---

## `showEngageTimeSession`

Displays the session link and QR code in the presenter interface.

**Parameters:** None per-move.

**Example:**

```yaml
- action: showEngageTimeSession
```

**Notes / gotchas:** Use early in the demo to let the audience join.

---

## `startEngageTimePoll`

Initiates a poll within an active EngageTime session.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `pollId` | `string` | yes | — | The identifier of the poll to start. |

**Example:**

```yaml
- action: startEngageTimePoll
  pollId: poll-1
```

**Notes / gotchas:** None.

---

## `closeEngageTimePoll`

Terminates an ongoing poll.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `pollId` | `string` | yes | — | The identifier of the poll to close. |

**Example:**

```yaml
- action: closeEngageTimePoll
  pollId: poll-1
```

**Notes / gotchas:** None.

---

## `showEngageTimePoll`

Displays poll results in the presenter view.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `pollId` | `string` | yes | — | The identifier of the poll to display. |
| `startOnOpen` | `boolean` | no | `false` | Auto-start the poll when displayed. |
| `closeOnOpen` | `boolean` | no | `false` | Auto-close the poll when displayed. Mutually exclusive with `startOnOpen`. |

**Example:**

```yaml
- action: showEngageTimePoll
  pollId: poll-1
  startOnOpen: true
```

**Notes / gotchas:** `startOnOpen` and `closeOnOpen` are mutually exclusive.

---

## `sendEngageTimeMessage`

Posts a message to the EngageTime session timeline.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `type` | `string` | yes | — | Message category — `"demo"`, `"slide"`, or `"custom"`. |
| `title` | `string` | yes | — | The message headline. |
| `message` | `string` | no | — | The message body text. |

**Example:**

```yaml
- action: sendEngageTimeMessage
  type: demo
  title: New message
  message: Optional message body
```

**Notes / gotchas:** None.
