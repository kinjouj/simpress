## Simpress

a simple static blog generator

### Requirement

* Ruby >= 3.2
* MeCab (required by the `natto` gem for Japanese morphological analysis)

### Installation

```bash
git clone https://github.com/kinjouj/simpress.git blog
cd blog
bundle install
npm install
cp config.yaml.orig config.yaml
./simpress build
```

### Configuration(config.yaml)

```yaml
default:
  mode: html
  logging: false
  host: https://example.com
  paginate: 10
  plugins:
    - recent_entries
```

### Markdown Format

```markdown
---
title: title
permalink: /test
date: 2000-01-01 00:00:00
cover: /images/test.jpg
description: optional
categories:
  - test
---


TEST BODY
```

### SEE ALSO

- [Simpress::Entry Object Specification](docs/entry.md)
- [Parameters](docs/parameters.md)
- [taxonomies.yaml](docs/taxonomies.md)
- [Theme Variables](docs/theme.md)
- [JSON data format](docs/json.md)
- [Plugin](docs/plugins.md)
