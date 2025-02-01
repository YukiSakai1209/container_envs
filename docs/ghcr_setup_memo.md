# GHCR Setup Work Memo

## 1. 必要な変更
### 1.1 GitHub Actions Workflow
`.github/workflows/docker-publish.yml` を作成:
```yaml
name: Docker Image CI

on:
  push:
    branches: [ main ]
    paths:
      - '.devcontainer/**'
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - uses: actions/checkout@v4
      
      - name: Log in to GHCR
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: ./.devcontainer
          file: ./.devcontainer/Dockerfile
          push: true
          tags: |
            ghcr.io/yukisakai1209/research-env:latest
            ghcr.io/yukisakai1209/research-env:${{ github.sha }}
```

### 1.2 docker-compose.yml の更新
```yaml
services:
  workspace:
    image: ghcr.io/yukisakai1209/research-env:latest
    build:
      context: .
      dockerfile: Dockerfile
```

## 2. READMEの更新内容
- GHCRの説明と利点
- 環境の更新方法
- 各計算機サーバーでの利用方法
- バージョン管理の方法
- トラブルシューティング

## 3. 実装手順
1. GitHub Actionsワークフローの作成
2. docker-compose.ymlの更新
3. READMEの更新
4. 初回ビルドとプッシュのテスト
5. 各計算機サーバーでのプル・テスト

## 4. 注意点
- GitHub Tokenの設定が必要
- イメージのバージョン管理の方針決定
- 各計算機サーバーでの認証設定
- ストレージ使用量の監視
