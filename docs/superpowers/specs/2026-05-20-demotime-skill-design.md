# DemoTime Authoring Skill — Design Spec

**Date:** 2026-05-20
**Status:** Approved, ready for implementation plan
**Skill name:** `demotime-authoring`
**Install location:** `~/.claude/skills/demotime-authoring/` (user-level)

## 1. Purpose

A Claude Skill that helps the user author [DemoTime](https://demotime.show/) demo scripts — the YAML files (e.g. `.demo/workflow-versioning.yaml`) that drive the DemoTime VS Code extension. The skill covers four jobs:

1. **Generate** a new demo YAML from a natural-language outline.
2. **Edit** existing demo YAML (add/reorder/modify scenes and moves).
3. **Scaffold** the companion files referenced by moves — slide markdown files and code-insert `.txt` files.
4. **Author and style slides** — pick the right `layout` per slide, apply a built-in `theme` (or point at a custom CSS file), and structure the slide markdown so it renders cleanly in DemoTime's webview preview.

The skill must produce valid, idiomatic YAML that matches the conventions visible in this repo (`.demo/workflow-versioning.yaml`) without inventing action names.

## 2. Triggering

Skill frontmatter:

```yaml
---
name: demotime-authoring
description: Use when creating, editing, or scaffolding DemoTime YAML demo scripts (.demo/*.yaml) — including adding scenes, defining moves, or producing companion slide/insert files.
---
```

Expected triggers: "create a DemoTime demo for…", "add a scene that…", "scaffold slides for my demo", "validate this `.demo/foo.yaml`", or any direct mention of DemoTime / `.demo/*.yaml`.

## 3. File layout

```
~/.claude/skills/demotime-authoring/
├── SKILL.md
├── references/
│   ├── file.md
│   ├── text.md
│   ├── preview.md
│   ├── patch.md
│   ├── setting.md
│   ├── terminal.md
│   ├── time.md
│   ├── vscode.md
│   ├── snippet.md
│   ├── external.md
│   ├── copilot.md
│   ├── interactions.md
│   ├── os-desktop.md
│   ├── demotime.md
│   ├── engagetime.md
│   ├── slides-layouts.md
│   └── slides-themes.md
├── examples/
│   ├── minimal.yaml
│   ├── slide-walk.yaml
│   └── code-demo.yaml
└── templates/
    ├── slide.md
    ├── slide-image-right.md
    ├── slide-two-columns.md
    └── insert.txt
```

The 15 action-category reference files mirror the 15 action categories on https://demotime.show/actions/ so the structure stays aligned with the upstream docs. The two additional reference files cover slide **layouts** (https://demotime.show/slides/layouts/) and **themes** (https://demotime.show/slides/themes/) — these are not actions but slide-authoring concerns that the skill must know about whenever it scaffolds or edits a slide markdown file.

## 4. `SKILL.md` contents

`SKILL.md` is the entry point. It is read on every invocation; the `references/*.md` files are read on demand. Sections, in order:

### 4.1 What DemoTime is
One paragraph plus a link to https://demotime.show/.

### 4.2 Top-level YAML structure
Annotated skeleton:

```yaml
title: <string>
description: <string>
version: <int>   # demo file format version, currently 3
scenes:
  - id: <slug>
    title: <string>
    moves:
      - action: <action-name>
        # action-specific params
```

Notes: scene `id` must be unique and stable. Repo convention: `scene-<random>-<random>` or `demo-<random>-<random>`. Generated ids should follow that pattern when working in a repo that already uses it; otherwise use simple kebab-case slugs.

### 4.3 Authoring workflow

1. Confirm whether the user wants a **new** demo, an **edit**, or **scaffolding** of companion files.
2. For new demos: ask for the talk topic, rough outline (slides vs. live coding), and target file path (default `.demo/<name>.yaml`).
3. Identify which action categories the demo needs; load only the matching `references/<category>.md` files.
4. Draft the YAML, scene by scene.
5. For each `openSlide`, `replace`, `insert`, `rename`, etc., create the referenced companion file if it doesn't exist, using `templates/*` as a starting point. Announce each file creation — never silently scaffold.
6. Run the validation checklist (§4.5).
7. Show the generated file tree and ask the user to review.

### 4.4 Reference loading rules

| Intent | Load |
|--------|------|
| Slide actions (opening / advancing slides) | `preview.md`, `demotime.md` |
| Authoring or styling a slide *file* (frontmatter, layout, theme) | `slides-layouts.md`, `slides-themes.md` |
| Run terminal commands | `terminal.md` |
| Open / rename / create files | `file.md` |
| Live code edits (insert/replace/highlight) | `patch.md` |
| Trigger VS Code commands or keybindings | `vscode.md` |
| Pauses / timing | `time.md` |
| Info messages / prompts | `interactions.md` |
| Snippets | `snippet.md` |
| External apps | `external.md` |
| GitHub Copilot | `copilot.md` |
| OS / desktop | `os-desktop.md` |
| EngageTime | `engagetime.md` |
| Settings | `setting.md` |
| Text manipulation | `text.md` |

Rule: **never invent an action name.** If the user asks for something not in the loaded references, load the candidate category file first. If still not found, WebFetch `https://demotime.show/actions/<category>/` once and use the result.

### 4.5 Validation checklist

Run before showing the user the result:

- Every `action:` value matches an action documented in the bundled references.
- All required params for that action are present and well-typed.
- All file paths in `path:`, `contentPath:`, `dest:` either already exist or will be created in this same change.
- Scene `id`s are unique within the file.
- `terminalId` values are consistent across `executeTerminalCommand` / `focusTerminal` / `sendKeybinding` pairs (a scene that sends `ctrl+c` should target the same `terminalId` as the scene that started the process).

### 4.6 Repo conventions (defaults)

Inferred from `.demo/workflow-versioning.yaml` and applied when the target repo follows the same layout:

- Demo files live in `.demo/<topic>.yaml`.
- Slides live in `.demo/slides/<name>.md`.
- Code inserts live in `.demo/inserts/<NN>-<desc>.txt`.
- A single `terminalId` (e.g. `app-run`) is reused across scenes that share a shell.
- Typed commands the audience should *see*: `insertTypingMode: character-by-character`, `insertTypingSpeed: 75–100`.
- Setup commands the audience does not need to see typed: `insertTypingMode: instant`, `autoExecute: true`.
- Demos open with a `setPresentationView` followed by an `openSlide` to a title slide.

If the target repo uses different conventions, follow those instead and note the deviation.

### 4.7 Scaffolding companion files

When a generated scene references a slide or insert that doesn't exist, create it from the appropriate `templates/*` file and tell the user. Do not put substantive slide content in the generated file — only a stub with the title — unless the user has provided content.

For **slides** specifically:

- Every scaffolded slide opens with a YAML frontmatter block containing at minimum a `layout` key. A `theme` key may be added when the user wants a non-default theme for that slide.
- Pick the `layout` from the values documented in `references/slides-layouts.md` (`default`, `intro`, `section`, `quote`, `video`, `image`, `image-left`, `image-right`, `two-columns`, `animated-svg`, `custom`). Default to `default` when in doubt, `intro` for the first slide of a talk, and `section` for chapter breaks.
- Pick the `theme` from the values documented in `references/slides-themes.md` (`default`, `minimal`, `monomi`, `unnamed`, `quantum`, `frost`, `pixels`). Theme is normally set once globally — if the user has selected a theme for the talk, apply it consistently across scaffolded slides. Only override per-slide when the user explicitly asks for it.
- Use the matching template under `templates/`: `slide.md` for `default`/`intro`/`section`/`quote`, `slide-image-right.md` for `image-right`/`image-left`, `slide-two-columns.md` for `two-columns`. Other layouts adapt from `slide.md` by changing the frontmatter and the body structure.
- Body content stays a stub: title + a few bullets. Substantive content is the user's job unless they've provided it.

### 4.7.1 Slide styling beyond layout and theme

If the user wants visual customisation that isn't covered by built-in themes (e.g. a brand color, a custom font), the workflow is:

1. Confirm whether they want a one-off override (a `<style>` block in a single slide) or a custom theme (a `.css` file referenced by the `openSlide` action's `customTheme:` parameter — see `references/preview.md`).
2. For a custom theme file, scaffold a starter `.css` that overrides the CSS variables documented in `references/slides-themes.md` (`--demotime-color`, `--demotime-background`, `--demotime-heading-color`, `--demotime-heading-background`, `--demotime-font-size`, `--demotime-link-color`, `--demotime-link-active-color`, `--demotime-blockquote-border`, `--demotime-blockquote-background`, plus the per-layout variants for `default`, `intro`, `quote`, `section`, `image-left`, `image-right`, `two-columns`). Do not invent additional CSS variables.
3. Place the file at `.demo/themes/<name>.css` by repo convention, and remember to update the corresponding action's `customTheme:` parameter to point at it.

### 4.8 Editing existing demos

- Read the full YAML first.
- Preserve existing scene `id`s.
- Use `Edit` (not `Write`) so unrelated scenes are not touched.
- Re-run the validation checklist over the changed scenes only.

### 4.9 Examples

Pointers to `examples/minimal.yaml`, `examples/slide-walk.yaml`, `examples/code-demo.yaml` — each with a one-line description of when to use it as a starting point.

### 4.10 Out of scope

- Running or testing DemoTime itself.
- Installing the DemoTime VS Code extension.
- Generating substantive slide *content* beyond a starter template.
- Recording or exporting demo videos.

## 5. `references/<category>.md` format

Every category file follows the same shape so Claude can rely on a predictable layout and grep for action names without reading the whole file.

````markdown
# <Category> actions

Source: https://demotime.show/actions/<category>/

## Actions in this category

| Action | Purpose |
|--------|---------|
| `actionName1` | One-line summary |
| `actionName2` | One-line summary |

---

## `actionName1`

<One- or two-sentence description.>

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `path` | string | yes | — | Workspace-relative file path |
| `position` | string | no | — | Line number or `start:end` range |
| `highlightWholeLine` | boolean | no | `false` | |

**Example:**

```yaml
- action: actionName1
  path: src/foo.ts
  position: "10:15"
  highlightWholeLine: true
```

**Notes / gotchas:** Anything non-obvious.

---

## `actionName2`
... (same shape)
````

The `Source:` line at the top of each file lets Claude WebFetch the canonical page if the bundled reference looks stale.

## 6. Examples & templates

| File | Purpose |
|------|---------|
| `examples/minimal.yaml` | Smallest valid demo: title scene + one slide + countdown timer. Starting point for short talks. |
| `examples/slide-walk.yaml` | Slide-only talk: ~10 scenes, all `openSlide` + `setPresentationView` + `startCountdown`. Starting point for keynote-style demos. |
| `examples/code-demo.yaml` | Mirrors `.demo/workflow-versioning.yaml`: intro slides → build → run → http file → edit (insert/replace) → re-run → stop → cleanup. Most valuable example; encodes the repo conventions. |
| `templates/slide.md` | Stub slide markdown — frontmatter (`layout: default`, optional `theme:`) + title + a couple of bullets. The default starting point. |
| `templates/slide-image-right.md` | Two-column layout with image-right placement. Demonstrates how to structure markdown for the `image-right` (and by mirror, `image-left`) layout. |
| `templates/slide-two-columns.md` | Two-content-columns layout. Demonstrates how DemoTime splits body content into left/right columns. |
| `templates/insert.txt` | Empty insert file with a header comment explaining how DemoTime consumes inserts and a note about matching indentation. |

## 7. Building the references the first time

This is implementation, not skill behavior — but it must happen as part of skill creation:

1. For each of the 15 category URLs under `https://demotime.show/actions/`, WebFetch the page.
2. Extract the action list, per-action parameters (type, required?, default), and any notes.
3. Write `references/<category>.md` using the §5 format.
4. Manually spot-check a few high-value categories (`patch`, `terminal`, `preview`, `demotime`) against `.demo/workflow-versioning.yaml` to confirm the parameter shapes match what the working YAML actually uses.
5. WebFetch `https://demotime.show/slides/layouts/` and write `references/slides-layouts.md`. The file enumerates every built-in layout, the frontmatter syntax that selects it, and any markdown-structure conventions a layout expects (e.g. how `two-columns` splits content, where the image goes for `image-left` vs. `image-right`).
6. WebFetch `https://demotime.show/slides/themes/` and `https://demotime.show/slides/themes/default/`, then write `references/slides-themes.md`. The file enumerates the seven built-in themes (`default`, `minimal`, `monomi`, `unnamed`, `quantum`, `frost`, `pixels`), the frontmatter syntax that selects one, and the full list of CSS variables exposed by the default theme (the customisation surface for user-written themes).

## 8. Success criteria

The skill is working correctly when:

1. Asked to "create a DemoTime YAML for a 10-minute talk on X", Claude produces a complete `.demo/<topic>.yaml` plus all referenced slide/insert files in one pass, without inventing action names. Scaffolded slide files include valid frontmatter (`layout:` always present, `theme:` when the user has chosen one).
2. Asked to "add a scene that runs `npm test`", Claude loads only `terminal.md`, picks `executeTerminalCommand`, fills required params, and inserts the scene with a unique id.
3. Asked to "validate my demo", Claude reads the YAML and reports any unknown actions, missing required params, or broken `path:` references.
4. When the user references an action not in the bundled references (e.g. a newly released DemoTime action), Claude loads the matching category file; if still absent, it WebFetches the canonical page rather than guessing.
5. Generated YAML matches this repo's conventions (file locations, terminal ids, typing speeds, scene id format) when working in a repo that follows them.
6. Asked "give me an image-right slide" or "use the quantum theme for the whole talk", Claude loads `slides-layouts.md` / `slides-themes.md`, writes the correct frontmatter, and uses or adapts the matching template — never inventing a layout or theme name.
7. Asked for "brand colours on the slides", Claude scaffolds a `.demo/themes/<name>.css` overriding the documented CSS variables and updates the relevant `openSlide` action's `customTheme:` param — without guessing at additional variables.

## 9. Out of scope (skill itself)

See §4.10.
