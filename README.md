## 概要

このリポジトリは、AIアシスタントに対する指示やルールをプロジェクト間で簡単に再利用できるようにするためのテンプレートです。

主な特徴：
- 共通ルール（ずんだもん口調、メモリバンク、Git操作など）
- フロントエンド開発ルール
- バックエンド開発ルール
- DevOpsルール
- シェルスクリプトによるルール変換

## 使い方

### 新規プロジェクトでの使用方法

1. このリポジトリの「Use this template」ボタンをクリック
2. 新しいリポジトリ名を入力して作成
3. クローンして使用開始

### ルールの適用方法

リポジトリをクローンした後、以下のコマンドでルールを適用します：

```bash
# ルール変換スクリプトに実行権限を付与
chmod +x scripts/rules-manager.sh

# ルール変換スクリプトを実行
./scripts/rules-manager.sh
```

これにより、`rules/` ディレクトリのルールが `.cursor/rules/` と `.clinerules/` に変換されます。

## カスタマイズ

プロジェクトに合わせてルールをカスタマイズするには、`scripts/rules-manager.sh`を編集してください。新しいカテゴリの追加や既存のカテゴリの設定変更が可能です。