Macでの設定(一番上はgemでエラーが起きた場合のみ実行(MacPortsなので注意))
$ sudo port install rb-rubygems
$ sudo gem install twitter
$ sudo gem install oauth


#########
# 使い方 #
#########
最初に:
 twitter_lib.rb中の
 $CONSUMER_KEY = "YOU_CONSUMER_KEY"
 $CONSUMER_SECRET = "YOU_CONSUMER_SECRET"
 を各自適切な物に置換してください


起動:
$ ruby mojitter.rb

URLにブラウザでアクセスし、PINコードをコピペでターミナルに入力

下記が表示されれば認証成功
{自分のアカウント名} : mojitter$

##コマンド一覧
#TLの取得(デフォルト:最新の20件)
{自分のアカウント名} : mojitter$ tls
#-lオプションで取得件数を設定可能(最大200件)
{自分のアカウント名} : mojitter$ tls -l 10
#-@オプションでメンションの取得(最大200件)
{自分のアカウント名} : mojitter$ tls -@ 10

#つぶやく
{自分のアカウント名} : mojitter$ tup つぶやき


#ログアウト
{自分のアカウント名} : mojitter$ logout
twitter logout ok? y:n > y
再度PINが求められる

#終了
{自分のアカウント名} : mojitter$ exit


####################
# bash用設定(自分用)
####################

${mojitter.rbまでのfile path}の例: ~/mojitter/mojitter.rb

loginのみ
$ ruby ${mojitter.rbまでのfile path} -login

logoutのみ
$ ruby ${mojitter.rbまでのfile path} -logout

TLから最新ツイートを1行のみ取得
$ ruby ${mojitter.rbまでのfile path} -bash

Macなどで、.bash_profileに以下を追加すると、bashの$以前に最新ツイートを表示することが出来ます(現状コマンドたたくごとにネットワーク通信する)
export PS1="\u:\W \$(ruby ${mojitter.rbまでのfile path} -bash)$ "


#########
#  Todo #
#########
特定ユーザーの最新つぶやきを取得する機能 -> ストーカー機能 -> 住所がわかる場合は、最新日時と場所を表示する機能
つぶやきでの個人特定支援機能
