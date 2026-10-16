# Plugins

`plugins/名前/lib`にRubyプロジェクトの構成で配置する。ファイルパスと定数名はZeitwerkの命名規則に従う

有効にするにはconfig.yamlのpluginsにディレクトリ名を列挙する

```yaml
default:
  plugins:
    - sample
    - sample_filter
```

## Custom Plugin

```ruby
module Simpress
  module Plugin
    class Sample
      extend Simpress::Plugin

      def self.priority
        1
      end

      def self.run(entries)
        case config.mode
        when "html"
          bind_context(sample: entries.select(&:index).take(5))
        when "json"
          Simpress::Writer.write("sample.json", Simpress::JSON.dump(entries.select(&:index).take(5), keys: [:id, :title, :permalink]))
        end
      end
    end
  end
end
```

| メソッド | 説明 |
| ---- | ---- |
| run(entries) | 必須。パース後、出力の生成前に呼ばれる |
| priority | 大きいほど先に実行される。デフォルトは1。同じ値は登録順 |
| config | Simpress::Config.instance |
| bind_context(hash) | テンプレートに値を渡す。テンプレートではインスタンス変数(@sample)で参照する |

- entriesは日付の新しい順のEntryの配列で`index: false`も含む

## Custom Markdown Filter

```ruby
class SampleFilter
  extend Simpress::Parser::Markdown::Filter

  def self.preprocess(markdown)
    # TODO
  end

  def self.postprocess(html)
    # TODO
  end
end
```

| メソッド | 説明 |
| ---- | ---- |
| preprocess(markdown) | HTMLへの変換前に呼ばれる |
| postprocess(html) | HTMLへの変換後に呼ばれる |

- どちらも任意。実装しない側は何も加工しない
- 戻り値がStringでない場合は無視される
- 複数のフィルターは登録順に適用される
