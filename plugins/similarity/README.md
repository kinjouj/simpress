# Plugin: Similarity


パースされたMarkdownから関連記事の情報を取得するプラグイン。このプラグインを有効にした場合には以下のメソッドでデータを取得できる


- Simpress::Post.similarities
- Simpress::Post.as_json(as_jsonを行った際にsimilaritiesが注入される)


## Parameters


lib/simpress/plugin/similarity.rbに定義されている、BM25ベースの類似度計算に関するパラメータ。


|定数|値|説明|
|---|---|---|
|K1|1.2|BM25の項頻度飽和度を制御するパラメータ|
|B|0.75|BM25の文書長による正規化の強さを制御するパラメータ|
|TF_SCALE|K1 + 1.0|項頻度スコアのスケーリング係数(K1から導出)|
|LINK_WEIGHT|10.0|バックリンクによる類似度スコアへの加重値|
|CACHE_FILE|similarity.cache|類似度計算結果(MessagePack形式)のキャッシュファイル名|
