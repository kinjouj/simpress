# Entry

Represents a single entry

| Attribute   | Description |
| ----------- | ----------- |
| id          | Unique ID of the entry |
| title       | Title |
| date        | Date. If omitted in Front Matter, derived from the file name (yyyy-mm-dd). If neither is available, falls back to the current time |
| permalink   | Permalink of the entry |
| taxonomies  | Taxonomies such as categories/tags |
| layout      | Layout name. Defaults to "page" |
| index       | Whether to show it in listings. Defaults to true. Forced to false if date could not be derived from Front Matter or file name |
| draft       | Whether it's a draft. Defaults to false |
| markdown    | Raw Markdown body before rendering |
| params      | Raw parameters passed at parse time |
| cover       | Cover image path. Falls back to the first image found in the body, then to DEFAULT_COVER |
| description | Description. Falls back to the text of the first paragraph in the rendered body |
| content     | Rendered HTML |
| toc         | Table of contents structure |
| prev        | Entry::Link to the next older entry (nil if none) |
| next        | Entry::Link to the next newer entry (nil if none) |

## Entry::Link

A lightweight class representing a reference to another entry, It only holds id, title, and permalink.

```json
{
  "id": "entry-789",
  "title": "Older Entry",
  "permalink": "/older-entry"
}
```
