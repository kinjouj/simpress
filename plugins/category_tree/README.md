# Plugin: CategoryTree

Plugin that processes and outputs the category list. Converts a flat category structure to a nested one and outputs HTML or JSON

## Overview

1. If `category_indexes.json` exists, moves child categories under their parents as defined there and removes them from the root level
1. Outputs sidebar HTML or `categories.json` depending on `mode`

## Output

- html: template instance variable @sidebar_categories_content (String, the rendered sidebar_categories.erb)
- json: categories.json (array of key, name, count, children)

## category_indexes.json

Optional file that defines parent-child relations. Categories are nested only when this file exists

```json
{
  "parent category key": ["child category key 1", "child category key 2"],
  "tech": ["ruby", "python"]
}
```

- Defined children move into the parent's `children` and are removed from the root level
- Keys that don't exist are skipped

### sidebar_categories.erb

```erb
<% categories = @categories.sort_by {|v| -v.count } %>
<% categories.each do |value| %>
<div>
  <a href="/archives/categories/<%== value.key %>"><%= value.name %> (<%== value.count %>)</a>
  <% if value.children.count > 0 %>
  <div>
    <%== render_partial("sidebar_categories", categories: value.children) %>
  </div>
  <% end %>
</div>
<% end %>
```
