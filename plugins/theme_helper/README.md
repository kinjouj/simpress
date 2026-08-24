# theme_helper


テーマテンプレート向けのカスタムヘルパーメソッドを追加するためのプラグイン。ERBテンプレートのスコープにメソッドを注入できる。


なお、以下のヘルパーはデフォルトで常に利用可能。


| メソッド | 説明 |
|---|---|
|`uri(path)`|パスを`.html`拡張子付きのURI文字列に変換する |
|`canonical(path)`|`host`設定値とパスを結合して絶対 URL を返す |
|`encode_json(data)`|データをXSSセーフなJSON文字列にエンコードする|
|`flatten_toc(toc)`|ネストした目次構造をフラットな配列に変換する|



```ruby
# plugins/theme_helper/lib/simpress/plugin/theme_helper.rb

module Simpress
  module Plugin
    module ThemeHelper
      include Simpress::Plugin::ThemeHelper

      def greeting(name)
        "Hello, #{name}!"
      end

      def format_date(date)
        date.strftime("%Y年%m月%d日")
      end
    end
  end
end
```

### 2. ERB テンプレートから呼び出す


```erb
<!-- theme/index.erb -->
<p><%= greeting("World") %></p>
<p><%= format_date(@post.date) %></p>


<!-- デフォルトヘルパーの使用例 -->
<link rel="canonical" href="<%= canonical(@post.path) %>">
<a href="<%= uri(@post.path) %>"><%= @post.title %></a>
```


### `uri(path)`


指定したパスの拡張子を`.html`に変換したURI文字列を返す。


```ruby
uri("posts/hello.md")  #=> "posts/hello.html"
uri("posts/hello")     #=> "posts/hello.html"
```


### `canonical(path)`


`config.yaml`の`host`とパスを結合して絶対URLを返す


```ruby
# host: http://example.com の場合
canonical("posts/hello.md")  #=> "http://example.com/posts/hello.html"
```

### `encode_json(data)`


RubyオブジェクトをXSSセーフなJSON文字列に変換する。JavaScriptへデータを受け渡す際に使用する。


```erb
<script>
  const data = <%= encode_json(@posts) %>;
</script>
```


### `flatten_toc(toc)`


ネストした目次データをフラットな配列に展開する。各要素は`:id`、`:text`、`:depth`を持つ。


```ruby
toc = [
  { id: "section-1", text: "Section 1", children: [
    { id: "section-1-1", text: "Section 1.1" }
  ]}
]

flatten_toc(toc)
#=> [
#     { id: "section-1",   text: "Section 1",   depth: 0 },
#     { id: "section-1-1", text: "Section 1.1", depth: 1 }
#   ]
```
