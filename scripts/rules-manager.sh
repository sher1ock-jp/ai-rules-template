#!/bin/bash

# AIルールテンプレート変換スクリプト
# TypeScriptバージョンのシェルスクリプト実装

# 現在のディレクトリを保存
CURRENT_DIR=$(pwd)
# スクリプトのディレクトリに移動
cd "$(dirname "$0")"
SCRIPT_DIR=$(pwd)
cd ..
ROOT_DIR=$(pwd)
cd "$SCRIPT_DIR"

echo "Starting rules management process..."

# カテゴリの設定（連想配列を使わない方法）
CATEGORIES="general frontend backend"

# .cursor/rulesディレクトリをクリーンアップ
CURSOR_RULES_DIR="$ROOT_DIR/.cursor/rules"
if [ -d "$CURSOR_RULES_DIR" ]; then
  rm -rf "$CURSOR_RULES_DIR"
fi
mkdir -p "$CURSOR_RULES_DIR"

# 数字プレフィックスでソートする関数
sort_by_number_prefix() {
  local dir=$1
  find "$dir" -name "*.md" | sort -t_ -k1,1n
}

# フロントマターを生成する関数
generate_frontmatter() {
  local category=$1
  local description=""
  local globs=""
  local always_apply=""
  
  case "$category" in
    "general")
      description="AIアシスタントのメモリ管理とプロジェクト理解のための基本ルール（全てのファイルに対して必ず適用）"
      globs="**/*"
      always_apply="true"
      ;;
    "frontend")
      description="フロントエンド開発のルールとベストプラクティス（Next.js, React, TypeScriptプロジェクト向け）"
      globs="frontend/**/*, *.tsx, *.ts, *.jsx, *.js"
      always_apply="false"
      ;;
    "backend")
      description="バックエンド開発のルールとベストプラクティス（Python, FastAPI, uvicornプロジェクト向け）"
      globs="backend/**/*, *.py"
      always_apply="false"
      ;;
  esac
  
  echo "---"
  echo "description: $description"
  echo "globs: $globs"
  echo "alwaysApply: $always_apply"
  echo "---"
  echo ""
}

# ディレクトリをクリーンアップする関数
cleanup_directory() {
  local dir=$1
  if [ -d "$dir" ]; then
    rm -rf "$dir"
  fi
}

# ルールファイルを処理する関数
process_rule_files() {
  local category=$1
  local source_dir=""
  local cursor_output="$ROOT_DIR/.cursor/rules"
  local clinerule_output=""
  local category_name=""
  
  case "$category" in
    "general")
      source_dir="$ROOT_DIR/rules/common"
      clinerule_output="$ROOT_DIR/.clinerules/common"
      category_name="common"
      ;;
    "frontend")
      source_dir="$ROOT_DIR/rules/frontend"
      clinerule_output="$ROOT_DIR/.clinerules/frontend"
      category_name="frontend"
      ;;
    "backend")
      source_dir="$ROOT_DIR/rules/backend"
      clinerule_output="$ROOT_DIR/.clinerules/backend"
      category_name="backend"
      ;;
  esac
  
  echo "Processing $category rules..."
  
  # ソースディレクトリの存在確認
  if [ ! -d "$source_dir" ]; then
    echo "Skipping $category: source directory not found at $source_dir"
    return
  fi
  
  # .clinerules配下のディレクトリをクリーンアップ
  cleanup_directory "$clinerule_output"
  
  # 出力ディレクトリの作成
  mkdir -p "$cursor_output"
  mkdir -p "$clinerule_output"
  
  # フロントマターの生成
  local frontmatter=$(generate_frontmatter "$category")
  
  # ソースファイルの取得とソート
  for file in $(sort_by_number_prefix "$source_dir"); do
    local filename=$(basename "$file")
    local cursor_path="$cursor_output/${category_name}_${filename%.md}.mdc"
    local clinerules_path="$clinerule_output/${filename%.md}.mdc"
    
    # ファイルの内容を読み込み
    local content=$(cat "$file")
    
    # フロントマター付きのコンテンツを生成
    local content_with_frontmatter="$frontmatter$content"
    
    # ファイルを書き込み
    echo "$content_with_frontmatter" > "$cursor_path"
    echo "$content_with_frontmatter" > "$clinerules_path"
    
    echo "Processed: $filename"
    echo "  → $cursor_path"
    echo "  → $clinerules_path"
  done
  
  echo -e "\nCompleted $category rules processing\n"
}

# 各カテゴリの処理
for category in $CATEGORIES; do
  process_rule_files "$category"
done

echo "Rules management completed successfully!"

# 元のディレクトリに戻る
cd "$CURRENT_DIR"
