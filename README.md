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


### SEE ALSO


- [Simpress::Post Object Specification](docs/post.md)
- [Parameters](docs/parameters.md)
- [taxonomies.yaml](docs/taxonomies.md)
- [Theme Variables](docs/theme.md)
- [JSON data format](docs/json.md)
- [Plugin](docs/plugins.md)
