### Custom Markdown Enhancer

```ruby
class SampleFilter
  extend Simpress::Parser::Markdown::Enhancer

  def self.preprocess(markdown)
    # TODO
  end
end
```

into plugins directory ruby project structures(plugins/sample_filter/lib/sample_filter.rb)

Like a Custom Plugin, it must also be listed under plugins in config.yaml to be enabled.


### Custom Plugin

```ruby
module Simpress
  module Plugin
    class Sample
      extend Simpress::Plugin

      def self.run(posts)
        # TODO
      end
    end
  end
end
```
