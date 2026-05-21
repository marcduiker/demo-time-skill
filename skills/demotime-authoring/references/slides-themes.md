# Slide themes and styling

Source: https://demotime.show/slides/themes/ (themes overview) and https://demotime.show/slides/themes/default/ (default-theme CSS variables). Selector/scoping details below were verified against the upstream source (`apps/webviews/src/themes/*.css` and `apps/webviews/src/components/preview/MarkdownPreview.tsx`) because the public docs are slightly out of date on how variable overrides need to be scoped.

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

If `theme:` is omitted, DemoTime falls back to `default`. The container is rendered as `<div class="slide <theme-name> ...">`, so the active theme name becomes a class on the slide root.

A custom theme `.css` file can be wired up two ways — see *Wiring up a custom theme* below.

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

These variables form the customization surface. **All variables are declared inside the `.slide.default { ... }` block in the upstream theme file**, not on `:root`. This matters for overrides — see *Why overrides must be scoped to `.slide.<theme>`* below.

**Top-level (apply to all layouts):**

| Variable | Purpose |
|----------|---------|
| `--demotime-color` | Body text color |
| `--demotime-background` | Slide background |
| `--demotime-heading-color` | Heading text color (h1–h5 fall back to this) |
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

**Important: per-layout `heading-color` only re-colors `h1`.** Inside each layout block (e.g. `.intro`, `.section`), the default theme only writes `h1 { color: var(--demotime-<layout>-heading-color); }`. `h2`–`h5` inherit the *top-level* rule `.slide.default h2 { color: var(--demotime-heading-color); }`. To recolor h2–h5 per layout, you need a selector — variables alone aren't enough. See *Restyling beyond the variable surface*.

## Why overrides must be scoped to `.slide.<theme>`

CSS custom properties resolve by **inheritance from the closest ancestor that defines them**, not by global selector specificity. The slide DOM looks like:

```
<html>
  <div class="slide default">    ← default.css declares ALL variables here
    <div class="intro">           ← uses var(--demotime-intro-background)
      ...
```

If you write `:root { --demotime-intro-background: #1e1e2e; }` in a custom theme, the lookup from `.intro` walks up and **stops at `.slide.default`** — which redefines `--demotime-intro-background: var(--demotime-background)`. Your `:root` value is shadowed and never reaches the consuming element. The public docs show `:root` examples that don't actually take effect.

**Always scope variable overrides to the slide container.** For the default theme that means:

```css
.slide.default {
  --demotime-intro-background: #1e1e2e;
  --demotime-intro-color: #cdd6f4;
  --demotime-intro-heading-color: #f5c2e7;
  --demotime-intro-heading-background: transparent;
}
```

If the talk uses a different built-in theme as its base, scope to that theme name instead — e.g. `.slide.frost { ... }`. The selector must match the actual class DemoTime renders (slide class + theme name).

## Restyling beyond the variable surface

When the documented variables don't reach what you want to style (h2–h5 colors, paragraph styles, list bullets, code blocks, etc.), use direct selectors **nested inside or qualified with `.slide.<theme>`** so they beat the upstream rules.

The base theme's rules look like `.slide.default h2 { color: var(--demotime-heading-color); }` — specificity (0,2,1). Your override needs to match or exceed that:

```css
.slide.default {
  /* Variables for h1 (which IS mapped per layout): */
  --demotime-intro-heading-color: #F0C75E;
  --demotime-section-heading-color: #F0C75E;

  /* Selectors for h2 (which is NOT mapped per layout): */
  .default h2,
  .intro h2,
  .section h2 {
    color: #F0C75E;
  }
}
```

Nested under `.slide.default`, the h2 rule resolves to `.slide.default .intro h2` → specificity (0,3,1), which beats `.slide.default h2` (0,2,1). A flat `.intro h2 { ... }` at the top level (0,1,1) loses and won't apply.

This rule of thumb applies to any property the upstream theme already sets directly on element selectors inside `.slide.default { ... }`: paragraph, list, link, blockquote, code — qualify with `.slide.default` (via nesting or by writing the full selector) to win.

## Wiring up a custom theme

DemoTime supports two ways to point at a custom CSS file. Pick one — ask the user which they prefer.

1. **VS Code setting `demoTime.customTheme`** (workspace or user level). Set it to a workspace-relative path (e.g. `.demo/themes/diagrid.css`) or an `https://...` URL. This applies the theme to every slide preview in the workspace, regardless of which demo is running.
2. **`customTheme:` parameter on the `openSlide` action** in `.demo/*.yaml`. Per-`openSlide` scope; useful when different demos in the same workspace need different themes.

If the user's project already sets `demoTime.customTheme` in `.vscode/settings.json`, prefer leaving that as the wire-up and don't add `customTheme:` to YAML — the two will conflict and the result depends on whichever loads last.

