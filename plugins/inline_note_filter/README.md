# inline_note_filter

Markdown preprocessor plugin. Converts a custom inline note syntax into an HTML note block

## Overview

Converts lines starting with `[^]: ` into a `<div class="note">` element

## Syntax

```
[^]: note content
```

Spaces after the colon are ignored, however many there are. It must be at the start of a line. It isn't converted in the middle of a line

## Output

```html
<div class="note">
  <i class="fa-solid fa-circle-exclamation"></i>
  <span>note content</span>
</div>
```
