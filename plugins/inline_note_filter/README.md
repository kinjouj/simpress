# inline_note_filter

Markdownのプリプロセッサプラグイン。独自のインラインノート記法をHTMLの注釈ブロックに変換

## 概要

`[^]: `で始まる行を`<div class="note">`要素へ変換

## 記法

```
[^]: ノートの内容
```

コロンの後のスペースは複数あっても無視される。行頭に記述する必要があり行の途中に現れる場合は変換されない

## 出力

```html
<div class="note">
  <i class="fa-solid fa-circle-exclamation"></i>
  <span>ノートの内容</span>
</div>
```
