# Simpress Data Format Specification


## Post (`Permalink` renderer)


```json
{
  "id": "post-123",
  "title": "string",
  "date": "2026-01-01T00:00:00+09:00",
  "permalink": "/sample-post",
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
    "id": "post-789",
    "title": "Older Post",
    "permalink": "/older-post"
  },
  "next": {
    "id": "post-456",
    "title": "Newer Post",
    "permalink": "/newer-post"
  }
}
```


## Post list


`/archives/page/:n.json`, `/archives/:year/:month/:n.json`, `/archives/:taxonomy/:term/:n.json`:


```json
{
  "posts": [
    {
      "id": "post-123",
      "title": "string",
      "date": "2026-01-01T00:00:00+09:00",
      "permalink": "/sample-post",
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


## Page (`Page` renderer)


```json
{
  "id": "page-1",
  "title": "string",
  "content": "<p>...</p>"
}
```


Output path: `/page/:permalink.json`
