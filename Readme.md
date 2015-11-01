# 開発環境補足
開発に使っている環境の構築のためのメモです。

* Ubuntu 15.10 (AMD64) 
 * これを Windows 環境にインストールした VMware Player にいれて開発
 * gedit でもよいけど、試しにNotepadqq をエディタとして使用。これについては後述
* microSD に書き込むためのカードリーダーライタ
 * VM で普段作業していますが、 kernel.img を書き込むだけなので Windows が認識すれば OK
 * もちろん VM へ直接バイパスして使用するのもありだと思います。
 
* クロスコンパイラ
 * arm-none-eabi-gcc  4.9.3 
 
## クロスコンパイル環境の準備

以下のコマンドを実行してインストール。

> $ sudo apt-get install gcc-arm-none-eabi

これで 15.10 の環境では arm-none-eabi-gcc 4.9.3 がインストールされました。


## Notepadqq インストール手順
検索すればすぐに見つかると思いますが、念のためここにも記載します。

以下のコマンドを実行してインストールしました。インストール後には、関連付けしたいファイルのプロパティから既定のアプリ変更。

> $ sudo add-apt-repository ppa:notepadqq-team/notepadqq
> $ sudo apt-get update
> $ sudo apt-get install notepadqq

# フォルダについて

ナンバリングついている順序で進化する予定。

* 01_bare_led
 * 初めてのベアメタル。手探りで ACT LED の点滅
* 01_bare_led_withld
 * リンカスクリプト付きにしてみたもの。boot.S とかアリにしたもの. 


