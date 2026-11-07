# theme_helper

テンプレートで使うヘルパーを追加するためのプラグイン

## 概要

`Simpress::Theme::Helper`を拡張したい場合は、lib/theme_helper.rbの`ThemeHelper`にメソッドを定義する。定義したメソッドはテンプレートから直接呼べる

## 使い方

config.yamlのpluginsにtheme_helperを追加する。

```yaml
plugins:
  - theme_helper
```

lib/theme_helper.rbにメソッドを定義する。

```ruby
module ThemeHelper
  include Simpress::Theme::Helper

  def format_date(date)
    date.strftime("%Y/%m/%d")
  end
end
```

テンプレートでは次のように呼ぶ。

```erb
<%= format_date(entry.date) %>
```

## 補足

- 定義したメソッドの中から、uriやencode_jsonなどの既存のヘルパーも呼べる
