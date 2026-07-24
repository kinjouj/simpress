## Theme Variables


### index.erb


| variable   | Description |
|:----------:|:-------------|
| @posts     | Array[Simpress::Post] |
| @paginator | Simpress::Paginator |
| @key       | String optional |


### page.erb


| variable | Description |
|:--------:|:-------------|
| @post    | Simpress::Post |


## Simpress::Post API Reference

Properties available on `post` inside ERB templates:


| property | type |
|---|---|
| `id` | String |
| `title` | String |
| `date` | Time |
| `permalink` | String |
| `taxonomies` | Hash |
| `content` | String |
| `description` | String |
| `cover` | String |
| `toc` | Array |
| `prev` | PostLink or nil |
| `next` | PostLink or nil |
| `layout` | String |
| `index` | Boolean |
| `draft` | Boolean |
| `markdown` | String |


`PostLink`は`id`/`title`/`permalink`のみを持つ。
