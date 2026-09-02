# Backlinks


ビルド時に全記事の内部リンクを解析し、各記事に被参照情報（backlinks）を付与する機能。


## post.backlinks

### inbound

その記事を参照している記事のpermalinkの配列。

```ruby
post.backlinks.inbound
# => ["/2026/01/post-a.html", "/2026/02/post-b.html"]
```

## 制限事項

- 標準のMarkdownリンク記法（`[text](/path)`）のみ対応
- `inline_note_filter` の独自記法（`[^]: <a href="...">` 形式）は対象外
