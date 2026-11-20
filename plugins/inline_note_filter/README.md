# inline_note_filter

Markdown preprocessor plugin. Converts a blockquote line with a `[!NOTE]` marker into an HTML note block

## Overview

Converts lines starting with `> [!NOTE] ` into a `<div class="note">` element

## Syntax

```
> [!NOTE] note content
```

It must be at the start of a line. Spaces around the marker are ignored, however many there are. The text after the marker is the note, up to the end of the line. It isn't converted in the middle of a line

Only the marker line is converted. A following `>` line isn't part of the note and stays a plain blockquote

This isn't the GFM alert syntax, which puts `[!NOTE]` alone on its own line. On GitHub it is shown as a plain blockquote

The conversion runs on the Markdown source, so it also applies inside a fenced code block. Markdown inside the note isn't rendered

## Output

```html
<div class="note">
  <i class="fa-solid fa-circle-exclamation"></i>
  <span>note content</span>
</div>
```
