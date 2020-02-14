<div align="center">
<h1>文法解説スライド生成スクリプト</h1>
</div>


## 概要
シャレイア語の文法解説動画で使う予定のスライド画像を生成します。

## 使い方
以下を実行すると良いと思います。
```
bundle exec ruby converter/main.rb
```

画像の生成に Selenium を使用します。
あらかじめ、Chrome 用のドライバをインストールしてパスを通しておいてください。
ドライバは[ここ](http://chromedriver.storage.googleapis.com/index.html)からダウンロードできます。