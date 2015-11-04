# 開発環境補足
開発に使っている環境の構築のためのメモです。

## ソフトウェア
* Ubuntu 15.10 (AMD64) 
 * これを Windows 環境にインストールした VMware Player にいれて開発
 * gedit でもよいけど、試しにNotepadqq をエディタとして使用。これについては後述
* クロスコンパイラ
 * arm-none-eabi-gcc  4.9.3 
* シリアル通信のためのターミナルソフト
 * Ubuntu では minicom を使用
 * Windows では TeraTerm を使用

## ハードウェア
* Raspberry Pi 2
 * 本体です。これのみ考慮して開発テスト中です
* microSD に書き込むためのカードリーダーライタ
 * VM で普段作業していますが、 kernel.img を書き込むだけなので Windows が認識すれば OK
 * もちろん VM へ直接バイパスして使用するのもありだと思います。
* microSD カード
 * Trancend 16GB SDHC のものを使用
* USB-シリアル変換ケーブル
 * Raspberry Pi 2 からシリアル出力したときの結果確認として使用.
 * USB to TTL シリアルケーブルというものを購入＆使用
  * PL2303HX チップの使用だったので Windows8.x 以降でドライバの問題有り。
  
## ソフト導入手順
 
### クロスコンパイル環境の準備

以下のコマンドを実行してインストール。

> $ sudo apt-get install gcc-arm-none-eabi

これで 15.10 の環境では arm-none-eabi-gcc 4.9.3 がインストールされました。


### Notepadqq インストール手順
検索すればすぐに見つかると思いますが、念のためここにも記載します。

以下のコマンドを実行してインストールしました。インストール後には、関連付けしたいファイルのプロパティから既定のアプリ変更。

> $ sudo add-apt-repository ppa:notepadqq-team/notepadqq
> $ sudo apt-get update
> $ sudo apt-get install notepadqq

## minicom

> $ sudo apt-get install minicom

ドライバの都合もあって USBtoTTLシリアルケーブルは Uubuntu 側に接続して使用することに.
こちらだと Windows 8.x 以降のドライバ問題を避けられると思う(未確認)

## gtkterm

GUIというか別窓が開くターミナルソフト。割と使いやすそうな気がする。
個人的には minicom よりはこちらかもと思ってます。

## screen

コンソール(ターミナル)で操作をやるならこちらのほうが作業が捗るかも。

# フォルダについて

ナンバリングついている順序で進化する予定。

* 01_bare_led
 * 初めてのベアメタル。手探りで ACT LED の点滅
* 01_bare_led_withld
 * リンカスクリプト付きにしてみたもの。boot.S とかアリにしたもの. 

## 実行手順
基本的には各ディレクトリで make コマンドを実行すると、 kernel.img が作られるようにしています。
これを Raspberry Pi 仕様に準拠した microSD カードにコピーして、実機 Raspberry Pi に挿入すれば動くようにしています。
ここで Raspberry Pi 仕様とは FAT でフォーマットされた microSD カードで、 直下に start.elf, bootcode.bin らが配置されたものをさします。 
確実にやるならば raspbian などの標準的なものをインストールした SD カード上から kernel.* のファイルを削除、config.txt を削除した状態から始めればよいと思います。

