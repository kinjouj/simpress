# Entry

| Attribute | Description |
| --------- | ----------- |
| id | Unique ID |
| title | Title |
| date | Date. If omitted, index is forced to false |
| permalink | Permalink |
| taxonomies | Taxonomies such as categories and tags |
| layout | Layout name. Defaults to "page" |
| index | Whether to list the entry. Defaults to true. Forced to false when date is missing |
| draft | Draft flag. Defaults to false |
| cover | Cover image path. Defaults to the first image in the body, then [DEFAULT_COVER](./parameters.md) |
| description | Description. Defaults to the first non-empty line of the Markdown body |
| content | Rendered HTML |
| toc | Table of contents structure |
| prev | Entry::Link to the next older Entry (nil if none) |
| next | Entry::Link to the next newer Entry (nil if none) |
| markdown | Markdown before rendering |
| params | Hash of the front matter and the completed values above |

## Entry::Link

Lightweight class that references another entry

```json
{
  "id": "entry-789",
  "title": "Older Entry",
  "permalink": "/older-entry",
  "cover": "/images/no_image.webp"
}
```
