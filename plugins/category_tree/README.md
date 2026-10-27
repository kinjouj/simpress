# Plugin: CategoryTree

カテゴリ一覧を処理・出力するプラグイン。フラットなカテゴリ構造をネスト構造に変換しHTMLまたはJSON形式で出力

## 概要

1. `category_indexes.json`が存在する場合、その定義に従って子カテゴリを親カテゴリに移動し、ルートレベルから除外する
1. 設定された`mode`に応じてサイドバー用HTMLまたは`categories.json`を出力する

## category_indexes.json

カテゴリの親子関係を定義するオプションファイル。このファイルが存在する場合のみネスト構造への変換

```json
{
  "親カテゴリのキー": ["子カテゴリのキー1", "子カテゴリのキー2"],
  "tech": ["ruby", "python"]
}
```

- 定義された子カテゴリは親の`children`に移動しルートレベルから削除
- 存在しないキーはスキップされます

### sidebar_categories.erb

```erb
<% categories = @categories.sort_by {|v| -v.count } %>
<% categories.each do |value| %>
<div>
  <a href="/archives/categories/<%== value.key %>"><%= value.name %> (<%== value.count %>)</a>
  <% if value.children.count > 0 %>
  <div>
    <%== render_partial("sidebar_categories", categories: value.children) %>
  </div>
  <% end %>
</div>
<% end %>
```
