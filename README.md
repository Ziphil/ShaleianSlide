<div align="center">
<h1>シャレイア語文法解説スライド生成</h1>
</div>


## 概要
シャレイア語の文法解説動画で使用する予定のスライドを生成します。

## 閲覧
GitHub Actions を用いて自動的に GitHub Pages として公開するようにしているので、以下のリンクからスライドをいつでも閲覧することができます。

- [デザインチェック](https://ziphil.github.io/ShaleianSlidePage/slide/0.html)
- [第 2 課: 動詞と助詞句](https://ziphil.github.io/ShaleianSlidePage/slide/2.html)

ページを開くと、画面全体に 1 枚のスライドが表示されます。
キーボードの左右キーで表示するスライドを切り替えることができます。

## 下準備

### Ruby の準備
生成スクリプトは [Ruby](https://www.ruby-lang.org/ja/) で書かれているため、まず最新の Ruby をインストールしてください。
バージョン 2.5 以上であれば動くはずです。
また、`ruby` や `gem` が呼び出せるように適切にパスを設定しておいてください。

### 依存 gem のインストール
依存している gem を管理するために [Bundler](https://bundler.io/) を用いています。
以下のコマンドを実行し、Bundler をインストールしてください。
```
gem install bundler
```

さらに、依存している gem をインストールするため、ディレクトリトップで以下のコマンドを実行してください。
```
bundle install
```

## 生成
以下のコマンドを実行すると、原稿ファイルから HTML ファイルを生成します。
```
bundle exec ruby converter/main.rb
```
この後に以下のコマンドを実行すると、先程生成した HTML ファイルから画像ファイルを生成します。
```
bundle exec ruby converter/main.rb -i
```

画像の生成には Selenium の Chrome ドライバを使用します。
実行の前に、Chrome 本体に加え、専用のドライバを[こちら](http://chromedriver.storage.googleapis.com/index.html)からダウンロードし、パスを通しておいてください。