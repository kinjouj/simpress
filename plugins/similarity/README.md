# Plugin: Similarity

Plugin that gets related entries from parsed Markdown. When enabled, data is available through these methods

- Simpress::Plugin::Similarity::EntryWithSimilarities#similarities
- Simpress::Plugin::Similarity::EntryWithSimilarities#as_json (similarities is injected when content is included)

Entries with `index: false` are excluded. They are neither compared nor given similarities

## Parameters

BM25-based similarity parameters, defined in lib/simpress/plugin/similarity.rb

| Constant | Value | Description |
| -------- | ----- | ----------- |
| K1 | 1.2 | Term frequency saturation |
| B | 0.75 | Document length normalization |
| TF_SCALE | K1 + 1.0 | Derived from K1 |
| MAX_DF_RATIO | 0.3 | Terms in more than this ratio of entries are ignored |
| MIN_DF_LIMIT | 10 | Terms in this many entries or fewer are never ignored |
| CACHE_FILE | similarity.cache | Keyword cache (MessagePack) |
| LIMIT | 5 | Max related entries per entry |
