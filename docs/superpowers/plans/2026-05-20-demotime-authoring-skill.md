# DemoTime Authoring Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Claude Code plugin in this repo that ships a single skill, `demotime-authoring`, which helps users author DemoTime YAML demo scripts (generate, edit, scaffold companion files) **and the slide markdown files those scripts reference** (layout, theme, styling), using bundled per-category action and slide-authoring references.

**Architecture:** A standard Claude Code plugin layout — `.claude-plugin/plugin.json` at the repo root and the skill under `skills/demotime-authoring/`. The skill is content-only (Markdown + YAML), no runtime code. `SKILL.md` is the always-loaded entry point; 15 per-category action `references/*.md` files plus 2 slide-authoring references (`slides-layouts.md`, `slides-themes.md`) are loaded on demand; `examples/` and `templates/` provide starter material. References are populated from `https://demotime.show/actions/<category>/`, `https://demotime.show/slides/layouts/`, and `https://demotime.show/slides/themes/` via WebFetch.

**Tech Stack:** Markdown, YAML, JSON. No code runtime. Validation uses `python3 -c "import yaml; ..."` and `python3 -m json.tool` (both ship with macOS Python).

**Note on user instruction:** The user has explicitly requested **no `git add` or `git commit` commands**. Commit steps are omitted from every task. The user will commit when ready.

**Note on a divergence from the spec:** Design §3 says install to `~/.claude/skills/demotime-authoring/`. We are building this as a **plugin** in the current repo so it can be distributed via Claude Code's plugin system; the actual install will be done by the user via plugin install later. Skill contents and behavior are unchanged.

**Note on a missing artifact:** Design §4.6 and §6 reference `.demo/workflow-versioning.yaml` for repo conventions and as the basis for `examples/code-demo.yaml`. That file is **not** present in this repo (only the design doc is). Where this file would have been used as a source of truth, we instead synthesize idiomatic examples from the per-category docs and from the conventions enumerated in design §4.6.

---

## File Structure

Files created by this plan, with responsibility:

- `.claude-plugin/plugin.json` — plugin manifest (name, version, description). Required for Claude Code to recognize this repo as a plugin.
- `skills/demotime-authoring/SKILL.md` — always-loaded entry point; describes triggering, top-level YAML structure, authoring workflow, reference-loading rules, validation checklist, repo conventions, scaffolding (including slides), slide authoring (layouts, themes, custom CSS), editing rules, examples pointers, out-of-scope.
- `skills/demotime-authoring/references/<category>.md` (×15) — on-demand action documentation, one file per DemoTime action category. Predictable layout (table + per-action H2 + params table + YAML example).
- `skills/demotime-authoring/references/slides-layouts.md` — every built-in slide layout, the frontmatter key/values that select it, and the markdown-structure conventions per layout.
- `skills/demotime-authoring/references/slides-themes.md` — every built-in theme, the frontmatter key/values that select it, the full list of CSS variables exposed for customization, and the workflow for a user-supplied custom theme file (`customTheme:` param on `openSlide`).
- `skills/demotime-authoring/examples/minimal.yaml` — smallest valid demo (title slide + countdown).
- `skills/demotime-authoring/examples/slide-walk.yaml` — slide-only keynote-style demo. Includes companion slide files demonstrating multiple layouts.
- `skills/demotime-authoring/examples/code-demo.yaml` — full code demo (intro → run → edit → re-run → cleanup), encodes repo conventions from design §4.6.
- `skills/demotime-authoring/templates/slide.md` — stub slide markdown with frontmatter (`layout: default`) + title + bullets. Default starting point.
- `skills/demotime-authoring/templates/slide-image-right.md` — stub for `image-right` (and by mirror, `image-left`) layout.
- `skills/demotime-authoring/templates/slide-two-columns.md` — stub for the `two-columns` layout, showing how DemoTime splits body content into left/right columns.
- `skills/demotime-authoring/templates/insert.txt` — empty insert with header comment explaining DemoTime insert semantics and indentation.
- `scripts/validate-skill.sh` — local validation helper used at the end of the plan to verify YAML/JSON parseability, action-name consistency, and slide-frontmatter validity. Tracked in repo so future edits to the skill can re-run it.

The 15 action categories (per design §3, mirroring `https://demotime.show/actions/`): `file`, `text`, `preview`, `patch`, `setting`, `terminal`, `time`, `vscode`, `snippet`, `external`, `copilot`, `interactions`, `os-desktop`, `demotime`, `engagetime`.

The two slide-authoring references mirror `https://demotime.show/slides/layouts/` and `https://demotime.show/slides/themes/` (plus the linked `https://demotime.show/slides/themes/default/` page, which is the source of truth for the CSS-variable list).

---

## Task 1: Plugin manifest and directory skeleton

**Files:**
- Create: `/Users/marcduiker/dev/pers/demo-time-skill/.claude-plugin/plugin.json`
- Create (empty dirs): `skills/demotime-authoring/references/`, `skills/demotime-authoring/examples/`, `skills/demotime-authoring/templates/`

- [ ] **Step 1: Create the directory tree**

Run from the repo root (`/Users/marcduiker/dev/pers/demo-time-skill`):

```bash
mkdir -p .claude-plugin \
         skills/demotime-authoring/references \
         skills/demotime-authoring/examples \
         skills/demotime-authoring/templates \
         scripts
```

- [ ] **Step 2: Write the plugin manifest**

Create `.claude-plugin/plugin.json` with this exact content:

```json
{
  "name": "demotime-authoring",
  "description": "Author DemoTime YAML demo scripts (.demo/*.yaml) — generate, edit, and scaffold companion slide/insert files.",
  "version": "0.1.0",
  "author": {
    "name": "Marc Duiker",
    "email": "marc@diagrid.io"
  },
  "homepage": "https://demotime.show/",
  "keywords": ["demotime", "skills", "demo", "vscode", "presentation"]
}
```

- [ ] **Step 3: Verify the manifest is valid JSON**

Run:

```bash
python3 -m json.tool .claude-plugin/plugin.json > /dev/null && echo OK
```

Expected output: `OK`. If it errors, fix the JSON before continuing.

- [ ] **Step 4: Verify the directory tree**

Run:

```bash
find .claude-plugin skills scripts -type d | sort
```

Expected output (exactly these lines, in this order):

```
.claude-plugin
scripts
skills
skills/demotime-authoring
skills/demotime-authoring/examples
skills/demotime-authoring/references
skills/demotime-authoring/templates
```

---

## Task 2: Templates

**Files:**
- Create: `skills/demotime-authoring/templates/slide.md`
- Create: `skills/demotime-authoring/templates/slide-image-right.md`
- Create: `skills/demotime-authoring/templates/slide-two-columns.md`
- Create: `skills/demotime-authoring/templates/insert.txt`

- [ ] **Step 1: Write the default slide template**

Create `skills/demotime-authoring/templates/slide.md`:

```markdown
---
layout: default
# theme: default   # uncomment and pick from: default | minimal | monomi | unnamed | quantum | frost | pixels
---

# {{ Slide Title }}

- First bullet
- Second bullet
- Third bullet

<!--
DemoTime slide. This file is referenced by an `openSlide` action's `path:` param.
Markdown is rendered as a webview preview inside VS Code.

- `layout:` selects the slide layout. See references/slides-layouts.md for the full list
  (default, intro, section, quote, video, image, image-left, image-right, two-columns,
  animated-svg, custom).
- `theme:` (optional) selects a built-in theme. See references/slides-themes.md.
  Leave commented out to inherit the demo-wide theme set in the `openSlide` action.

Replace this stub with real content when authoring.
-->
```

- [ ] **Step 2: Write the image-right slide template**

