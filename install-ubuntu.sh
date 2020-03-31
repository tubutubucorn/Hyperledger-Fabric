#!/bin/bash

# Ubuntu 18.04

# パッケージインデックスの更新
apt update && apt upgrade -y

# 前提ソフトウェアのインストール
apt install -y apt-transport-https ca-certificates curl software-properties-common python

# GPG 公開鍵のインストール
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
# aptリポジトリの設定
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# docker-ceのインストール
apt update && apt install -y docker-ce
# 一般ユーザでの実行
sermod -aG docker $(whoami)

# Docker-composeインストール
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# バイナリに対して実行権限付与
chmod +x /usr/local/bin/docker-compose
# Docker起動
service docker start

# Nodebrewインストール
curl -L git.io/nodebrew | perl - setup
# PATH通す
export PATH=$HOME/.nodebrew/current/bin:$PATH >> ~/.bash_profile
# 使用するNode.js(npm)のバージョン指定
nodebrew install-binary v8.9.4 && nodebrew use v8.9.4

# Goインストール
apt install golang -y
# PATH通す
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# サンプルプログラムのインストール
curl -sSL http://bit.ly/2ysbOFE | bash -s
cd fabric-samples/fabcar
# ブロックチェーンネットワークの起動
./startFabric.sh javascript

# Chaincodeの実行
cd javascript
# ライブラリのインストール
npm install
# gRPCバイナリをインストール
npm rebuild
# ユーザー作成&登録
node enrollAdmin.js
node registerUser.js
# 台帳（StateDB）のデータを参照
node query.js
# 台帳（StateDB）のデータを更新
node invoke.js
