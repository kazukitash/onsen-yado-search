# 温泉宿検索

## 使用したライブラリ・フレームワーク

* Sinatra
* sinatra-contrib
* sinatra-reloader
* Slim
* RSpec

## 概要

温泉宿検索は日本の地域ごとの温泉の検索、およびその温泉に入ることのできる宿の閲覧ができるサービスです。じゃらんのAPIを使用しています。

温泉宿検索は以下の4ページで構成されています。検索時には矢印の向きのようにページが遷移することを想定しています。

**トップページ** -> **検索ページ** -> **検索結果一覧ページ** -> **検索結果詳細ページ**

### 1. トップページ（GET "/"）

![トップページ](https://github.com/kazukitash/onsen_yado_search/wiki/images/top.png "トップページ")

温泉宿検索のトップページです。検索ページへのリンクがあります。

### 2. 検索ページ （GET "/onsen"）

![検索ページ](https://github.com/kazukitash/onsen_yado_search/wiki/images/search.png "検索ページ")

検索ページです。日本のエリアと温泉の泉質を選択して温泉の検索ができます。

### 3. 検索結果一覧ページ （GET "/onsen?reg=\*\*\*&onsen_q=\*\*\*&start=\*\*\*"）

![検索結果一覧ページ](https://github.com/kazukitash/onsen_yado_search/wiki/images/index.png "検索結果一覧ページ")

検索結果一覧ページです。該当するエリア・泉質の温泉が10件ずつ表示されます。さらにその温泉に入ることのできる宿がある場合は最大4件まで表示されます。4件以上の宿がある場合は検索結果詳細ページへのリンクが表示され、そちらのページでさらに絞り込み検索ができます。

### 4. 検索結果詳細ページ （GET "/onsen/:o_id"）

![検索結果詳細ページ](https://github.com/kazukitash/onsen_yado_search/wiki/images/show.png "検索結果詳細ページ")

検索結果詳細ページです。該当する温泉idが紐付けられた宿を表示しています。詳細絞り込みにて宿の絞り込み検索ができます（リクエスト例：**GET "/onsen/:o_id?tri_room=1"**）。

## 工夫した点

### じゃらんデータの扱い

サービスで利用するじゃらんデータはすべてJalanモジュール（[onsen_yado_search/helpers/jalan.rb](https://github.com/kazukitash/onsen_yado_search/blob/master/helpers/jalan.rb)）で操作するようにし、保守性を高めました。また、エリアや泉質、絞り込みオプションなど将来的に変わりうる項目についてはXMLから読み込むようにしており、拡張性を高めています。

### ビューの再利用

ページ内の宿の表示やヘッダ、ページリンクなどは複数回利用するためパーシャルに書き出し、再利用できるようにしました。
