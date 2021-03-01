# ShaderTests

シェーダ、エディタ拡張などの練習したものをここに雑多に置きます<br>
This repository contains Unity project files that is developped for my practice and pastime, especially about shader and its custom editor.

![Videotogif (2)](https://user-images.githubusercontent.com/64464106/104188109-16224080-545c-11eb-805a-085460f294a0.gif)

## 環境設定/Environment Setting

Unity 2018.4.20f1<br>
Visual Studio 2019<br>

## Scenes>SampleScene

作ったシェーダ類をメッシュに適応したシーンです。<br>
Some test shaders are applied to meshes and placed on the scene.

1. テクスチャをホログラフィーっぽくするシェーダ(surf)<br>
    画像をモノトーンにしたのちアルファをかけています
2. 画像の輪郭線を出すシェーダ(surf)<br>
    隣接位置との差分
3. トゥーン調の水面っぽいシェーダ(surf)<br>
    ノイズお絵かき
4. 木目っぽいやつ(surf)<br>
    ノイズお絵かき
5. テクスチャに各種ノイズをかけるシェーダ(vert+frag)<br>
    液晶画面に走るノイズをイメージしています。8種類の効果の組み合わせ可能。
6. 6角形タイリング(surf)<br>
    イメージはcandy rock starの床
7. スクリーンに平行に画像を張るシェーダ(vert+frag)<br>
8. 背景にモザイクをかけるシェーダ(vert+frag)<br>
    適応したメッシュより後ろの背景にモザイクをかけます。モザイクのタイルの大きさを調整できます
9. 草むらシェーダ(vert+hull+domain+geo+frag)<br>
    ある程度葉の形状や色を変えたり、草の葉の量を増減できます。影がちゃんと落ちるようにしたいので後日改良(したい)

## Scenes>ReflectionScene

反射モデル等の比較をしたシーン<br>
This scene is created to compare few reflection models.

![screenshot](https://user-images.githubusercontent.com/64464106/103803699-405ab380-5094-11eb-861d-d0db5fadc71d.png)

* Unityデフォルトのマテリアル
* Gouraud Shading
* Phong Shading
* Phong Reflection
* Blinn Phong Reflection
* Cook Trance Reflection
