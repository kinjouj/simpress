# Plugins

Place plugins under `plugins/name/lib` as a Ruby project. File paths and constant names follow Zeitwerk naming rules

To enable one, list its directory name under plugins in config.yaml

```yaml
default:
  plugins:
    - sample
    - sample_filter
```

## Custom Plugin

```ruby
class Sample
  extend Simpress::Plugin

  def self.priority
    1
  end

  def self.run(entries)
    case Simpress::Config.mode
    when "html"
      bind_context(sample: entries.select(&:index).take(5))
    when "json"
      Simpress::Writer.write("sample.json", Simpress::JSON.dump(entries.select(&:index).take(5), keys: [:id, :title, :permalink]))
    end
  end
end
```

| Method | Description |
| ------ | ----------- |
| run(entries) | Required. Called after parsing and before output generation |
| priority | Higher runs first. Defaults to 1. Equal values run in registration order |
| bind_context(hash) | Passes values to templates. Templates read them as instance variables (@sample) |

- entries is an array of Entry, newest first, including `index: false`

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

| Method | Description |
| ------ | ----------- |
| preprocess(markdown) | Called before conversion to HTML |
| postprocess(html) | Called after conversion to HTML |

- Both are optional. A side left unimplemented changes nothing
- A return value that is not a String is ignored
- Multiple filters apply in registration order

## Custom Theme Helper

```ruby
module Simpress
  module Plugin
    module ThemeHelper
      include Simpress::Theme::Helper

      def format_date(date)
        date.strftime("%Y/%m/%d")
      end
    end
  end
end
```

- Write it in plugins/theme_helper/lib/simpress/plugin/theme_helper.rb and add theme_helper to plugins in config.yaml
- With `include Simpress::Theme::Helper`, templates can call it like `format_date(date)`
- Existing helpers such as `uri` and `encode_json` are callable inside the module

## Directory

| Directory | Description |
| --------- | ----------- |
| lib | Plugin body |
| scss | _*.scss files are added to scss/_plugins.scss at build time |
| static | Copied to the output at build time, like the root static directory |
| tasks | Loaded as subcommands of ./simpress |

- Only enabled plugins are included
