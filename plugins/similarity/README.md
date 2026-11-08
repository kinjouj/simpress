# Plugin: Similarity

パースされたMarkdownから関連記事の情報を取得するプラグイン。このプラグインを有効にした場合には以下のメソッドでデータを取得できる

- Simpress::Plugin::Similarity::EntryWithSimilarities#similarities
- Simpress::Plugin::Similarity::EntryWithSimilarities#as_json(contentを含む場合にsimilaritiesが注入される)

## Parameters

lib/simpress/plugin/similarity.rbに定義されている、BM25ベースの類似度計算に関するパラメータ。

|定数|値|説明|
|---|---|---|
|K1|1.2|BM25の項頻度飽和度を制御するパラメータ|
|B|0.75|BM25の文書長による正規化の強さを制御するパラメータ|
|TF_SCALE|K1 + 1.0|項頻度スコアのスケーリング係数(K1から導出)|
|MAX_DF_RATIO|0.3|全記事のうちこの割合を超える記事に出現する語を類似度計算から除外する閾値|
|MIN_DF_LIMIT|10|除外しない出現記事数の下限(記事数が少ない場合に大半の語が除外されるのを防ぐ)|
|CACHE_FILE|similarity.cache|類似度計算結果(MessagePack形式)のキャッシュファイル名|
|LIMIT|5|関連記事として保持する件数の上限|
