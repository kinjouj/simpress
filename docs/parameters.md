# Parameters

A list of the constant parameters defined throughout the codebase that tune runtime behavior.

## Parser `lib/simpress/parser.rb`

| Constant | Description |
| -------- | ----------- |
| DEFAULT_COVER | Default cover image path when none is specified and none could be auto-extracted from the body |

## Markdown Renderer `lib/simpress/parser/markdown/renderer.rb`

| Constant | Description |
| -------- | ----------- |
| RENDERER_OPTIONS | Default options passed to Redcarpet::Render::HTML |

## Markdown Processor `lib/simpress/parser/markdown/processor.rb`

| Constant | Description |
| -------- | ----------- |
| REDCARPET_OPTIONS | Parse options passed to Redcarpet::Markdown |

## Markdown Parser `lib/simpress/parser/markdown.rb`

| Constant | Description |
| -------- | ----------- |
| PERMITTED_CLASSES | Classes allowed when loading the front matter YAML |

## Paginator `lib/simpress/paginator.rb`

| Constant | Description |
| -------- | ----------- |
| DEFAULT_PREFIX | Default prefix for paginated URLs |

## Taxonomy `lib/simpress/taxonomy.rb`

| Constant | Description |
| -------- | ----------- |
| DEFAULT_TAXONOMIES | Default taxonomy types used when not specified in config |
