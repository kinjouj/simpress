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
rake build
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


### Markdown Format


```markdown
---
title: title
date: 2000-01-01 00:00:00
permalink: /test
cover: /images/test.jpg
layout: post
published: true
description: optional
categories:
  - test
---


TEST BODY
```


title以外は基本optional。但し、date/permalinkなどはMarkdownのファイル名などから算出される場合もあるためdate/permalinkは
適切に設定推奨。以下参照


|parameter  |Description|
|:-------:  |-----------|
|title      |タイトル   |
|date       |日付(DateTime)。無い場合はファイル名から算出。ファイル名から算出できない場合はエラーになる|
|permalink  |パスURL。無い場合はファイル名などから算出|
|cover      |サムネイル画像。指定しない場合は/images/no_image.pngが使用される。コンテンツ中で使用している画像がある場合にはそれが利用される|
|layout     |記事の種類。postかpageで指定。指定しない場合はpost(pageはインデックスが作成されない)|
|published  |記事を出力するかのフラグ。デフォルトはtrue|
|description|meta description値。無い場合はコンテンツから抽出生成される|
|categories |カテゴリー。配列形式じゃなくても指定可能|


---


### Theme(index.erb) Variables


|variable  |Description|
|:--------:|-----------|
|@posts    |Array[Simpress::Model::Post]|
|@paginator|Simpress::Paginator::Index instance|
|@key      |String optional|


### Theme(post.erb or page.erb) Variables


|variable|Description|
|:---------:|-----------|
|@post      |Simpress::Model::Post instance|
|@paginagtor|Simpress::Paginator::Post instance|


※page.erbに@paginatorは無い


### Custom Markdown Filter


```ruby
class SampleFilter
  extend Simpress::Markdown::Filter

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


### Plugin: RecentPosts


@postsから先頭から数件だけを切り出したのを@recent_postsとして利用できる。
切り出される件数はconfig.yamlのpaginateと同数(設定されていない場合には5)


```erb
<% @recent_posts.each |post| %>
<%= post.title %>
<% end %>
```


### Plugin: Similarity


パースされたMarkdownから関連記事の情報を取得してJSONで出力するプラグイン。このプラグインを有効にした場合には以下のメソッドでデータを取得できる


- Simpress::Post.similarities

- Simpress::Post.as_json(as_jsonを行った際にsimilaritiesが注入される)
