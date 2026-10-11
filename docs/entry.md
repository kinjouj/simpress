# Entry

| 属性 | 説明 |
| ---- | ---- |
| id | エントリの一意なID |
| title | タイトル |
| date | 日付。Front Matterで省略した場合はファイル名(yyyy-mm-dd)から導出しどちらからも得られない場合は現在時刻になる |
| permalink | エントリのパーマリンク |
| taxonomies | categoriesやtagsなどのTaxonomy |
| layout | レイアウト名。デフォルトは"page" |
| index | 一覧に表示するかどうか。デフォルトはtrue。日付をFront Matterまたはファイル名から導出できなかった場合は強制的にfalseになる |
| draft | 下書きかどうか。デフォルトはfalse |
| cover | カバー画像のパス。未指定の場合は本文の最初の画像,それもなければDEFAULT_COVERになる |
| description | 説明。未指定の場合はMarkdown本文の最初の空でない行になる |
| content | レンダリング済みのHTML |
| toc | 目次の構造 |
| prev | 次に古いエントリへのEntry::Link(なければnil) |
| next | 次に新しいエントリへのEntry::Link(なければnil) |
| params | パース時に渡された生のパラメータ |
| markdown | レンダリング前のMarkdown本文(生のまま) |

## Entry::Link

他のエントリへの参照を表す軽量なクラス。idとtitleとpermalinkのみを保持する

```json
{
  "id": "entry-789",
  "title": "Older Entry",
  "permalink": "/older-entry"
}
```
