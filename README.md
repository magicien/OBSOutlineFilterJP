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
（後でファイルの位置を移動すると読み込めなくなるので、その場合は再度 `+`ボタンで追加し直してください）

<img width="749" alt="screenshot-2" src="https://user-images.githubusercontent.com/1047810/107636330-d09da100-6caf-11eb-9f9c-bf44fd5c3bfb.png">

=> 画像やウィンドウキャプチャ等のフィルタに「縁取り」という項目が追加される

### 使い方

1. 画像、ウィンドウキャプチャ等のフィルタ設定を開く

2. 左下の `+` ボタンから「縁取り」を選択

<img width="802" alt="screenshot-3" src="https://user-images.githubusercontent.com/1047810/107636627-4144bd80-6cb0-11eb-848e-a3c5b61f05c7.png">

3. 各種パラメータを設定

※「クロマキー」を使用する場合、「縁取り」は「クロマキー」より下に置いてください
※造りが粗いので、線を太くしすぎると見栄えが悪くなりますが、仕様です。輪郭線を太くしたい場合は、縁取りフィルタを複数重ねると良いかもしれません。

### アンインストール方法

1. OBSを起動後、`ツール` > `スクリプト` メニューを開く

2. `draw-outline.lua` を選択した状態で左下の `-` ボタンを押す

3. `draw-outline.lua`ファイルはゴミ箱へ

### サンプル

https://user-images.githubusercontent.com/1047810/107636801-849f2c00-6cb0-11eb-9923-7706647fd1b9.mp4

### 利用条件

- 利用の際、クレジット表記は不要です
- 複製、改変、再配布、商用利用はいずれも可です
- 作者はこのソフトウェアの使用によって生じる損害について責任を負いません
