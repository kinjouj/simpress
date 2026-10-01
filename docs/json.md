# Simpress Data Format Specification

## Entry (`Permalink` renderer)

```json
{
  "id": "entry-123",
  "title": "string",
  "date": "2026-01-01T00:00:00+09:00",
  "permalink": "/sample-entry",
  "taxonomies": {
    "categories": [
      {
        "key": "ruby",
        "name": "Ruby"
      }
    ]
  },
  "content": "<p>...</p>",
  "toc": [
    {
      "id": "section-1",
      "text": "Heading 1",
      "children": []
    },
    {
      "id": "section-2",
      "text": "Heading 2",
      "children": [
        {
          "id": "section-2-1",
          "text": "Subheading"
        }
      ]
    }
  ],
  "prev": {
    "id": "entry-789",
    "title": "Older Entry",
    "permalink": "/older-entry"
  },
  "next": {
    "id": "entry-456",
    "title": "Newer Entry",
    "permalink": "/newer-entry"
  }
}
```

## Entry list

`/archives/page/:n.json`, `/archives/:year/:month/:n.json`, `/archives/:taxonomy/:term/:n.json`:

```json
{
  "entries": [
    {
      "id": "entry-123",
      "title": "string",
      "date": "2026-01-01T00:00:00+09:00",
      "permalink": "/sample-entry",
      "taxonomies": {
        "categories": [
          {
            "key": "ruby",
            "name": "Ruby"
          }
        ]
      },
      "cover": "/images/cover.png",
      "description": "string"
    }
  ],
  "total_pages": 3
}
```
