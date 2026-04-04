# Plugin: Similarity


パースされたMarkdownから関連記事の情報を取得するプラグイン。このプラグインを有効にした場合には以下のメソッドでデータを取得できる


- Simpress::Post.similarities
- Simpress::Post.as_json(as_jsonを行った際にsimilaritiesが注入される)
