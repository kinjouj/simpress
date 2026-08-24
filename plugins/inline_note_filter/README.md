# inline_note_filter

Markdownのプリプロセッサプラグイン。独自のインラインノート記法をHTMLの注釈ブロックに変換する。

## 概要


`[^]: `で始まる行を`<div class="note">`要素へ変換するMarkdownエンハンサー


## 記法


```
[^]: ノートの内容
```


コロンの後のスペースは複数あっても無視される。行頭に記述する必要があり、行の途中に現れる場合は変換されない。


## 出力


```html
<div class="note">
  <i class="fa-solid fa-circle-exclamation"></i>
  <span>ノートの内容</span>
</div>
```


## 使用例


### 入力 (Markdown)


```markdown
本文テキスト。

[^]: これは注意書きです。

[^]: 複数行にノートを書くこともできます。

通常のテキストは変換されません。
Text before [^]: 行頭でない場合は変換されません。
```


### 出力 (HTML)


```html
<p>本文テキスト。</p>
<div class="note"><i class="fa-solid fa-circle-exclamation"></i><span>これは注意書きです。</span></div>
<div class="note"><i class="fa-solid fa-circle-exclamation"></i><span>複数行にノートを書くこともできます。</span></div>
<p>通常のテキストは変換されません。
Text before [^]: 行頭でない場合は変換されません。</p>
```
