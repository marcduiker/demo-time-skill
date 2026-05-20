# Setting actions

Source: https://demotime.show/actions/setting/

Use this category for: reading or writing VS Code settings during a demo, switching themes, toggling presentation/zen view.

## Actions in this category

| Action | Purpose |
|--------|---------|
| `setSetting` | Modify a VS Code setting value. |
| `setTheme` | Switch active color theme. |
| `unsetTheme` | Revert theme to default. |
| `setPresentationView` | Hide UI areas defined by `demoTime.presentationViewToggles`. |
| `unsetPresentationView` | Restore UI elements hidden by presentation view. |
| `backupSettings` | Snapshot current workspace settings to a backup file. |
| `restoreSettings` | Restore previously backed-up settings. |

---

## `setSetting`

Modifies a Visual Studio Code setting to a specified value.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `setting.key` | `string` | yes | — | The VS Code setting identifier. |
| `setting.value` | `any` | yes | — | The value to assign. Use `null` to reset to default. |

**Example:**

```yaml
- action: setSetting
  setting:
    key: workbench.statusBar.visible
    value: false
```

**Notes / gotchas:** Pair with `backupSettings`/`restoreSettings` around the demo to ensure settings are reset on completion.

---

## `setTheme`

Changes the active color theme in Visual Studio Code.

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `theme` | `string` | yes | — | The display name of the theme to activate (e.g. `"Dracula"`). |

**Example:**

```yaml
- action: setTheme
  theme: "Dracula"
```

**Notes / gotchas:** Theme must already be installed.

---

## `unsetTheme`

Removes the currently applied theme and reverts to default settings.

**Parameters:** None documented.

**Example:**

```yaml
- action: unsetTheme
```

**Notes / gotchas:** None.

---

## `setPresentationView`

Hides the UI areas defined by `demoTime.presentationViewToggles` to focus on the code or slides.

**Parameters:** None documented.

**Example:**

```yaml
- action: setPresentationView
```

**Notes / gotchas:** Typical first move of a demo. Configure which UI elements get hidden via the `demoTime.presentationViewToggles` setting.

---

## `unsetPresentationView`

Restores UI elements previously hidden by presentation view mode.

**Parameters:** None documented.

**Example:**

```yaml
- action: unsetPresentationView
```

**Notes / gotchas:** None.

---

## `backupSettings`

Copies current workspace settings to a backup file for later restoration.

**Parameters:** None documented.

**Example:**

```yaml
- action: backupSettings
```

**Notes / gotchas:** Run at the start of a demo so the audience-visible setting changes can be reverted at the end.

---

## `restoreSettings`

Overwrites current settings with previously backed-up workspace configuration.

**Parameters:** None documented.

**Example:**

```yaml
- action: restoreSettings
```

**Notes / gotchas:** Run at end of demo to undo `setSetting` changes.
