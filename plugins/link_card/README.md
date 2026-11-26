# link_card

Plugin that converts internal links into cards of the linked entry

## Overview

Converts lines containing only `@[](/path)` into a `<div class="link-card">` element with the linked entry's information

## Syntax

```
@[](/target.html)
```

Only lines that are entirely an internal link with an empty label are converted. Other links are left as is. If the linked entry doesn't exist, the line isn't replaced with a card

## Output

```html
<div class="link-card">
  <a href="/target.html">
    <img src="/images/target.webp" alt="" />
    Target Title
  </a>
  Target description
</div>
```
