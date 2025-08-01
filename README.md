## Simpress


a simple static blog generator


### Requirement


* Ruby3.1.7


### Installation


```bash
git clone https://github.com/kinjouj/simpress.git blog
cd blog
git submodule update --init
bundle install
cp config.yaml.orig config.yaml
rake build
```


### Configuration(config.yaml)


```yaml
default:
  debug: false
  logging: false
  mode: "html"
  host: "https://example.com"
  paginate: 10
  source_dir: "source"
  plugin_dir: "plugins"
  output_dir: "public"
  theme_dir: "themes"
  cache_dir: ".cache"
  preprocessors:
    - hostname
    - html_loader
    - recent_posts
```


### Markdown Format


```markdown
---
title: title
date: 2000-01-01 00:00:00
permalink: /test.html
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


* title: タイトル
* date: 日付(DateTime)。無い場合はファイル名から算出。ファイル名から算出できない場合はエラーになる
* permalink: パスURL。無い場合はファイル名などから算出
* cover: サムネイル画像。指定しない場合は/images/no_image.pngが使用される。コンテンツ中で使用している画像がある場合にはそれが利用される
* layout: 記事の種類。postかpageで指定。指定しない場合はpost(pageはインデックスが作成されない)
* published: 記事を出力するかのフラグ。デフォルトはtrue
* description: meta description値。無い場合はコンテンツから抽出生成される
* categories: カテゴリー。配列形式じゃなくても指定可能


### Theme(index.erb) Variables


* @posts: Array[Simpress::Model::Post]
* @paginator: Simpress::Paginator::Index instance
* @key: String optional


### Theme(post.erb) Variables


* @post: Simpress::Model::Post instance
* @paginagtor: Simpress::Paginator::Post instance


### Theme(page.erb) Variables


Theme(post.erb)とほぼ同じ。ただし、@paginatorは無い


### Custom Markdown Filter


```ruby
module A
  extend Simpress::Parser::Redcarpet::Filter

  def self.preprocess(markdown)
    # TODO
  end
end
```


into plugins directory ruby project structures(plugins/sample_filter/lib/sample_filter.rb)


### Custom Preprocessor


```ruby
module Simpress
 module Plugin
  module Preprocessor
    class Sample
      extend Simpress::Plugin::Preprocessor

      def self.run(posts, pages, categories)
        # TODO
      end
    end
  end
end
```


### Plugin: HtmlLoader


themes/htmlにhtmlファイルを置くとerbで"html_ファイル名"で参照できる。例えばthemes/html/test.htmlとすると


```erb
<%= @html_test %>
```


### Plugin: RecentPosts


@postsから先頭から数件だけを切り出したのをthemes/sidebar_recent_posts.erbを使って描画したのを@sidebar_recent_posts_contentとして利用できる
切り出される件数はconfig.yamlのpaginateと同数(設定されていない場合には8)
themes/sidebar_recent_posts.erbで@recent_postsで切り出されたのを利用できる


```erb
<% @recent_posts.each |post| %>
<%= post.title %>
<% end %>
```


表示したいerb側では@sidebar_recent_posts_contentを以下のように記述することで表示可能


```erb
<%= @sidebar_recent_posts_content %>
```
