# Entry

| 属性 | 説明 |
| ---- | ---- |
| id | 一意なID |
| title | タイトル |
| date | 日付。省略した場合はファイル名(yyyy-mm-dd)から取得、どちらからも得られない場合は現在時刻 |
| permalink | パーマリンク |
| taxonomies | categoriesやtagsなどのTaxonomy |
| layout | レイアウト名。デフォルトは"page" |
| index | 一覧に表示するかどうか。デフォルトはtrue、dateを取得できなかった場合は強制的にfalseになる |
| draft | 下書きフラグ。デフォルトはfalse |
| cover | カバー画像のパス。未指定の場合は本文の最初の画像、それもなければ[DEFAULT_COVER](./parameters.md)になる |
| description | 説明。未指定の場合はMarkdown本文の最初の空でない行になる |
| content | レンダリング済みのHTML |
| toc | 目次の構造 |
| prev | 次に古いエントリへのEntry::Link(なければnil) |
| next | 次に新しいエントリへのEntry::Link(なければnil) |
| markdown | レンダリング前のMarkdown本文 |

## Entry::Link

他のエントリへの参照を表す軽量なクラス。idとtitleとpermalinkのみを保持する

```json
{
  "id": "entry-789",
  "title": "Older Entry",
  "permalink": "/older-entry"
}
```
