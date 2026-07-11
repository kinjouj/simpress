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


# taxonomies.yaml


Defines taxonomies and their URL slug aliases.


```yaml
types:
  - series
  - tags
 
aliases:
  categories:
    社会: shakai
  series:
    Ruby入門: ruby-intro
```


Both `types` and `aliases` are optional.


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
|:---------:|-----------|
|title      |The title|
|date       |Date (DateTime). If omitted, it is derived from the file name (yyyy-mm-dd). An error occurs if it cannot be derived from the file name|
|permalink  |The URL path|
|cover      |Thumbnail image. If omitted, `/images/no_image.webp` is used. Can also be extracted from Markdown syntax|
|categories |Categories. Can be specified even without array syntax|
|layout     |Specifies the template used by the post. Defaults to `"page"`|
|index      |Flag for whether the post appears in the index. Defaults to `true`|
|draft      |Draft flag for the post. If `true`, the post is not output. Defaults to `false`|
|description|The meta description value. If omitted, it is generated from the content|


### Theme(index.erb) Variables


|variable  |Description|
|:--------:|:---------:|
|@posts    |Array[Simpress::Post]|
|@paginator|Simpress::Paginator|
|@key      |String optional|


### Theme(page.erb) Variables


|variable   |Description|
|:---------:|:-----------:|
|@post      |Simpress::Post|
|@paginagtor|Paginator Data Object|


※ If `index: false`, `@paginator` is not present


### Custom Markdown Enhancer


```ruby
class SampleFilter
  extend Simpress::Parser::Redcarpet::Enhancer

  def self.preprocess(markdown)
    # TODO
  end
end
```


into plugins directory ruby project structures(plugins/sample_filter/lib/sample_filter.rb)


### Custom Plugin


```ruby
module Simpress
  module Plugin
    class Sample
      extend Simpress::Plugin

      def self.run(posts, pages, categories)
        # TODO
      end
    end
  end
end
```


### Custom Theme Helper


Add methods that are usable inside `.erb` templates by including `Simpress::Theme::Helper::Plugin`.


```ruby
module Simpress
  module Plugin
    module SampleHelper
      include Simpress::Theme::Helper::Plugin

      def sample_helper(value)
        # TODO
      end
    end
  end
end
```


into plugins directory ruby project structures(plugins/sample_helper/lib/sample_helper.rb)


Once included, the module is registered automatically and its methods become available in any theme template, e.g. `<%= sample_helper(post) %>`.
