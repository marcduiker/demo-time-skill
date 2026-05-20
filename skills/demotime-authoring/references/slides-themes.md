# Slide themes and styling

Source: https://demotime.show/slides/themes/ (themes overview) and https://demotime.show/slides/themes/default/ (default-theme CSS variables)

Use this reference when:
- Picking a `theme:` for a slide or for a whole demo.
- Authoring a custom theme `.css` file.
- Adding inline `<style>` overrides to a single slide.

## Selecting a built-in theme

Themes are selected in the slide file's YAML frontmatter:

```markdown
---
theme: <theme-name>
---
```

If `theme:` is omitted, DemoTime falls back to `default`.

A theme can also be set demo-wide via the `openSlide` action's `customTheme:` parameter — see `references/preview.md`.

## Built-in themes

| Theme | Vibe |
|-------|------|
| `default` | Clean, simple. The fallback. |
| `minimal` | Background styling on slide titles. |
| `monomi` | Monochrome-minimalist. |
| `unnamed` | Based on the VS Code "Unnamed" theme. |
| `quantum` | Dark mode with vibrant gradient accents. |
| `frost` | Light mode, clean and airy. |
| `pixels` | Retro, pixel-art inspired. |

## CSS variables exposed by the `default` theme

These variables form the customization surface — overriding them in a custom theme is the supported way to restyle DemoTime slides. All variables default to corresponding VS Code editor theme properties (e.g. `var(--vscode-editor-foreground)`), so unset variables inherit from the active editor theme.

**Top-level (apply to all layouts):**

| Variable | Purpose |
|----------|---------|
| `--demotime-color` | Body text color |
| `--demotime-background` | Slide background |
| `--demotime-heading-color` | Heading text color |
| `--demotime-heading-background` | Heading background |
| `--demotime-font-size` | Base font size |
| `--demotime-link-color` | Link color |
| `--demotime-link-active-color` | Link active/hover color |
| `--demotime-blockquote-border` | Border on blockquote |
| `--demotime-blockquote-background` | Background on blockquote |

**Per-layout variants:** the default theme also exposes layout-scoped variants for `default`, `intro`, `quote`, `section`, `image-left`, `image-right`, and `two-columns`. Each layout supports four variables following the pattern `--demotime-<layout>-<property>`:

- `--demotime-<layout>-background`
- `--demotime-<layout>-color`
- `--demotime-<layout>-heading-color`
- `--demotime-<layout>-heading-background`

Example for the `intro` layout:

```css
:root {
  --demotime-intro-background: #1e1e2e;
  --demotime-intro-color: #cdd6f4;
  --demotime-intro-heading-color: #f5c2e7;
  --demotime-intro-heading-background: transparent;
}
```

## Custom themes — workflow

When the user wants visual styling that built-in themes don't cover:

1. **One-off override on a single slide** → add a `<style>` block inside the slide markdown. Scope by layout class or by a slide-specific selector. Keep it small.
2. **Talk-wide custom theme** →
   - Create `.demo/themes/<name>.css` (repo convention).
   - In that file, override the variables listed above. **Do not invent additional variables** — if a property isn't exposed by the default theme, it isn't themeable through CSS variables and needs an inline style block or a fully custom layout (`layout: custom`).
   - Wire the file up via the `openSlide` action's `customTheme:` parameter — see `references/preview.md`.

## Authoring rules for Claude

1. **Apply theme consistently.** If the user has chosen a theme for the talk, set it once on the demo-level `openSlide` action (or on every slide's frontmatter). Don't mix themes unless the user explicitly asks.
2. **Never invent a theme name.** The seven names above are the complete built-in set. Anything else must be a user-provided custom theme file.
3. **Stay inside the documented CSS variables when writing a custom theme.** Variables outside this list are not part of the public API and may break across DemoTime versions.
