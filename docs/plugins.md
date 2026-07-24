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


### Custom Plugin


```ruby
module Simpress
  module Plugin
    class Sample
      extend Simpress::Plugin

      def self.run(posts, pages, categories)
        # TODO
      end
    end
  end
end
```


### Custom Theme Helper


Add methods that are usable inside `.erb` templates by including `Simpress::Theme::Helper::Plugin`.


```ruby
module Simpress
  module Plugin
    module SampleHelper
      include Simpress::Theme::Helper::Plugin

      def sample_helper(value)
        # TODO
      end
    end
  end
end
```

