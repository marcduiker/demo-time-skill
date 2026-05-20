# Time actions

Source: https://demotime.show/actions/time/

Use this category for: pauses, waits, countdowns, stopwatch.

## Actions in this category

| Action | Purpose |
|--------|---------|
| `waitForTimeout` | Pause for a fixed duration before proceeding. |
| `waitForInput` | Halt until the user presses a key. |
| `pause` | Stop automation; require manual trigger to proceed. |

---

## `waitForTimeout`

Pauses execution and delays the next action by a specified duration.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `timeout` | `number` | yes | — | Duration in milliseconds. |

**Example:**

```yaml
- action: waitForTimeout
  timeout: 5000
```

**Notes / gotchas:** None.

---

## `waitForInput`

Halts demo progression until the user presses a key to continue.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `message` | `string` | no | — | Display text shown while waiting. |

**Example:**

```yaml
- action: waitForInput
  message: "Press any key to continue"
```

**Notes / gotchas:** None.

---

## `pause`

Stops automation and requires manual triggering of the subsequent step via command or keybinding.

**Parameters:** None documented.

**Example:**

```yaml
- action: pause
```

**Notes / gotchas:** Use between scenes for explicit speaker control. For timed pauses, use `waitForTimeout` instead.
