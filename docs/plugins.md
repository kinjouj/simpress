### Custom Markdown Filter

```ruby
class SampleFilter
  extend Simpress::Parser::Markdown::Filter

  def self.preprocess(markdown)
    # TODO
  end
end
```

pluginsディレクトリ内にRubyプロジェクトの構成で配置する(plugins/sample_filter/lib/sample_filter.rb)

カスタムプラグインと同様に,有効にするにはconfig.yamlのpluginsに列挙する必要がある.


### Custom Plugin

```ruby
module Simpress
  module Plugin
    class Sample
      extend Simpress::Plugin

      def self.run(entries)
        # TODO
      end
    end
  end
end
```
