## Simpress


a simple static blog generator


### Requirement


* Ruby3.x
* MeCab (required by the `natto` gem for Japanese morphological analysis)


### Installation


```bash
git clone https://github.com/kinjouj/simpress.git blog
cd blog
bundle install
cp config.yaml.orig config.yaml
./simpress build
```


If you use JSON mode, the following is also required


```bash
npm install
```


### Configuration(config.yaml)


```yaml
default:
  logging: false
  mode: html
  host: https://example.com
  paginate: 10
  plugins:
    - recent_posts
```


### Markdown Format


```markdown
---
title: title
date: 2000-01-01 00:00:00
permalink: /test
cover: /images/test.jpg
description: optional
categories:
  - test
---


TEST BODY
```


All parameters except `title` are basically optional. However, since `date`/`permalink` may be derived from the Markdown file name, it is recommended to set them explicitly. See below for details.


|parameter|Description|
|:---------:|:-----------|
|title      |The title|
|date       |Date (DateTime). If omitted, it is derived from the file name (yyyy-mm-dd). An error occurs if it cannot be derived from the file name|
|permalink  |The URL path|
|cover      |Thumbnail image. If omitted, `/images/no_image.webp` is used. Can also be extracted from Markdown syntax|
|categories |Categories. Can be specified even without array syntax|
|tags       |Tags. Can be specified even without array syntax|
|layout     |Specifies the template used by the post. Defaults to `"page"`|
|index      |Flag for whether the post appears in the index. Defaults to `true`|
|draft      |Draft flag for the post. If `true`, the post is not output. Defaults to `false`|
|description|The meta description value. If omitted, it is generated from the content|


### SEE ALSO


- [taxonomies.yaml](docs/taxonomies.md)
- [Theme Variables](docs/theme.md)
- [JSON data format](docs/json.md)
- [Plugin](docs/plugins.md)
- [Backlinks](docs/backlinks.md)
