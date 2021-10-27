# Manaba+Rの課題を抽出してくれるやつ

## 注意
このプログラムは、サイトをスクレイピングしているので責任はご自分で！！

## 導入(herokuの場合）
1. Herokuにこのプログラムをアップデート
2. 環境変数を追加
  - MANABA_ID: ログインID
  - MANABA_PASSWORD: パスワード
3. Buildpacksを追加
  - https://github.com/heroku/heroku-buildpack-chromedriver.git
  - https://github.com/heroku/heroku-buildpack-google-chrome.git
> バージョンはおそらく↓
> google-chrome 93.0.4577.82
> chromedriver 93.0.4577.63
4. 完成！