The file is loaded by reading its contents and inlining them as a `<style>` tag in the slide preview webview (see `apps/vscode-extension/src/utils/getWebviewHtml.ts`).

## Gotcha: CSS is cached at panel creation

`getCssFiles()` runs once, inside `BaseWebview.create()`. The CSS file is read from disk and inlined into the webview HTML at that moment; there's no `onDidChangeConfiguration` watcher and no file watcher on the CSS itself. Editing the CSS file, or changing the `demoTime.customTheme` setting after the slide preview is open, **will not take effect** until you close the preview and reopen it (or reload the window). Mention this proactively whenever you scaffold or edit a custom theme.

## Custom themes — workflow

When the user wants visual styling that built-in themes don't cover:

1. **One-off override on a single slide** → add a `<style>` block inside the slide markdown. Scope selectors with `.slide.default` (or whatever theme the slide uses) so they win against the upstream rules. Keep it small.
2. **Talk-wide custom theme** →
   - Create `.demo/themes/<name>.css` (repo convention).
   - Wrap **all variable overrides and element selectors** in `.slide.<theme-name> { ... }` — typically `.slide.default { ... }`. The only things that may safely live outside that block are rules like `@import` for fonts, or `font-family` declarations on `:root` / generic selectors like `code, pre, kbd, samp` that don't compete with rules inside `.slide.<theme>`.
   - Inside the block, override the variables listed above for everything they cover. For anything they don't cover, add element selectors (see *Restyling beyond the variable surface*).
   - **Do not invent new `--demotime-*` variables.** They aren't read anywhere — only the documented ones flow through the upstream CSS. Style properties not exposed via variables must be set with selectors.
   - Wire the file up via either the `demoTime.customTheme` VS Code setting or the `openSlide` action's `customTheme:` parameter — see *Wiring up a custom theme* above.

## Skeleton for a talk-wide custom theme

Use this as a starting point when scaffolding `.demo/themes/<name>.css`:

```css
/* Optional: external fonts and document-wide font-family. */
@import url('https://fonts.googleapis.com/css2?family=...&display=swap');

:root {
  font-family: 'Your Font', -apple-system, BlinkMacSystemFont, sans-serif;
}

code, pre, kbd, samp {
  font-family: 'Your Mono Font', ui-monospace, Menlo, Consolas, monospace;
}

.slide.default {
  /* Top-level variables (apply to every layout). */
  --demotime-color: #e6e6e6;
  --demotime-background: #0a0a0a;
  --demotime-heading-color: #ffffff;
  --demotime-heading-background: transparent;
  --demotime-link-color: #41BD9B;
  --demotime-link-active-color: #F0C75E;
  --demotime-blockquote-border: #41BD9B;
  --demotime-blockquote-background: #111315;

  /* Per-layout variables. Repeat the block for each layout the talk uses. */
  --demotime-intro-background: radial-gradient(circle at 30% 20%, #0a1f1a 0%, #0a0a0a 60%);
  --demotime-intro-color: #A6A6A6;
  --demotime-intro-heading-color: #F0C75E;
  --demotime-intro-heading-background: transparent;

  --demotime-section-background: linear-gradient(135deg, #0a1f1a 0%, #0a0a0a 100%);
  --demotime-section-color: #A6A6A6;
  --demotime-section-heading-color: #F0C75E;
  --demotime-section-heading-background: transparent;

  /* Selector overrides for anything the variables don't cover.
     Nested so the resolved selector is .slide.default .intro h2 (0,3,1)
     which beats the upstream .slide.default h2 (0,2,1). */
  .default h2,
  .intro h2,
  .section h2 {
    color: #F0C75E;
  }
}
```

## Authoring rules for Claude

1. **Apply theme consistently.** If the user has chosen a theme for the talk, set it once via the demo-level wire-up (VS Code setting or `openSlide` action) — don't repeat the theme on every slide's frontmatter, and don't mix base themes unless the user explicitly asks.
2. **Never invent a theme name.** The seven names above are the complete built-in set. Anything else must be a user-provided custom theme file.
3. **Wrap all overrides in `.slide.<theme-name>`.** `:root` overrides for `--demotime-*` variables do not apply and are a common documentation footgun. The default-theme target is `.slide.default`.
4. **Don't invent new `--demotime-*` variables.** Only the documented variables flow through the upstream CSS. Anything outside that surface needs a selector, not a variable.
5. **When recoloring per-layout headings, only h1 is variable-driven.** h2–h5 require a selector qualified with `.slide.<theme>` (specificity ≥ 0,3,1 to beat the upstream `.slide.<theme> h2` rule).
6. **Tell the user to reopen the slide preview after CSS or setting changes.** The webview inlines the CSS at panel-creation time and does not watch for changes.