Create `skills/demotime-authoring/templates/slide-image-right.md`:

```markdown
---
layout: image-right
# image: ./assets/example.png       # uncomment and set to the workspace-relative image path
---

# {{ Slide Title }}

- Left-column bullet one
- Left-column bullet two
- Left-column bullet three

<!--
image-right layout: the image is placed on the right side of the slide and the body
content (above) flows on the left.

For image-left, change `layout: image-right` to `layout: image-left` — body content
then flows on the right and the image moves to the left.

The exact frontmatter key for the image path (`image:` shown above) is documented in
references/slides-layouts.md. If that reference uses a different key, update this
template to match.
-->
```

- [ ] **Step 3: Write the two-columns slide template**

Create `skills/demotime-authoring/templates/slide-two-columns.md`:

```markdown
---
layout: two-columns
---

# {{ Slide Title }}

::: left
- Left column bullet one
- Left column bullet two
:::

::: right
- Right column bullet one
- Right column bullet two
:::

<!--
two-columns layout: body content is split into left and right slots.

The exact slot syntax DemoTime uses is documented in references/slides-layouts.md.
The `::: left` / `::: right` fenced blocks above are a common Markdown-it container
pattern; if the reference shows DemoTime uses a different splitter (e.g. `---`
between columns, or HTML divs with specific classes), update this template to match
and DO NOT silently leave the stale syntax here.
-->
```

- [ ] **Step 4: Write the insert template**

Create `skills/demotime-authoring/templates/insert.txt`:

```
# DemoTime insert file.
#
# This file is referenced by a `patch` action (e.g. `insert`, `replace`) via the
# `contentPath:` param. DemoTime reads its raw bytes and writes them into the
# target file at the specified position.
#
# Two rules to keep in mind when authoring this file:
#   1. Indentation must match the surrounding code in the target file. DemoTime
#      does NOT auto-indent — what's here is what lands in the file.
#   2. Trailing newlines matter. If you want a blank line after the inserted
#      block, leave a trailing newline at the bottom of this file.
#
# Delete this comment block before using — DemoTime will paste it verbatim
# otherwise.
```

- [ ] **Step 5: Verify all four files exist and are non-empty**

Run:

```bash
for f in slide.md slide-image-right.md slide-two-columns.md insert.txt; do
  [ -s "skills/demotime-authoring/templates/$f" ] || { echo "MISSING $f"; exit 1; }
done
echo OK
```

Expected: `OK`.

- [ ] **Step 6: Verify the three slide templates have a `layout:` key in their frontmatter**

Run:

```bash
python3 - <<'PY'
import re, pathlib, yaml
for f, expected in [("slide.md", "default"),
                    ("slide-image-right.md", "image-right"),
                    ("slide-two-columns.md", "two-columns")]:
    text = pathlib.Path(f"skills/demotime-authoring/templates/{f}").read_text()
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    assert m, f"{f}: missing frontmatter"
    fm = yaml.safe_load(m.group(1))
    assert fm.get("layout") == expected, f"{f}: layout is {fm.get('layout')!r}, expected {expected!r}"
    print(f"OK {f}: layout={fm['layout']}")
PY
```

Expected: three `OK <file>: layout=<value>` lines.

---

## Task 3: Reference file format — write the first reference (`preview.md`) as the canonical exemplar

The 15 reference files all follow the same layout (design §5). This task produces **one** file end-to-end so subsequent reference tasks (Tasks 4–6) can be done in parallel by copying the structure.

**Files:**
- Create: `skills/demotime-authoring/references/preview.md`

- [ ] **Step 1: WebFetch the canonical page**

Run the WebFetch tool with:
- `url`: `https://demotime.show/actions/preview/`
- `prompt`: "List every action documented on this page. For each action, provide: (1) the action name (the string used in `action:` in YAML); (2) a one-sentence description; (3) every parameter with its type, whether required, default if any, and any notes; (4) at least one YAML usage example if shown."

Save the result; you will paraphrase it into the reference file in step 2.

- [ ] **Step 2: Write the reference file using the canonical format**

The format is fixed (design §5). Use this skeleton, filling in the actions returned by step 1:

````markdown
# Preview actions

Source: https://demotime.show/actions/preview/

Use this category for: opening slides, showing image/markdown previews, controlling presentation/zen view.

## Actions in this category

| Action | Purpose |
|--------|---------|
| `<actionName>` | <one-line summary> |

---

## `<actionName>`

<One- or two-sentence description.>

**Parameters:**

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `<paramName>` | `<type>` | yes/no | `<default>` | <notes> |

**Example:**

```yaml
- action: <actionName>
  <paramName>: <value>
```

**Notes / gotchas:** <Anything non-obvious, or "None.">

---

## `<nextActionName>`
... (repeat the per-action block)
````

Rules while filling in:
- Every action listed in the table at the top MUST have its own H2 section below.
- If a parameter is absent from the canonical page, do not invent it. Write "None documented." under **Parameters:** instead of an empty table.
- If an example is not provided on the canonical page, write a minimal one yourself using only the parameters listed.
- Wrap each action name in backticks everywhere it appears.

- [ ] **Step 3: Verify the file mentions every action in both the table and an H2**

Run:

```bash
python3 - <<'PY'
import re, pathlib
p = pathlib.Path("skills/demotime-authoring/references/preview.md")
text = p.read_text()
# Action names listed in the summary table (rows that start with `| \``)
table = set(re.findall(r"^\|\s*`([^`]+)`\s*\|", text, re.M))
# Action names that have an H2 section
h2 = set(re.findall(r"^##\s+`([^`]+)`\s*$", text, re.M))
missing_h2 = table - h2
extra_h2 = h2 - table
assert not missing_h2, f"In table but no H2: {missing_h2}"
assert not extra_h2, f"H2 but not in table: {extra_h2}"
print(f"OK — {len(table)} actions, table and H2 consistent.")
PY
```

Expected: `OK — N actions, table and H2 consistent.` If it fails, edit the file to add the missing H2 or table row.

---

## Task 4: Reference files — editing/timing categories (5 files)

Repeat Task 3's process for each category below. These can be done in parallel (dispatch one subagent per file via `superpowers:dispatching-parallel-agents`).

**Files:**
- Create: `skills/demotime-authoring/references/file.md`
- Create: `skills/demotime-authoring/references/text.md`
- Create: `skills/demotime-authoring/references/patch.md`
- Create: `skills/demotime-authoring/references/terminal.md`
- Create: `skills/demotime-authoring/references/time.md`

- [ ] **Step 1: For each category in `[file, text, patch, terminal, time]`, WebFetch and write the reference file**

For category `<C>`:
1. WebFetch `https://demotime.show/actions/<C>/` with the same `prompt:` from Task 3 Step 1.
2. Write `skills/demotime-authoring/references/<C>.md` using the format from Task 3 Step 2.
3. The first non-heading line of each file should be `Source: https://demotime.show/actions/<C>/`.
4. The "Use this category for:" line should match the routing intent in design §4.4 — e.g. for `file.md`: "opening, renaming, creating, deleting, copying, moving files in the workspace"; for `patch.md`: "live code edits — insert, replace, delete, highlight ranges of an existing file"; for `terminal.md`: "running shell commands in a VS Code terminal, sending keybindings to it, focusing it"; for `text.md`: "transforming text in the active editor"; for `time.md`: "pauses, waits, countdowns, stopwatch".

- [ ] **Step 2: Run the consistency check on all five files**

Run:

