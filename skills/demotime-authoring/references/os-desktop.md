# OS and desktop actions

Source: https://demotime.show/actions/os-and-desktop/

Use this category for: OS-level desktop actions — focus mode, menubar/dock visibility, mute, caffeinate, hide desktop icons.

## Actions in this category

| Action | Purpose |
|--------|---------|
| `macos.enableFocusMode` | Activate Do Not Disturb (macOS). |
| `macos.disableFocusMode` | Deactivate Do Not Disturb (macOS). |
| `macos.hideMenubar` | Auto-hide the macOS menu bar. |
| `macos.showMenubar` | Restore macOS menu bar visibility. |
| `macos.muteVolume` | Mute system audio (macOS). |
| `macos.unmuteVolume` | Unmute system audio (macOS). |
| `macos.enableCaffeine` | Prevent system sleep via `caffeinate`. |
| `macos.disableCaffeine` | Re-enable system sleep. |
| `macos.hideDock` | Auto-hide the macOS dock. |
| `macos.showDock` | Restore macOS dock visibility. |
| `hideDesktopIcons` | Hide desktop icons (macOS and Windows). |
| `showDesktopIcons` | Restore desktop icons (macOS and Windows). |

---

## `macos.enableFocusMode`

Activates Do Not Disturb focus mode on macOS during presentations.

**Parameters:** None documented.

**Example:**

```yaml
- action: macos.enableFocusMode
```

**Notes / gotchas:** macOS only.

---

## `macos.disableFocusMode`

Deactivates Do Not Disturb focus mode on macOS after presentations.

**Parameters:** None documented.

**Example:**

```yaml
- action: macos.disableFocusMode
```

**Notes / gotchas:** macOS only.

---

## `macos.hideMenubar`

Hides the macOS menu bar through auto-hide functionality.

**Parameters:** None documented.

**Example:**

```yaml
- action: macos.hideMenubar
```

**Notes / gotchas:** macOS only.

---

## `macos.showMenubar`

Restores the macOS menu bar visibility by disabling auto-hide.

**Parameters:** None documented.

**Example:**

```yaml
- action: macos.showMenubar
```

**Notes / gotchas:** macOS only.

---

## `macos.muteVolume`

Silences system audio on macOS to prevent interruptions during presentations.

**Parameters:** None documented.

**Example:**

```yaml
- action: macos.muteVolume
```

**Notes / gotchas:** macOS only.

---

## `macos.unmuteVolume`

Restores system audio output on macOS.

**Parameters:** None documented.

**Example:**

```yaml
- action: macos.unmuteVolume
```

**Notes / gotchas:** macOS only.

---

## `macos.enableCaffeine`

Prevents system sleep indefinitely or for a specified duration using macOS's built-in `caffeinate` command.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `duration` | `integer` | no | (indefinite) | Minutes to prevent sleep. Omit for indefinite. |

**Example:**

```yaml
- action: macos.enableCaffeine
  duration: 60
```

**Notes / gotchas:** macOS only. Pair with `macos.disableCaffeine` at end of demo.

---

## `macos.disableCaffeine`

Terminates all active `caffeinate` processes to re-enable system sleep.

**Parameters:** None documented.

**Example:**

```yaml
- action: macos.disableCaffeine
```

**Notes / gotchas:** macOS only.

---

## `macos.hideDock`

Enables auto-hide for the macOS dock, providing a cleaner workspace during presentations.

**Parameters:** None documented.

**Example:**

```yaml
- action: macos.hideDock
```

**Notes / gotchas:** macOS only.

---

## `macos.showDock`

Disables auto-hide to restore persistent macOS dock visibility.

**Parameters:** None documented.

**Example:**

```yaml
- action: macos.showDock
```

**Notes / gotchas:** macOS only.

---

## `hideDesktopIcons`

Removes all desktop icons for distraction-free presentations.

**Parameters:** None documented.

**Example:**

```yaml
- action: hideDesktopIcons
```

**Notes / gotchas:** Works on macOS and Windows.

---

## `showDesktopIcons`

Restores desktop icon visibility after presentations.

**Parameters:** None documented.

**Example:**

```yaml
- action: showDesktopIcons
```

**Notes / gotchas:** Works on macOS and Windows.
