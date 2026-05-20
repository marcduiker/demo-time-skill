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
| `video` | Embed a video | Verify the exact frontmatter key (likely `video:`) against the canonical page when authoring. |
| `image` | Full-width image | Verify the exact frontmatter key (likely `image:`) against the canonical page when authoring. |
| `image-left` | Two-column with image on left, body on right | `image:` in frontmatter; body markdown becomes the right column. |
| `image-right` | Two-column with image on right, body on left | `image:` in frontmatter; body markdown becomes the left column. |
| `two-columns` | Split body into two text columns | Verify the exact splitter from the canonical page (commonly `::: left` / `::: right` containers). |
| `animated-svg` | Embed an animated SVG | Verify the exact frontmatter key against the canonical page when authoring. |
| `custom` | User-defined structure | User supplies the markdown body verbatim. |

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

Image-centric layouts. The `image:` frontmatter key points at the image; the body markdown becomes the text column for `image-left` / `image-right`.

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

Body content is split into a left and a right column. **Verify the exact splitter against the canonical page before relying on this** — the canonical layouts page does not enumerate the splitter syntax. The convention below uses Markdown-it container fences and is a reasonable default; if DemoTime uses a different splitter, update the template and this section to match.

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

`video` and `animated-svg` are media-centric — verify the exact frontmatter key (likely `video:` and `svg:` respectively) against the canonical page when authoring. `custom` lets the user write arbitrary markdown/HTML; pair it with a custom theme (see `slides-themes.md`) when overriding structure.

## Header and footer

Slides can include consistent header/footer regions across layouts for branding. Consult the canonical page for the exact frontmatter keys.

---

## Authoring rules for Claude

1. **Always set `layout:`** when scaffolding a slide. Default to `default`. Use `intro` for the first slide of a talk and `section` for chapter breaks.
2. **Never invent a layout name.** If the user asks for a layout not in the table above, WebFetch the canonical page once and add it here.
3. **Verify layout-specific frontmatter keys (e.g. `image:`, `video:`, slot splitters) against the canonical page** when actually authoring a slide — the placeholders in this file flagged as "verify" indicate where the canonical docs are the source of truth.