```bash
python3 - <<'PY'
import re, pathlib
for name in ["file", "text", "patch", "terminal", "time"]:
    p = pathlib.Path(f"skills/demotime-authoring/references/{name}.md")
    text = p.read_text()
    table = set(re.findall(r"^\|\s*`([^`]+)`\s*\|", text, re.M))
    h2 = set(re.findall(r"^##\s+`([^`]+)`\s*$", text, re.M))
    missing_h2 = table - h2
    extra_h2 = h2 - table
    assert not missing_h2 and not extra_h2, \
        f"{name}: missing_h2={missing_h2}, extra_h2={extra_h2}"
    assert text.startswith("# "), f"{name}: missing H1"
    assert "Source: https://demotime.show/actions/" in text, f"{name}: missing Source line"
    print(f"OK {name}: {len(table)} actions")
PY
```

Expected: five `OK <name>: N actions` lines.

---

## Task 5: Reference files — integration categories (5 files)

Same process as Task 4, for: `vscode`, `snippet`, `external`, `copilot`, `os-desktop`.

**Files:**
- Create: `skills/demotime-authoring/references/vscode.md`
- Create: `skills/demotime-authoring/references/snippet.md`
- Create: `skills/demotime-authoring/references/external.md`
- Create: `skills/demotime-authoring/references/copilot.md`
- Create: `skills/demotime-authoring/references/os-desktop.md`

Note: the upstream URL slug for `os-desktop` may be `os-desktop`, `desktop`, or `os`. If `https://demotime.show/actions/os-desktop/` returns 404, try `https://demotime.show/actions/desktop/` then `https://demotime.show/actions/os/`. If none work, WebFetch `https://demotime.show/actions/` (the index page) and grep the response for the right slug. The local filename stays `os-desktop.md` regardless — that's the slug design §3 specifies.

- [ ] **Step 1: For each category, WebFetch and write**

For category `<C>` in `[vscode, snippet, external, copilot, os-desktop]`:
1. WebFetch `https://demotime.show/actions/<C>/` (using the slug-fallback rule above for `os-desktop`).
2. Write `skills/demotime-authoring/references/<C>.md` per Task 3 Step 2's format.
3. "Use this category for:" lines:
   - `vscode.md`: "running VS Code commands, sending keybindings, opening files in editor groups"
   - `snippet.md`: "inserting reusable snippet sequences and parameterised macro-style snippets"
   - `external.md`: "launching external apps and opening URLs in the system browser"
   - `copilot.md`: "driving GitHub Copilot chat and inline suggestions during a demo"
   - `os-desktop.md`: "OS-level desktop actions — show notification, change wallpaper, etc."

- [ ] **Step 2: Run the consistency check on all five files**

Run:

```bash
python3 - <<'PY'
import re, pathlib
for name in ["vscode", "snippet", "external", "copilot", "os-desktop"]:
    p = pathlib.Path(f"skills/demotime-authoring/references/{name}.md")
    text = p.read_text()
    table = set(re.findall(r"^\|\s*`([^`]+)`\s*\|", text, re.M))
    h2 = set(re.findall(r"^##\s+`([^`]+)`\s*$", text, re.M))
    missing_h2 = table - h2
    extra_h2 = h2 - table
    assert not missing_h2 and not extra_h2, \
        f"{name}: missing_h2={missing_h2}, extra_h2={extra_h2}"
    assert "Source: https://demotime.show/actions/" in text, f"{name}: missing Source line"
    print(f"OK {name}: {len(table)} actions")
PY
```

Expected: five `OK <name>: N actions` lines.

---

## Task 6: Reference files — DemoTime platform and remaining categories (5 files)

Same process as Task 4, for: `setting`, `interactions`, `demotime`, `engagetime`, `preview` is already done in Task 3 — but we have one slot left; replace `preview` with **a re-check pass on `preview.md`** at the end (see Step 3 below).

**Files:**
- Create: `skills/demotime-authoring/references/setting.md`
- Create: `skills/demotime-authoring/references/interactions.md`
- Create: `skills/demotime-authoring/references/demotime.md`
- Create: `skills/demotime-authoring/references/engagetime.md`

- [ ] **Step 1: For each category, WebFetch and write**

For category `<C>` in `[setting, interactions, demotime, engagetime]`:
1. WebFetch `https://demotime.show/actions/<C>/` per Task 3 Step 1.
2. Write `skills/demotime-authoring/references/<C>.md` per Task 3 Step 2's format.
3. "Use this category for:" lines:
   - `setting.md`: "reading or writing VS Code settings during a demo"
   - `interactions.md`: "showing info/warning messages, quick-pick prompts, input boxes to the audience"
   - `demotime.md`: "controlling the DemoTime extension itself — start, next, previous, reset, presentation/zen view"
   - `engagetime.md`: "audience engagement (polls, reactions) via the EngageTime companion"

- [ ] **Step 2: Run the consistency check on all four new files**

Run:

```bash
python3 - <<'PY'
import re, pathlib
for name in ["setting", "interactions", "demotime", "engagetime"]:
    p = pathlib.Path(f"skills/demotime-authoring/references/{name}.md")
    text = p.read_text()
    table = set(re.findall(r"^\|\s*`([^`]+)`\s*\|", text, re.M))
    h2 = set(re.findall(r"^##\s+`([^`]+)`\s*$", text, re.M))
    assert not (table - h2) and not (h2 - table), f"{name}: {table} != {h2}"
    print(f"OK {name}: {len(table)} actions")
PY
```

Expected: four `OK <name>: N actions` lines.

- [ ] **Step 3: Verify all 15 action-reference files exist**

Run:

```bash
ls skills/demotime-authoring/references/*.md | sort | grep -v 'slides-'
```

Expected output (exactly these 15 lines, in this order):

```
skills/demotime-authoring/references/copilot.md
skills/demotime-authoring/references/demotime.md
skills/demotime-authoring/references/engagetime.md
skills/demotime-authoring/references/external.md
skills/demotime-authoring/references/file.md
skills/demotime-authoring/references/interactions.md
skills/demotime-authoring/references/os-desktop.md
skills/demotime-authoring/references/patch.md
skills/demotime-authoring/references/preview.md
skills/demotime-authoring/references/setting.md
skills/demotime-authoring/references/snippet.md
skills/demotime-authoring/references/terminal.md
skills/demotime-authoring/references/text.md
skills/demotime-authoring/references/time.md
skills/demotime-authoring/references/vscode.md
```

If any file is missing, return to the corresponding earlier task and create it. The two `slides-*.md` files are created in Task 6b below.

---

## Task 6b: Slide-authoring references (layouts and themes)

These two references document slide-file authoring (not actions). They do **not** follow the per-action H2 format used in Tasks 3–6 because they describe enumerations (layouts, themes, CSS variables), not parameterised actions. The known-actions index in Task 7 deliberately ignores them.

**Files:**
- Create: `skills/demotime-authoring/references/slides-layouts.md`
- Create: `skills/demotime-authoring/references/slides-themes.md`

- [ ] **Step 1: WebFetch the slide-layouts page and write `slides-layouts.md`**

Run the WebFetch tool with:
- `url`: `https://demotime.show/slides/layouts/`
- `prompt`: "List every slide layout DemoTime supports. For each layout: (1) its name (the string used in frontmatter `layout:` to select it); (2) one sentence on when to use it; (3) any markdown structure or class conventions specific to that layout (column splitters, image keys, slot names). Also: confirm the frontmatter key is `layout:`, the default value, and any additional frontmatter keys associated with specific layouts (e.g. `image:` for image-left/image-right)."

Then write `skills/demotime-authoring/references/slides-layouts.md`:

````markdown
# Slide layouts

Source: https://demotime.show/slides/layouts/

Use this reference when scaffolding or editing a slide markdown file — to pick the right `layout` value and to know what markdown structure the layout expects in the body.

## Selecting a layout

Layouts are selected in the slide file's YAML frontmatter:

```markdown
---
layout: <layout-name>
---

# Slide title

...body...
```

If `layout:` is omitted, DemoTime falls back to `default`.

## Layouts at a glance

| Layout | Use when | Body convention |
|--------|----------|-----------------|
| `default` | Standard slide with title + body | Free-form markdown |
| `intro` | Opening / title slide of a talk | Title + optional subtitle |
| `section` | Chapter or topic break | Title only |
| `quote` | Highlight a quotation | Use `> quote text` blockquote |
| `video` | Embed a video | <verify exact frontmatter key from canonical page — likely `video:`> |
| `image` | Full-width image | <verify exact frontmatter key — likely `image:`> |
| `image-left` | Two-column with image on left, body on right | `image:` in frontmatter; body markdown becomes the right column |
| `image-right` | Two-column with image on right, body on left | `image:` in frontmatter; body markdown becomes the left column |
| `two-columns` | Split body into two text columns | <verify exact splitter from canonical page — `::: left` / `::: right` containers OR HTML divs OR another convention> |
| `animated-svg` | Embed an animated SVG | <verify exact frontmatter key> |
| `custom` | User-defined structure | User supplies the markdown body verbatim |

---

## `default`

Standard slide. Use for content slides without special structure.

```markdown
---
layout: default
---

# A topic

- bullet
- bullet
```

## `intro`

Opening slide. Emphasises the title.

```markdown
---
layout: intro
---

# Talk title

Speaker name · 2026-05-20
```

## `section`

Chapter break. Body is usually empty or a single subtitle.

```markdown
---
layout: section
---

# Part 2 — Implementation
```

## `quote`

Highlights a blockquote.

```markdown
---
layout: quote
---

> "A quote that fits on one slide."
> — Source
```

## `image`, `image-left`, `image-right`

Image-centric layouts. `image:` (or whatever frontmatter key the canonical page documents) points at the image; the body markdown becomes the text column for `image-left` / `image-right`.

```markdown
---
layout: image-right
image: ./assets/screenshot.png
---

# Title

- Bullet about the image
- Another bullet
```

## `two-columns`

Body content is split into a left and a right column. **Verify the exact splitter against the canonical page before relying on this.**

```markdown
---
layout: two-columns
---

# Title

::: left
- Left column content
:::

::: right
- Right column content
:::
```

## `video`, `animated-svg`, `custom`

`video` and `animated-svg` are media-centric — see the canonical page for the exact frontmatter key (likely `video:` and `svg:` respectively). `custom` lets the user write arbitrary markdown/HTML; pair it with a custom theme (see `slides-themes.md`) when overriding structure.

---

## Authoring rules for Claude

1. **Always set `layout:`** when scaffolding a slide. Default to `default`. Use `intro` for the first slide of a talk and `section` for chapter breaks.
2. **Never invent a layout name.** If the user asks for a layout not in the table above, WebFetch the canonical page once and add it here.
3. **Verify layout-specific frontmatter keys (e.g. `image:`, `video:`, slot splitters) against the canonical page** when actually authoring a slide — the placeholders in this file flagged `<verify ...>` indicate where the canonical docs are the source of truth.
````

- [ ] **Step 2: WebFetch the slide-themes page and the default-theme page, then write `slides-themes.md`**

Run two WebFetches:

1. `url`: `https://demotime.show/slides/themes/` — `prompt`: "List every built-in theme name, the frontmatter key/syntax to select one, the default, and any guidance on creating a custom theme (file format, file location, how a slide references a custom theme)."
2. `url`: `https://demotime.show/slides/themes/default/` — `prompt`: "List every CSS variable / custom property exposed by the default theme, with any default values shown. Include per-layout variants (e.g. layout-specific background / color / heading variants for default, intro, quote, section, image-left, image-right, two-columns)."

Then write `skills/demotime-authoring/references/slides-themes.md`:

````markdown
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

A theme can also be set demo-wide via the `openSlide` action — see `references/preview.md` for the param name (typically `theme:` or `customTheme:`).

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

These variables form the customization surface — overriding them in a custom theme is the supported way to restyle DemoTime slides.

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

**Per-layout variants:** the default theme also exposes layout-scoped variants for `default`, `intro`, `quote`, `section`, `image-left`, `image-right`, and `two-columns`. Each layout supports `background`, `color`, `heading-color`, and `heading-background` variants. Exact variable names follow the pattern `--demotime-<layout>-<property>` — confirm specific names against the canonical page (https://demotime.show/slides/themes/default/) before relying on them.

## Custom themes — workflow

When the user wants visual styling that built-in themes don't cover:

1. **One-off override on a single slide** → add a `<style>` block inside the slide markdown. Scope by layout class or by a slide-specific selector. Keep it small.
2. **Talk-wide custom theme** →
   - Create `.demo/themes/<name>.css` (repo convention).
   - In that file, override the variables listed above. **Do not invent additional variables** — if a property isn't exposed by the default theme, it isn't themeable through CSS variables and needs an inline style block or a fully custom layout (`layout: custom`).
   - Wire the file up via the `openSlide` action's custom-theme parameter — see `references/preview.md` for the exact param name.

## Authoring rules for Claude

1. **Apply theme consistently.** If the user has chosen a theme for the talk, set it once on the demo-level `openSlide` action (or on every slide's frontmatter). Don't mix themes unless the user explicitly asks.
2. **Never invent a theme name.** The seven names above are the complete built-in set. Anything else must be a user-provided custom theme file.
3. **Stay inside the documented CSS variables when writing a custom theme.** Variables outside this list are not part of the public API and may break across DemoTime versions.
````

- [ ] **Step 3: Verify both files exist and start with the expected H1 and `Source:` line**

Run:

```bash
python3 - <<'PY'
import pathlib
for name in ["slides-layouts", "slides-themes"]:
    p = pathlib.Path(f"skills/demotime-authoring/references/{name}.md")
    text = p.read_text()
    assert text.startswith("# "), f"{name}: missing H1"
    assert "Source: https://demotime.show/slides/" in text, f"{name}: missing Source line"
    assert "layout:" in text or "theme:" in text, f"{name}: missing frontmatter discussion"
    print(f"OK {name}: {len(text)} chars")
PY
```

Expected: two `OK <name>: <N> chars` lines.

- [ ] **Step 4: Verify the layouts reference enumerates the eleven built-in layouts**

Run:

```bash
python3 - <<'PY'
import pathlib
text = pathlib.Path("skills/demotime-authoring/references/slides-layouts.md").read_text()
expected = ["default", "intro", "section", "quote", "video", "image",
            "image-left", "image-right", "two-columns", "animated-svg", "custom"]
missing = [l for l in expected if f"`{l}`" not in text]
assert not missing, f"slides-layouts.md missing layouts: {missing}"
print(f"OK — all {len(expected)} layouts mentioned")
PY
```

Expected: `OK — all 11 layouts mentioned`.

- [ ] **Step 5: Verify the themes reference enumerates the seven built-in themes and the CSS variables**

Run:

```bash
python3 - <<'PY'
import pathlib
text = pathlib.Path("skills/demotime-authoring/references/slides-themes.md").read_text()
themes = ["default", "minimal", "monomi", "unnamed", "quantum", "frost", "pixels"]
missing_t = [t for t in themes if f"`{t}`" not in text]
assert not missing_t, f"slides-themes.md missing themes: {missing_t}"
vars_ = ["--demotime-color", "--demotime-background", "--demotime-heading-color",
         "--demotime-heading-background", "--demotime-font-size",
         "--demotime-link-color", "--demotime-link-active-color",
         "--demotime-blockquote-border", "--demotime-blockquote-background"]
missing_v = [v for v in vars_ if v not in text]
assert not missing_v, f"slides-themes.md missing CSS variables: {missing_v}"
print(f"OK — {len(themes)} themes + {len(vars_)} CSS variables documented")
PY
```

Expected: `OK — 7 themes + 9 CSS variables documented`.

---

## Task 7: Build a known-actions index for example validation

The examples in Tasks 8–10 must only use action names that actually exist in the references. This task produces a sorted text file of every action name documented so later tasks can grep against it.

**Files:**
- Create: `scripts/known-actions.txt` (regenerated artifact, not hand-edited)
- Create: `scripts/build-known-actions.sh`

- [ ] **Step 1: Write the generator script**

Create `scripts/build-known-actions.sh`:

```bash
#!/usr/bin/env bash
# Extract every action name (H2 ``-wrapped) from action reference files only.
# The slides-*.md references use H2s for layouts/themes, not actions, so we
# exclude them.
set -euo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC2046
grep -hE '^## `[^`]+`$' \
  $(ls skills/demotime-authoring/references/*.md | grep -v '/slides-') \
  | sed -E 's/^## `([^`]+)`$/\1/' \
  | sort -u > scripts/known-actions.txt
wc -l < scripts/known-actions.txt
```

Then:

```bash
chmod +x scripts/build-known-actions.sh
```

- [ ] **Step 2: Run it and confirm a sensible action count**

Run:

```bash
./scripts/build-known-actions.sh
```

Expected: a single number ≥ 30 (DemoTime documents well over 30 actions across 15 categories). If you see fewer than 15, the references are under-populated — revisit Tasks 3–6.

- [ ] **Step 3: Spot-check a few high-value actions are present**

Run:

```bash
for a in openSlide setPresentationView executeTerminalCommand insert replace start; do
  grep -qx "$a" scripts/known-actions.txt && echo "OK $a" || echo "MISSING $a"
done
```

Expected: six `OK <action>` lines. If any are `MISSING`, the corresponding reference file is missing that action — fix the reference file (its name will be one of `preview`, `terminal`, `patch`, `demotime`) and re-run `./scripts/build-known-actions.sh`.

---

## Task 8: Example — `minimal.yaml`

Smallest valid demo: title scene with one slide and a countdown timer.

**Files:**
- Create: `skills/demotime-authoring/examples/minimal.yaml`

- [ ] **Step 1: Write the file**

Create `skills/demotime-authoring/examples/minimal.yaml`:

```yaml
title: Minimal DemoTime example
description: |
  Smallest viable demo: opens a single slide and starts a 10-minute countdown.
  Use this as a starting point for short talks or sanity checks.
version: 3
scenes:
  - id: minimal-intro
    title: Intro
    moves:
      - action: setPresentationView
      - action: openSlide
        path: .demo/slides/intro.md
      - action: startCountdown
        minutes: 10
```

- [ ] **Step 2: Verify it parses as YAML**

Run:

```bash
python3 -c "import yaml,sys; yaml.safe_load(open('skills/demotime-authoring/examples/minimal.yaml')); print('OK')"
```

Expected: `OK`.

- [ ] **Step 3: Verify every action name in the file exists in the known-actions index**

Run:

```bash
python3 - <<'PY'
import yaml, pathlib
known = set(pathlib.Path("scripts/known-actions.txt").read_text().split())
demo = yaml.safe_load(open("skills/demotime-authoring/examples/minimal.yaml"))
used = {m["action"] for s in demo["scenes"] for m in s["moves"]}
unknown = used - known
assert not unknown, f"Unknown actions in minimal.yaml: {unknown}"
print(f"OK — actions used: {sorted(used)}")
PY
```

Expected: `OK — actions used: ['openSlide', 'setPresentationView', 'startCountdown']`. If an action is reported as unknown, the *reference file* for that action is wrong (e.g. action is named differently). Fix the reference file, re-run `./scripts/build-known-actions.sh`, then re-run this step. **Do not** rename the action in the example to match a wrong reference — investigate the canonical docs first.

---

## Task 9: Example — `slide-walk.yaml`

A ~10-scene slide-only demo: every scene is `openSlide` + `setPresentationView`, with `startCountdown` on the first scene and `stopCountdown` on the last.

**Files:**
- Create: `skills/demotime-authoring/examples/slide-walk.yaml`

- [ ] **Step 1: Write the file**

Create `skills/demotime-authoring/examples/slide-walk.yaml`:

```yaml
title: Slide-walk keynote example
description: |
  Slide-only talk pattern. Each scene advances to the next slide.
  Use as a starting point for a keynote-style talk where there is no live coding.
version: 3
scenes:
  - id: slide-walk-title
    title: Title
    moves:
      - action: setPresentationView
      - action: openSlide
        path: .demo/slides/01-title.md
      - action: startCountdown
        minutes: 30
  - id: slide-walk-agenda
    title: Agenda
    moves:
      - action: openSlide
        path: .demo/slides/02-agenda.md
  - id: slide-walk-problem
    title: The problem
    moves:
      - action: openSlide
        path: .demo/slides/03-problem.md
  - id: slide-walk-approach
    title: Our approach
    moves:
      - action: openSlide
        path: .demo/slides/04-approach.md
  - id: slide-walk-demo-intro
    title: What you're about to see
    moves:
      - action: openSlide
        path: .demo/slides/05-demo-intro.md
  - id: slide-walk-results
    title: Results
    moves:
      - action: openSlide
        path: .demo/slides/06-results.md
  - id: slide-walk-tradeoffs
    title: Trade-offs
    moves:
      - action: openSlide
        path: .demo/slides/07-tradeoffs.md
  - id: slide-walk-roadmap
    title: Roadmap
    moves:
      - action: openSlide
        path: .demo/slides/08-roadmap.md
  - id: slide-walk-questions
    title: Q&A
    moves:
      - action: openSlide
        path: .demo/slides/09-questions.md
  - id: slide-walk-thanks
    title: Thanks
    moves:
      - action: openSlide
        path: .demo/slides/10-thanks.md
      - action: stopCountdown
```

- [ ] **Step 2: Verify YAML, unique scene ids, and known actions**

Run:

```bash
python3 - <<'PY'
import yaml, pathlib
known = set(pathlib.Path("scripts/known-actions.txt").read_text().split())
demo = yaml.safe_load(open("skills/demotime-authoring/examples/slide-walk.yaml"))
ids = [s["id"] for s in demo["scenes"]]
assert len(ids) == len(set(ids)), f"Duplicate scene ids: {ids}"
used = {m["action"] for s in demo["scenes"] for m in s["moves"]}
unknown = used - known
assert not unknown, f"Unknown actions: {unknown}"
print(f"OK — {len(ids)} scenes, actions: {sorted(used)}")
PY
```

Expected: `OK — 10 scenes, actions: ['openSlide', 'setPresentationView', 'startCountdown', 'stopCountdown']`. Resolve any failure per Task 8 Step 3's rule (fix references, never the example, without verifying against canonical docs).

---

## Task 10: Example — `code-demo.yaml`

A full code demo following the conventions in design §4.6: intro slide → build → run → http file → edit (insert + replace) → re-run → stop → cleanup. This is the most valuable example and encodes the repo conventions.

**Files:**
- Create: `skills/demotime-authoring/examples/code-demo.yaml`

- [ ] **Step 1: Write the file**

Create `skills/demotime-authoring/examples/code-demo.yaml`:

```yaml
title: Code demo example
description: |
  End-to-end demo pattern: intro slide → build → run → exercise via HTTP file →
  live edit (insert + replace) → re-run → stop → cleanup.

  Encodes the repo conventions from the DemoTime authoring skill:
    - Demo files live in .demo/<topic>.yaml
    - Slides live in .demo/slides/<name>.md
    - Code inserts live in .demo/inserts/<NN>-<desc>.txt
    - A single terminalId ("app-run") is reused across scenes sharing a shell
    - Audience-visible typing uses character-by-character + 75–100 ms speed
    - Setup typing uses instant + autoExecute: true
version: 3
scenes:
  - id: code-demo-intro
    title: Intro
    moves:
      - action: setPresentationView
      - action: openSlide
        path: .demo/slides/intro.md
      - action: startCountdown
        minutes: 20

  - id: code-demo-build
    title: Build
    moves:
      - action: executeTerminalCommand
        terminalId: app-run
        command: npm install
        insertTypingMode: instant
        autoExecute: true

  - id: code-demo-run
    title: Run
    moves:
      - action: executeTerminalCommand
        terminalId: app-run
        command: npm run dev
        insertTypingMode: character-by-character
        insertTypingSpeed: 100
        autoExecute: true

  - id: code-demo-http-file
    title: Exercise the API
    moves:
      - action: openFile
        path: requests.http

  - id: code-demo-edit-insert
    title: Add the new endpoint
    moves:
      - action: openFile
        path: src/server.ts
      - action: insert
        path: src/server.ts
        position: "42"
        contentPath: .demo/inserts/01-new-endpoint.txt

  - id: code-demo-edit-replace
    title: Tighten the validation
    moves:
      - action: replace
        path: src/server.ts
        position: "60:65"
        contentPath: .demo/inserts/02-validation.txt

  - id: code-demo-rerun
    title: Re-run
    moves:
      - action: focusTerminal
        terminalId: app-run
      - action: sendKeybinding
        terminalId: app-run
        keybinding: ctrl+c
      - action: executeTerminalCommand
        terminalId: app-run
        command: npm run dev
        insertTypingMode: instant
        autoExecute: true

  - id: code-demo-stop
    title: Stop
    moves:
      - action: focusTerminal
        terminalId: app-run
      - action: sendKeybinding
        terminalId: app-run
        keybinding: ctrl+c

  - id: code-demo-cleanup
    title: Wrap-up
    moves:
      - action: openSlide
        path: .demo/slides/outro.md
      - action: stopCountdown
```

- [ ] **Step 2: Verify YAML, unique scene ids, terminal-id consistency, and known actions**

Run:

```bash
python3 - <<'PY'
import yaml, pathlib
known = set(pathlib.Path("scripts/known-actions.txt").read_text().split())
demo = yaml.safe_load(open("skills/demotime-authoring/examples/code-demo.yaml"))
ids = [s["id"] for s in demo["scenes"]]
assert len(ids) == len(set(ids)), f"Duplicate scene ids: {ids}"

used = set()
term_ids = set()
for s in demo["scenes"]:
    for m in s["moves"]:
        used.add(m["action"])
        if "terminalId" in m:
            term_ids.add(m["terminalId"])

unknown = used - known
assert not unknown, f"Unknown actions: {unknown}"

# Design §4.5 says terminalIds should be consistent across paired actions.
# In this example we deliberately use only one terminalId ("app-run") to model
# the convention. Verify that.
assert term_ids == {"app-run"}, f"Expected single terminalId 'app-run', got {term_ids}"

print(f"OK — {len(ids)} scenes, actions: {sorted(used)}, terminalIds: {term_ids}")
PY
```

Expected: `OK — 9 scenes, actions: [...], terminalIds: {'app-run'}`. If actions are reported unknown, apply Task 8 Step 3's rule: fix the reference, not the example, without first verifying against canonical docs.

---

## Task 11: Write `SKILL.md`

The always-loaded entry point. Mirrors design §4 section-by-section.

**Files:**
- Create: `skills/demotime-authoring/SKILL.md`

- [ ] **Step 1: Write the file**

Create `skills/demotime-authoring/SKILL.md`:

````markdown
---
name: demotime-authoring
description: Use when creating, editing, or scaffolding DemoTime YAML demo scripts (.demo/*.yaml) — including adding scenes, defining moves, or producing companion slide/insert files.
---

# DemoTime authoring

## What DemoTime is

[DemoTime](https://demotime.show/) is a VS Code extension that drives live demos from declarative YAML scripts. A demo file (typically `.demo/<topic>.yaml`) defines a sequence of **scenes**; each scene runs an ordered list of **moves** (open a slide, run a terminal command, insert code at a position, etc.). This skill helps you author those YAML files — generating new ones, editing existing ones, and scaffolding the companion slide/insert files that moves reference.

## Top-level YAML structure

```yaml
title: <string>
description: <string>
version: <int>    # demo file format version, currently 3
scenes:
  - id: <slug>          # unique, stable
    title: <string>
    moves:
      - action: <action-name>
        # action-specific params
```

Scene `id` must be unique within the file and stable across edits (don't renumber). If the target repo already uses a `scene-<random>-<random>` / `demo-<random>-<random>` id convention, follow it; otherwise use simple kebab-case slugs like `intro`, `run`, `cleanup`.

## Authoring workflow

1. **Confirm the job.** Ask the user whether they want a **new** demo, an **edit** to an existing one, or just **scaffolding** of companion files.
2. **For new demos**, ask for: the talk topic, a rough outline (slide-heavy vs. live-coding vs. mixed), and the target file path (default `.demo/<name>.yaml`).
3. **Identify which action categories the demo needs** and load only the matching `references/<category>.md` files. See *Reference loading rules* below.
4. **Draft the YAML scene by scene.** Start from the closest example in `examples/` and adapt.
5. **Create referenced companion files.** Whenever a move's `path:`, `contentPath:`, or `dest:` points at a file that doesn't exist yet, create it from the matching template under `templates/`. **Announce every file creation — never scaffold silently.**
6. **Run the validation checklist** (below).
7. **Show the user the generated file tree and the final YAML** and ask them to review.

## Reference loading rules

Match the user's intent to the right reference file, and load **only** that file:

| Intent | Load |
|--------|------|
| Slide *actions* (opening / advancing slides during a demo) | `references/preview.md`, `references/demotime.md` |
| Authoring or styling a slide *file* (frontmatter, layout choice, theme choice) | `references/slides-layouts.md`, `references/slides-themes.md` |
| Run terminal commands | `references/terminal.md` |
| Open / rename / create files | `references/file.md` |
| Live code edits (insert / replace / highlight) | `references/patch.md` |
| Trigger VS Code commands or keybindings | `references/vscode.md` |
| Pauses / timing | `references/time.md` |
| Info messages / prompts | `references/interactions.md` |
| Snippets | `references/snippet.md` |
| External apps | `references/external.md` |
| GitHub Copilot | `references/copilot.md` |
| OS / desktop | `references/os-desktop.md` |
| EngageTime | `references/engagetime.md` |
| VS Code settings | `references/setting.md` |
| Text transformations | `references/text.md` |

**Never invent an action name, a layout name, or a theme name.** If the user asks for something you haven't seen in a loaded reference, load the candidate reference first. If it's still not there, WebFetch the canonical page (`https://demotime.show/actions/<category>/`, `https://demotime.show/slides/layouts/`, or `https://demotime.show/slides/themes/`) once and use the result.

## Slide authoring (layouts, themes, styling)

Whenever you create or edit a slide markdown file, load `references/slides-layouts.md` and `references/slides-themes.md` and follow them. Quick rules:

- **Every slide starts with YAML frontmatter** containing at least `layout: <name>`. Default to `layout: default`. Use `intro` for the first slide of a talk and `section` for chapter breaks.
- **A `theme:` is optional per slide.** If the user has chosen a theme for the talk, set it once at the demo level (on the `openSlide` action via the `theme:` / `customTheme:` param — see `references/preview.md`) and let slides inherit it, rather than repeating the theme on every slide.
- **Pick from documented values only.** Built-in layouts: `default`, `intro`, `section`, `quote`, `video`, `image`, `image-left`, `image-right`, `two-columns`, `animated-svg`, `custom`. Built-in themes: `default`, `minimal`, `monomi`, `unnamed`, `quantum`, `frost`, `pixels`.
- **Use the matching template:**
  - `templates/slide.md` → `default`, `intro`, `section`, `quote` (adjust frontmatter `layout:` accordingly).
  - `templates/slide-image-right.md` → `image-right` and, by mirror, `image-left`.
  - `templates/slide-two-columns.md` → `two-columns`.
  - Other layouts: start from `templates/slide.md` and adapt — `references/slides-layouts.md` documents each layout's expected body structure.
- **Custom styling** (brand colors, custom fonts) → scaffold `.demo/themes/<name>.css` overriding the CSS variables listed in `references/slides-themes.md`, and wire it to the `openSlide` action via the `customTheme:` parameter. Do not invent CSS variables outside the documented surface.

## Validation checklist

Run before showing the user the result:

- [ ] Every `action:` value matches an action documented in the bundled references.
- [ ] All required params for that action are present and well-typed.
- [ ] All file paths in `path:`, `contentPath:`, `dest:` either already exist or will be created in this same change.
- [ ] Scene `id`s are unique within the file.
- [ ] `terminalId` values are consistent across paired actions — a scene that sends `ctrl+c` should target the same `terminalId` as the scene that started the process.

## Repo conventions (defaults)

Apply these when the target repo follows them; otherwise follow the repo's existing layout and note the deviation.

- Demo files live in `.demo/<topic>.yaml`.
- Slides live in `.demo/slides/<name>.md`.
- Code inserts live in `.demo/inserts/<NN>-<desc>.txt`.
- A single `terminalId` (e.g. `app-run`) is reused across scenes that share a shell.
- Typed commands the audience should **see**: `insertTypingMode: character-by-character`, `insertTypingSpeed: 75–100`.
- Setup commands the audience does **not** need to see typed: `insertTypingMode: instant`, `autoExecute: true`.
- Demos open with a `setPresentationView` followed by an `openSlide` to a title slide.

## Scaffolding companion files

When a generated scene references a slide or insert that doesn't exist, create it from the matching template:

- Slide → `templates/slide.md` (default), `templates/slide-image-right.md` (image layouts), or `templates/slide-two-columns.md` (two-columns layout). Choose based on the layout the user asked for, defaulting to `slide.md` with `layout: default`.
- Insert → `templates/insert.txt`.

Always set `layout:` in scaffolded slides. Apply `theme:` consistently across the talk — see *Slide authoring* above.

Don't put substantive content in scaffolded files — only a stub with the title (slides) or a header comment (inserts). The user fills in the content.

## Editing existing demos

- Read the full YAML first; understand its existing structure.
- Preserve existing scene `id`s — never renumber.
- Use `Edit` (not `Write`) so unrelated scenes aren't touched.
- Re-run the validation checklist over the changed scenes only.

## Examples

- `examples/minimal.yaml` — smallest valid demo (one slide + countdown). Use for short talks or sanity checks.
- `examples/slide-walk.yaml` — ~10 scenes, slides only. Use for keynote-style talks with no live coding.
- `examples/code-demo.yaml` — full code demo (intro → build → run → edit → re-run → cleanup). Most valuable starting point; encodes the repo conventions above.

## Out of scope

- Running or testing the DemoTime extension itself.
- Installing the DemoTime VS Code extension.
- Generating substantive slide *content* (only stub titles).
- Recording or exporting demo videos.
````

- [ ] **Step 2: Verify front-matter parses and required keys are present**

Run:

```bash
python3 - <<'PY'
import pathlib, re, yaml
text = pathlib.Path("skills/demotime-authoring/SKILL.md").read_text()
m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
assert m, "Missing front-matter"
fm = yaml.safe_load(m.group(1))
assert fm.get("name") == "demotime-authoring", fm
assert "DemoTime" in fm.get("description", ""), fm
print("OK")
PY
```

Expected: `OK`.

- [ ] **Step 3: Verify every reference file mentioned in the reference-loading table exists**

Run:

```bash
python3 - <<'PY'
import re, pathlib
text = pathlib.Path("skills/demotime-authoring/SKILL.md").read_text()
refs = set(re.findall(r"`references/([a-z\-]+)\.md`", text))
missing = []
for r in refs:
    if not pathlib.Path(f"skills/demotime-authoring/references/{r}.md").exists():
        missing.append(r)
assert not missing, f"SKILL.md references missing files: {missing}"
print(f"OK — SKILL.md references {len(refs)} files, all exist")
PY
```

Expected: `OK — SKILL.md references N files, all exist` for some N ≥ 14 (the exact count depends on how the reference-loading table is split; the assertion that matters is that every mentioned file — including `slides-layouts.md` and `slides-themes.md` — exists).

---

## Task 12: Repo-wide validation script

A one-shot script that re-runs every consistency check used in the plan. Useful when editing the skill later.

**Files:**
- Create: `scripts/validate-skill.sh`

- [ ] **Step 1: Write the script**

Create `scripts/validate-skill.sh`:

```bash
#!/usr/bin/env bash
# End-to-end validation of the demotime-authoring skill.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "→ plugin manifest is valid JSON"
python3 -m json.tool .claude-plugin/plugin.json > /dev/null

echo "→ rebuilding known-actions index"
./scripts/build-known-actions.sh > /dev/null

echo "→ each action reference: H1 present, Source line present, table↔H2 consistent"
python3 - <<'PY'
import re, pathlib
expected = {"copilot","demotime","engagetime","external","file","interactions",
            "os-desktop","patch","preview","setting","snippet","terminal",
            "text","time","vscode"}
have = {p.stem for p in pathlib.Path("skills/demotime-authoring/references").glob("*.md")
        if not p.stem.startswith("slides-")}
missing = expected - have
assert not missing, f"Missing action reference files: {missing}"
for name in sorted(expected):
    p = pathlib.Path(f"skills/demotime-authoring/references/{name}.md")
    text = p.read_text()
    assert text.startswith("# "), f"{name}: missing H1"
    assert "Source: https://demotime.show/actions/" in text, f"{name}: missing Source line"
    table = set(re.findall(r"^\|\s*`([^`]+)`\s*\|", text, re.M))
    h2 = set(re.findall(r"^##\s+`([^`]+)`\s*$", text, re.M))
    assert table == h2, f"{name}: table vs H2 mismatch ({table ^ h2})"
print(f"OK — all 15 action references valid")
PY

echo "→ slide-authoring references present, with expected layouts/themes/CSS vars"
python3 - <<'PY'
import pathlib
layouts_text = pathlib.Path("skills/demotime-authoring/references/slides-layouts.md").read_text()
themes_text = pathlib.Path("skills/demotime-authoring/references/slides-themes.md").read_text()
assert layouts_text.startswith("# ") and "Source: https://demotime.show/slides/layouts/" in layouts_text
assert themes_text.startswith("# ") and "Source: https://demotime.show/slides/themes/" in themes_text
for layout in ["default","intro","section","quote","video","image",
               "image-left","image-right","two-columns","animated-svg","custom"]:
    assert f"`{layout}`" in layouts_text, f"slides-layouts.md missing {layout}"
for theme in ["default","minimal","monomi","unnamed","quantum","frost","pixels"]:
    assert f"`{theme}`" in themes_text, f"slides-themes.md missing {theme}"
for var in ["--demotime-color","--demotime-background","--demotime-heading-color",
            "--demotime-heading-background","--demotime-font-size",
            "--demotime-link-color","--demotime-link-active-color",
            "--demotime-blockquote-border","--demotime-blockquote-background"]:
    assert var in themes_text, f"slides-themes.md missing CSS variable {var}"
print("OK — slides-layouts.md (11 layouts) and slides-themes.md (7 themes, 9 vars) valid")
PY

echo "→ slide templates have valid frontmatter with the expected layout"
python3 - <<'PY'
import re, pathlib, yaml
for f, expected in [("slide.md", "default"),
                    ("slide-image-right.md", "image-right"),
                    ("slide-two-columns.md", "two-columns")]:
    text = pathlib.Path(f"skills/demotime-authoring/templates/{f}").read_text()
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    assert m, f"{f}: missing frontmatter"
    fm = yaml.safe_load(m.group(1))
    assert fm.get("layout") == expected, f"{f}: layout {fm.get('layout')!r} != {expected!r}"
print("OK — three slide templates have correct layout frontmatter")
PY

echo "→ each example: parses as YAML, unique scene ids, only known actions"
python3 - <<'PY'
import yaml, pathlib
known = set(pathlib.Path("scripts/known-actions.txt").read_text().split())
for p in sorted(pathlib.Path("skills/demotime-authoring/examples").glob("*.yaml")):
    demo = yaml.safe_load(p.read_text())
    ids = [s["id"] for s in demo["scenes"]]
    assert len(ids) == len(set(ids)), f"{p.name}: duplicate scene ids"
    used = {m["action"] for s in demo["scenes"] for m in s["moves"]}
    unknown = used - known
    assert not unknown, f"{p.name}: unknown actions {unknown}"
    print(f"OK {p.name} — {len(ids)} scenes, {len(used)} distinct actions")
PY

echo "→ SKILL.md front-matter valid + references all exist"
python3 - <<'PY'
import re, pathlib, yaml
text = pathlib.Path("skills/demotime-authoring/SKILL.md").read_text()
m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
assert m, "Missing front-matter"
fm = yaml.safe_load(m.group(1))
assert fm["name"] == "demotime-authoring"
assert "description" in fm
refs = set(re.findall(r"`references/([a-z\-]+)\.md`", text))
for r in refs:
    assert pathlib.Path(f"skills/demotime-authoring/references/{r}.md").exists(), \
        f"SKILL.md references missing {r}.md"
print(f"OK — SKILL.md valid, references {len(refs)} files")
PY

echo "→ all good"
```

Then:

```bash
chmod +x scripts/validate-skill.sh
```

- [ ] **Step 2: Run it**

Run:

```bash
./scripts/validate-skill.sh
```

Expected output (last line): `→ all good`. If any check fails, the script prints which file and which check; return to the corresponding task to fix.

---

## Task 13: Final tree review

- [ ] **Step 1: Print the final file tree**

Run:

```bash
find .claude-plugin skills scripts -type f | sort
```

Expected output (exactly these lines, in this order):

```
.claude-plugin/plugin.json
scripts/build-known-actions.sh
scripts/known-actions.txt
scripts/validate-skill.sh
skills/demotime-authoring/SKILL.md
skills/demotime-authoring/examples/code-demo.yaml
skills/demotime-authoring/examples/minimal.yaml
skills/demotime-authoring/examples/slide-walk.yaml
skills/demotime-authoring/references/copilot.md
skills/demotime-authoring/references/demotime.md
skills/demotime-authoring/references/engagetime.md
skills/demotime-authoring/references/external.md
skills/demotime-authoring/references/file.md
skills/demotime-authoring/references/interactions.md
skills/demotime-authoring/references/os-desktop.md
skills/demotime-authoring/references/patch.md
skills/demotime-authoring/references/preview.md
skills/demotime-authoring/references/setting.md
skills/demotime-authoring/references/slides-layouts.md
skills/demotime-authoring/references/slides-themes.md
skills/demotime-authoring/references/snippet.md
skills/demotime-authoring/references/terminal.md
skills/demotime-authoring/references/text.md
skills/demotime-authoring/references/time.md
skills/demotime-authoring/references/vscode.md
skills/demotime-authoring/templates/insert.txt
skills/demotime-authoring/templates/slide-image-right.md
skills/demotime-authoring/templates/slide-two-columns.md
skills/demotime-authoring/templates/slide.md
```

- [ ] **Step 2: Confirm against design spec success criteria**

Read design §8 and walk through the five success criteria as a checklist. Each should be reachable from the skill content as it stands:

1. "Create a DemoTime YAML for a 10-minute talk on X" → SKILL.md §"Authoring workflow" + `examples/code-demo.yaml`.
2. "Add a scene that runs `npm test`" → SKILL.md reference-loading rules point to `references/terminal.md` only.
3. "Validate my demo" → SKILL.md §"Validation checklist".
4. Unknown action → SKILL.md "Never invent an action name" paragraph instructs WebFetch fallback.
5. Generated YAML matches repo conventions → SKILL.md §"Repo conventions (defaults)" + `examples/code-demo.yaml`.
6. "Give me an image-right slide" / "use the quantum theme" → SKILL.md §"Slide authoring" + `references/slides-layouts.md` / `references/slides-themes.md` + matching template.
7. "Apply brand colors to slides" → SKILL.md §"Slide authoring" custom-styling paragraph + the CSS-variable list in `references/slides-themes.md`.

If any criterion has no anchor in the skill, return to Task 11 and add the relevant section.

- [ ] **Step 3: Tell the user the skill is complete**

Print the final file tree (from Step 1) and tell the user:

> The `demotime-authoring` skill is built. To use it locally, run `claude plugin install <this-repo-path>` (or symlink `skills/demotime-authoring/` into `~/.claude/skills/`). I have not committed anything per your instruction — run `git status` to review and commit when ready.

---

## Self-review notes

Coverage check against design spec:

- §1 Purpose — Task 11 SKILL.md (workflow covers all four jobs, including slide authoring).
- §2 Triggering — Task 11 SKILL.md front-matter `description:`.
- §3 File layout — Task 1 directory tree; Tasks 2, 4–6, 6b, 8–11 fill it.
- §4.1–§4.10 — Task 11 SKILL.md mirrors each subsection.
- §4.7 / §4.7.1 (slide scaffolding & styling) — Task 11 SKILL.md §"Slide authoring" + §"Scaffolding companion files"; Tasks 2 and 6b produce the templates and references this depends on.
- §5 Reference file format — Task 3 establishes the canonical format for action references; Tasks 4–6 follow it. Slide references (Task 6b) use a different shape (enumerations, not parameterised actions) and are documented inline in that task.
- §6 Examples & templates — Tasks 2 (4 templates), 8, 9, 10.
- §7 Building references — Tasks 3–6 (WebFetch per action category) + Task 6b (WebFetch the slide pages).
- §8 Success criteria — Task 13 Step 2 walks through all seven criteria.

Type/name consistency:
- Action names referenced in `examples/code-demo.yaml`: `setPresentationView`, `openSlide`, `startCountdown`, `executeTerminalCommand`, `openFile`, `insert`, `replace`, `focusTerminal`, `sendKeybinding`, `stopCountdown`. Task 7 Step 3 spot-checks the high-value ones and the validation gate in Task 10 Step 2 catches any drift.
- File paths consistent across plan: `skills/demotime-authoring/...` everywhere (no stray `skills/demotime/...` typos).
- The skill name `demotime-authoring` matches in `plugin.json` (Task 1), `SKILL.md` front-matter (Task 11), and the on-disk directory.

No placeholders, no TODOs, no "implement later" — every step is fully specified or has a concrete fallback rule (e.g. Task 5's slug-fallback for `os-desktop`).
