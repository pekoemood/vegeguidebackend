# **VegeGuide** – 忙しいあなたの、毎日の “ちょうどいい健康習慣”

![トップページ](./docs/top.png)

> 忙しい社会人のための野菜選び・レシピ提案・食材管理サービス  
>  
> ### 🔗 [実際のサービスはこちら](https://vegeguide.com/)

## 各リポジトリ一覧

| リポジトリ名 | 内容説明               | リンク                                                |
|--------------|------------------------|-----------------------------------------------------|
| Backend      | APIサーバー（Rails）   | [github.com/pekoemood/vegeguidebackend](https://github.com/pekoemood/vegeguidebackend)     |
| Frontend     | フロントエンド（React） | [github.com/pekoemood/vegeguidefrontend](https://github.com/pekoemood/vegeguidefrontend)   |

## 📌 サービス概要

**VegeGuide**は、忙しい社会人が**スーパーで野菜を選ぶ瞬間**から**冷蔵庫で食材を管理する**まで、野菜を中心とした食生活を一元的にサポートするWebサービスです。

ユーザーは、**旬で安い野菜を選び、AIが提案するレシピで効率的に調理し、食材を無駄にしない**という結果を得られます。料理初心者でも健康的でコスパの良い食生活を継続できるようになります。

## 🛠️ 開発背景

私自身が社会人になった際、自炊を始めようとしたときに感じた課題がきっかけです。

- スーパーで野菜を見ても「何が安いのか」「どう調理すればいいのか」がわからない  
- 野菜を買っても使い切れずに腐らせてしまう  
- 健康的な食事を心がけたいが、レシピを考えるのが面倒  
- 食材の栄養価や保存方法などの基本的な知識が不足  

これらの問題を解決するため、**野菜選び初心者でも迷わず、効率的に健康的な食生活を送れる**サービスを開発しました。

## 🎯 ターゲット層

**メインターゲット**: 独身男性社会人（27歳〜34歳）  
**ペルソナ**: 田中さん（30歳、IT企業勤務、都内一人暮らし）

- 年収500万円程度、残業多め  
- 健康診断の数値が気になり始めた  
- 料理経験は浅く、野菜の選び方がわからない  
- 食費を抑えたいが、コンビニ弁当に頼りがち  
- 時短・簡単な調理法を求めている  

## 📣 ユーザー獲得方法

1. **技術ブログでの発信**: Qiita・Zennで開発ストーリーを発信  
2. **SNSマーケティング**: Twitter・InstagramのグルメハッシュタグでのPR投稿  

## 🧭 サービス利用のイメージ

### 🔁 利用フロー

1. **仕事帰りにアプリを開く** → 今日安い旬の野菜を確認  
2. **スーパーで迷わず買い物** → 価格情報を見ながら効率的に食材選択  
3. **帰宅後すぐに調理開始** → AIが提案するレシピで簡単調理  
4. **余った食材を冷蔵庫に登録** → 次回のレシピ提案で無駄なく消費  

### 🎁 得られる価値

- **時間短縮**: 食材選びからレシピ検索まで一括で完結  
- **節約効果**: 旬の安い野菜を選ぶことで食費削減  
- **健康改善**: 野菜摂取量が増え、栄養バランスが改善  
- **ストレス軽減**: 「今日何を作ろう」という悩みから解放  

### 🥇 サービス差別化のポイント

**競合サービス**:

- **クックパッド**: レシピ特化、価格情報なし  
- **DELISH KITCHEN**: 動画レシピ、食材管理機能なし  
- **Paprika（海外）**: 食材管理あり、日本の価格データなし  

**VegeGuideの差別化**:

1. **価格×栄養×レシピの三位一体**  
2. **AI活用したパーソナライズ提案**  
3. **冷蔵庫管理連携で無駄を防止**  
4. **男性向けUI/UXで直感的な操作性**  

## 🧪 技術スタック

### 🔙 バックエンド

| 技術             | バージョン  | 用途                         |
|------------------|-------------|------------------------------|
| Ruby on Rails    | 7.2.2       | APIサーバー                  |
| PostgreSQL       | -           | メインデータベース           |
| GoodJob          | -           | 非同期処理エンジン           |
| RSpec            | -           | テストフレームワーク         |
| bcrypt           | 3.1.7       | パスワードハッシュ化         |
| JWT              | -           | 認証トークン                 |
| HTTParty         | -           | HTTP通信ライブラリ           |

### 🖥️ フロントエンド

| 技術              | バージョン | 用途                             |
|-------------------|------------|----------------------------------|
| React             | 19.0.0     | UIフレームワーク（最新機能活用）|
| Vite              | 6.2.0      | 高速ビルドツール                 |
| Tailwind CSS      | 4.1.3      | ユーティリティファーストCSS      |
| DaisyUI           | 5.0.12     | UIコンポーネントライブラリ       |
| React Hook Form   | 7.55.0     | フォーム管理                     |
| Zod               | 3.24.3     | スキーマバリデーション           |
| Recharts          | 2.15.3     | データ可視化ライブラリ           |
| React Router      | 7.5.0      | ルーティング                     |
| React Hot Toast   | 2.5.2      | 通知UI                          |
| Lucide React      | 0.507.0    | アイコンライブラリ               |
| Axios             | 1.8.4      | HTTP通信ライブラリ               |
| date-fns          | 4.1.0      | 日付処理ライブラリ               |

### 🔐 認証・セキュリティ

| 技術             | バージョン | 用途                         |
|------------------|------------|------------------------------|
| JWT              | -          | 認証トークン                 |
| bcrypt           | 3.1.7      | パスワードハッシュ化         |
| Google OAuth     | 0.12.2     | Googleログイン               |
| Google Auth      | 1.14       | Google認証ライブラリ         |
| CORS             | -          | クロスオリジンリクエスト制御 |

### 🌐 外部API・サービス

| サービス名           | 用途                          |
|----------------------|-------------------------------|
| Google Gemini API    | AI文章生成・レシピ生成        |
| Cloudinary           | 画像管理・最適化サービス      |
| 青果物市況情報Web API | 野菜価格データ取得           |
| Google API Client    | 0.53.0                       |

### ☁️ インフラ・デプロイ

| 技術/サービス  | 用途                        |
|----------------|-----------------------------|
| Docker         | コンテナ化（開発環境）       |
| Docker Compose | 開発環境オーケストレーション |
| Render         | バックエンドホスティング     |
| Vercel         | フロントエンドホスティング   |

### 🐳 docker-compose.yml（開発用）構成

```yml
services:
  backend:
    container_name: backend
    build:
      context: ./backend
      dockerfile: Dockerfile.dev
    command: bash -c "bundle exec rails db:prepare && rails s"
    volumes:
      - ./backend:/app
      - bundle_data:/usr/local/bundle
      - ./certs:/certs
    ports:
      - 3000:3000
    environment:
      POSTGRES_USER: "user"
      POSTGRES_PASSWORD: "password"
    depends_on:
      - db
    tty: true
    stdin_open: true

  db:
    image: postgres
    environment:
      POSTGRES_USER: "user"
      POSTGRES_PASSWORD: "password"
    ports:
      - 5432:5432
    volumes:
      - postgres_data:/var/lib/postgresql/data

  frontend:
    container_name: frontend
    build: 
      context: ./frontend
      dockerfile: Dockerfile
    tty: true
    stdin_open: true
    volumes:
      - ./frontend:/home/node/app
      - ./certs:/home/node/app/certs
    ports:
      - 5173:5173

volumes:
  bundle_data:
  postgres_data:
  ```

### 🧰 開発ツール・テスト

| ツール          | バージョン | 用途                      |
|----------------|------------|---------------------------|
| RuboCop        | -          | Ruby静的解析・コード整形   |
| Biome          | 1.9.4      | JavaScript静的解析・整形   |
| SimpleCov      | -          | テストカバレッジ測定      |
| RSpec          | -          | Ruby単体テスト            |
| Factory Bot    | -          | テストデータ生成          |
| Shoulda Matchers| -         | RSpec追加マッチャー       |
| Brakeman       | -          | セキュリティ脆弱性検査    |
| Letter Opener  | -          | メール開発確認ツール      |


## 🎬 デモ・スクリーンショット

### 🏷️ メイン画面  
![VegeGuideデモ](https://i.gyazo.com/9643c35959e7f69e4873301c8d95bc41.gif)

### 🤖 AIレシピ生成画面  
![VegeGuideデモ](https://i.gyazo.com/682a6172df402d2c564c9f7a4e0904a4.gif)

### 🧊 冷蔵庫管理画面  
![VegeGuideデモ](https://i.gyazo.com/ebf8abbca21b664510897f7bbad13ddc.gif)

## 🚧 今後の展開

### 🐣 短期目標（3ヶ月）

#### 🛠️ 技術刷新
- **TypeScriptへの移行** - フロントエンドコードの型安全性向上と保守性強化

#### 🛡️ セキュリティ
- **CI/CDパイプライン強化** - 自動テスト、デプロイメント最適化

#### 📱 UI/UX改善・最適化
- **レスポンシブデザインの完全対応** - モバイルファースト設計への移行
- **パフォーマンス最適化** - 画像最適化、遅延読み込み、キャッシュ戦略

#### 🔔 リアルタイム機能強化
- **価格通知機能** - WebSocketまたはServer-Sent Events実装
- **在庫期限アラート** - 冷蔵庫アイテムの賞味期限通知
- **旬の野菜お知らせ** - 季節の変わり目での自動通知

#### 💬 ユーザーエンゲージメント
- **フィードバック機能** - レシピ評価、改善提案収集
- **使用状況分析** - Google Analytics 4, ヒートマップ分析
- **オンボーディング改善** - 新規ユーザー向けチュートリアル

### 🚀 中期目標（6ヶ月）

#### 📲 プラットフォーム拡張
- **PWA対応** - ServiceWorker、オフライン機能、プッシュ通知

#### 🗺️ データ機能強化
- **地域別価格比較** - 地域APIの追加統合

#### 🥗 コンテンツ拡充
- **季節レシピ特集** - 旬の食材を活かした特別コンテンツ
- **料理動画連携** - YouTube API統合、視覚的レシピガイド
- **野菜の栄養素のグラフ化** - Recharts等を活用し栄養価の見える化

### 🏢 長期目標（1年）

#### 🌏 技術・事業拡張
- **AI機能強化** - 音声レシピ読み上げ
- **収益化戦略** - プレミアム機能、アフィリエイト、データ販売



## 🗂️ ER図

![ER図](docs/vegeguide_main.png)

> ※ 本ER図は主要なドメインモデルを示しています。  
>   ActiveStorageやGoodJobのテーブルは含まれていません。