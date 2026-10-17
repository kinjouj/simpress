# link_card

内部リンクをリンク先エントリのカードに変換するプラグイン

## 概要

`[](/パス)`だけの行をリンク先エントリの情報を持つ`<div class="link-card">`要素へ変換

## 記法

```
[](/target.html)
```

対象は行全体がラベルの空な内部リンクになっている行だけ。それ以外のリンクは変換されない。リンク先のエントリが存在しない場合はカードに置き換えられない

## 出力

```html
<div class="link-card">
  <a href="/target.html">
    <img src="/images/target.webp" alt="" />
    <span>対象タイトル</span>
  </a>
  <span>対象の説明文</span>
</div>
```
