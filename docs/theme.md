## Theme Variables

### index.erb

| variable   | Description   |
| ---------- | ------------- |
| @entries   | Array[Simpress::Entry] |
| @paginator | Simpress::Paginator |
| @key       | String optional |

### page.erb

| variable | Description  |
| -------- | -------------|
| @entry   | Simpress::Entry |

See [entry.md](./entry.md) for the properties available on `Simpress::Entry`.

## Helpers

Available in all templates.

| method | Description |
| ------ | ----------- |
| encode_json(data) | Returns data as a JSON string that is safe to embed in HTML (escaped for XSS) |
| absolute_url(path) | Returns the absolute URL of path, which is host in config.yaml followed by path as is. Use uri(path) to get the .html URL of an entry |
| uri(path) | Returns path with the extension replaced by .html |
| flatten_toc(toc) | Flattens Entry toc into an array of Hash with id, text and depth (0 for headings, 1 for their children) |
| render_partial(template, data) | Renders another template with data bound as instance variables |
