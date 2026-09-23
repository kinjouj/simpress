# Post

Represents a single post.

| Attribute | Description |
| --- | --- |
| id | Unique ID of the post |
| title | Title |
| date | Date. If omitted in Front Matter, derived from the file name (yyyy-mm-dd). If neither is available, falls back to the current time |
| permalink | Permalink of the post |
| taxonomies | Taxonomies such as categories/tags |
| layout | Layout name. Defaults to "page" |
| index | Whether to show it in listings. Defaults to true. Forced to false if date could not be derived from Front Matter or file name |
| draft | Whether it's a draft. Defaults to false |
| markdown | Raw Markdown body before rendering |
| params | Raw parameters passed at parse time |
| cover | Cover image path. Falls back to the first image found in the body, then to DEFAULT_COVER |
| description | Description. Falls back to the text of the first paragraph in the rendered body |
| content | Rendered HTML |
| toc | Table of contents structure |
| links | Array of internal links (starting with /) found in the body |
| prev | Post::Link to the next older post (nil if none) |
| next | Post::Link to the next newer post (nil if none) |
| backlinks | Array of Post::Link referencing posts that link to this one |

## Post::Link

A lightweight class representing a reference to another post, used for prev/next/backlinks. It only holds id, title, and permalink.

```json
{
  "id": "post-789",
  "title": "Older Post",
  "permalink": "/older-post"
}
```
