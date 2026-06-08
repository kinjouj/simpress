## Simpress


a simple static blog generator


### Requirement


* Ruby3.x


### Installation


```bash
git clone https://github.com/kinjouj/simpress.git blog
cd blog
bundle install
cp config.yaml.orig config.yaml
./simpress build
```


jsonモード使う場合は以下も必要


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


title以外は基本optional。但し、date/permalinkなどはMarkdownのファイル名などから算出される場合もあるためdate/permalinkは
適切に設定推奨。以下参照


|parameter|Description|
|:---------:|-----------|
|title      |タイトル   |
|date       |日付(DateTime)。無い場合はファイル名から算出(yyyy-mm-dd)。ファイル名から算出できない場合はエラーになる|
|permalink  |パスURL|
|cover      |サムネイル画像。指定しない場合は/images/no_image.webpが使用される。Markdown記法によって抽出可能|
|categories |カテゴリー。配列形式じゃなくても指定可能|
|layout     |記事が使用するテンプレートの指定。デフォルトは"page"|
|index      |記事インデックスに載せるかのフラグ。デフォルトはtrue|
|draft      |記事の下書きフラグ。trueの場合は出力されない。デフォルトはfalse|
|description|meta description値。無い場合はコンテンツから抽出生成される|


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


※index: falseの場合は@paginatorは無い


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
