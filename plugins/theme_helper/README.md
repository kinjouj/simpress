# theme_helper

Plugin for adding helpers used in templates

## Overview

To extend `Simpress::Theme::Helper`, define methods in `Simpress::Plugin::ThemeHelper` in lib/simpress/plugin/theme_helper.rb. Defined methods can be called directly from templates

## Usage

Add theme_helper to plugins in config.yaml

```yaml
plugins:
  - theme_helper
```

Define methods in lib/simpress/plugin/theme_helper.rb

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

Call it in a template like this

```erb
<%= format_date(entry.date) %>
```

## Notes

- Existing helpers such as uri and encode_json can be called from defined methods
