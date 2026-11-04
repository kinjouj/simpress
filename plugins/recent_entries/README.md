# Plugin: RecentEntries

最新の記事の一覧を取得するプラグイン。このプラグインを有効にした場合にはmodeに応じて以下でデータを取得できる

- html: テンプレートのインスタンス変数@recent_entries(Array[Simpress::Entry])
- json: recent_entries.json(id、title、permalinkの配列)

## Parameters

lib/simpress/plugin/recent_entries.rbに定義されている、取得する記事に関するパラメータ。

|定数|値|説明|
|---|---|---|
|LIMIT|5|取得する件数の上限|
