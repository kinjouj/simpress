# Simpress データフォーマット仕様

## Post（`Permalink` renderer）

```json
{
  "id": "post-123",
  "title": "string",
  "date": "2026-01-01T00:00:00+09:00",
  "permalink": "/sample-post",
  "taxonomies": {
    "categories": [{ "key": "ruby", "name": "Ruby" }]
  },
  "content": "<p>...</p>",
  "toc": [
    { "id": "section-1", "text": "見出し1", "children": [] },
    {
      "id": "section-2",
      "text": "見出し2",
      "children": [{ "id": "section-2-1", "text": "サブ見出し" }]
    }
  ],
  "prev": { "id": "post-789", "title": "Older Post", "permalink": "/older-post" },
  "next": { "id": "post-456", "title": "Newer Post", "permalink": "/newer-post" }
}
```


## Post一覧


```json
[
  {
    "id": "post-123",
    "title": "string",
    "date": "2026-01-01T00:00:00+09:00",
    "permalink": "/sample-post",
    "taxonomies": { "categories": [{ "key": "ruby", "name": "Ruby" }] },
    "cover": "/images/cover.png",
    "description": "string"
  }
]

```

併置される`meta.json`:


```json
{ "total_pages": 3 }
```


出力パス:
- `/archives/page/:n.json`
- `/archives/:year/:month/:n.json`
- `/archives/:taxonomy/:term/:n.json`


## Page（`Page` renderer）


```json
{
  "id": "page-1",
  "title": "string",
  "content": "<p>...</p>"
}
```


出力パス: `/page/:permalink.json`
