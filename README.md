<div align="center">
<h1>シャレイア語文法解説スライド生成</h1>
</div>


## 概要
シャレイア語の文法解説動画で使用するスライド画像を生成します。
GUI 撲滅!!

## 使い方
以下のコマンドを実行すると、原稿ファイルから HTML ファイルを生成します。
```
bundle exec ruby converter/main.rb
```
この後に以下のコマンドを実行すると、先程生成した HTML ファイルから画像ファイルを生成します。
```
bundle exec ruby converter/main.rb -i
```

画像の生成には Selenium の Chrome ドライバを使用します。
実行の前に、ドライバを[こちら](http://chromedriver.storage.googleapis.com/index.html)からダウンロードし、パスを通しておいてください。