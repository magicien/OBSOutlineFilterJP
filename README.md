# OBSOutlineFilterJP
OBS用スクリプト：縁取りフィルタ（簡易版、日本語）

透明な部分と不透明な部分の境目に線を描くフィルタ。

透過PNGやクロマキー適用後の画像・動画等に縁取りを付けたい場合に。

Mac、Windows、Linuxの各環境で動作する、はず。

<img width="873" alt="screenshot-1" src="https://user-images.githubusercontent.com/1047810/107635822-26be1480-6caf-11eb-9692-7175e57fffe0.png">

### インストール方法

1. [draw-outline.lua](https://raw.githubusercontent.com/magicien/OBSOutlineFilterJP/main/draw-outline.lua) （テキストファイル）をダウンロード

2. OBSを起動後、`ツール` > `スクリプト` メニューを開く

3. 左下の `+` ボタンを押し、ダウンロードした `draw-outline.lua` を選択する

<img width="749" alt="screenshot-2" src="https://user-images.githubusercontent.com/1047810/107636330-d09da100-6caf-11eb-9f9c-bf44fd5c3bfb.png">

=> 画像やウィンドウキャプチャ等のフィルタに「縁取り」という項目が追加される

### 使い方

1. 画像、ウィンドウキャプチャ等のフィルタ設定を開く

2. 左下の `+` ボタンから「縁取り」を選択

<img width="802" alt="screenshot-3" src="https://user-images.githubusercontent.com/1047810/107636627-4144bd80-6cb0-11eb-848e-a3c5b61f05c7.png">

3. 各種パラメータを設定

### アンインストール方法

1. OBSを起動後、`ツール` > `スクリプト` メニューを開く

2. `draw-outline.lua` を選択した状態で左下の `-` ボタンを押す

### サンプル

https://user-images.githubusercontent.com/1047810/107636801-849f2c00-6cb0-11eb-9923-7706647fd1b9.mp4
