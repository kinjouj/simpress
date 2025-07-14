## Simpress


a simple static blog generator


### Installation


```bash
git clone https://github.com/kinjouj/simpress.git blog
cd blog
git submodule update --init
bundle install
rake build
```


### Configuration


```yaml
default:
  debug: false
  logging: false
  mode: "html"
  host: "https://example.com"
  paginate: 10
  source_dir: "source"
  plugin_dir: "plugins"
  output_dir: "public"
  theme_dir: "themes"
  cache_dir: ".cache"
  preprocessors:
    - hostname
    - categories_content
    - html_loader
    - recent_posts
```


### Theme(index.erb) Variables


* @posts: Array
* @paginator: Simpress::Paginator::Index instance
* @key: String optional


### Theme(post.erb) Variables


* @post: Simpress::Model::Post instance
* @paginagtor: Simpress::Paginator::Post instance


### Theme(page.erb) Variables


Same Theme(post.erb)... but @paginator is nothing


### Custom Markdown Filter


```ruby
module A
  extend Simpress::Parser::Redcarpet::Filter

  def self.preprocess(markdown)
    # TODO
  end
end
```


into plugins directory ruby project structures(plugins/sample_filter/lib/sample_filter.rb)


### Custom Preprocessor


```ruby
module Simpress
 module Plugin
  module Preprocessor
    class Sample
      extend Simpress::Plugin::Preprocessor

      def self.run(posts, pages, categories)
        # TODO
      end
    end
  end
end
```
