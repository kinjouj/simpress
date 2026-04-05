# Plugin: CategoriesContent


カテゴリ一覧を処理・出力する Simpress プラグイン。  
フラットなカテゴリ構造をネスト構造に変換し、HTML または JSON 形式で出力します。


## 概要


このプラグインは以下の処理を行います。


1. フラットなカテゴリマップを受け取り、各値を複製して独立したネスト用構造を作る
2. `category_indexes.json` が存在する場合、その定義に従って子カテゴリを親カテゴリに移動し、ルートレベルから除外する
3. 設定された `mode` に応じて、サイドバー用 HTML または `categories.json` を出力する


## category_indexes.json


カテゴリの親子関係を定義するオプションファイルです。  
このファイルが存在する場合のみ、ネスト構造への変換が行われます。


```json
{
  "親カテゴリのキー": ["子カテゴリのキー1", "子カテゴリのキー2"],
  "tech": ["ruby", "python"]
}
```


- 定義された子カテゴリは親の `children` に移動し、ルートレベルから削除されます
- 存在しないキーはスキップされます


### 出力


- HTMLモードの場合にはsidebar_categories.erbを元にテンプレートをレンダリングした結果の内容をsidebar_categories_contentとして値を埋め込む
- JSONモードの場合にはpublic/categories.jsonとして出力される



### sidebar_categories.erbの例


```erb
<% categories = @categories.sort_by {|_, value| -value.count }.to_h %>
<% categories.each do |key, value| %>
<div>
  <a href="/archives/category/<%== value.key %>"><%= value.name %> (<%== value.count %>)</a>
  <% if value.children.count > 0 %>
  <div>
    <%== render_partial("sidebar_categories", categories: value.children) %>
  </div>
  <% end %>
</div>
<% end %>
```
