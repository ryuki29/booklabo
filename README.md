# 本アプリについて
###### URL： https://www.booklabo.net
ログイン画面の**「テストユーザーでログイン」**ボタンをクリックして頂きますと、１クリックでログイン可能です。

<u> ※ ご覧になられた後は、お手数ですが、必ずログアウトをお願い致します。</u>

### 本アプリの概要
本アプリのコンセプトは「ミニマルにデザインされた読書管理アプリ」です。
私は読書が大好きで、読書メーターやブクログといった既存の読書管理サービスを愛用してきました。
一方で、これらのアプリは、やや機能過多で、デザインが煩雑であると感じていました。
そこで私は、TwitterやInstagramといったデザイン・ユーザビリティに優れたアプリを参考に、本アプリ「booklabo」を作成しました。

## 機能一覧ならびに使用技術
- ### フロントエンド
  - Haml/Sassでのマークアップ
  - Bootstrapを使用し、レスポンシブデザイン化
- ### サーバーサイド
  - 書籍の検索機能 (GoogleBooksAPIを利用)
  - 読んだ本/読んでる本/読みたい本の登録機能 (jQueryのAjaxを利用)
  - 読んだ本のレビュー・評価の投稿(&編集・削除)機能
  - ユーザー登録機能 (gem Deviseを利用)
  - ユーザー画像の登録機能 (ActiveStorageを利用)
  - 他ユーザーのフォロー機能
  - Twitterアカウントでのログイン機能 (gem OmniAuthを利用)
  - Twitterへのレビューの同時投稿 (TwitterAPIを利用)
- ### インフラ
  - CapistranoによるEC2インスタンスへの自動デプロイ
  - DBとして、Amazon RDS(MySQL)を使用
  - Route53で独自ドメインを設定し、ELBをエンドポイントとして常時SSL化
  - Amazon S3に画像ファイルおよびAssetsを保存し、CloudFrontを経由してCDN配信

## 参考画像

#### ユーザー詳細ページ

<img width="600" alt="Booklabo_mypage" src="https://user-images.githubusercontent.com/52557788/65003591-1972ee00-d934-11e9-9e5d-ac0ffbf4fd18.png">

#### 読んだ本の詳細表示

<img width="600" alt="Booklabo_review" src="https://user-images.githubusercontent.com/52557788/65004454-6906e900-d937-11e9-9b4a-05d2733cb364.png">

#### AWSインフラ構成

<img width="400" alt="Booklabo_AWS" src="https://user-images.githubusercontent.com/52557788/65004447-60aeae00-d937-11e9-8ab2-82e86e2176be.png">

<img width="600" alt="Booklabo_ERD" src="https://user-images.githubusercontent.com/52557788/64958396-01668480-d8ca-11e9-9057-675e0a34f835.png">

