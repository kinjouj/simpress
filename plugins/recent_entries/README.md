# Plugin: RecentEntries

Plugin that gets the latest entries. When enabled, data is available depending on `mode`

- html: template instance variable @recent_entries (Array[Simpress::Entry])
- json: recent_entries.json (array of id, title, permalink)

Entries with `index: false` are excluded

## Parameters

Parameters for the entries to get, defined in lib/simpress/plugin/recent_entries.rb

| Constant | Value | Description |
| -------- | ----- | ----------- |
| LIMIT | 5 | Maximum number of entries to get |
