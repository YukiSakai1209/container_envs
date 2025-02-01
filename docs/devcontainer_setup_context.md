# DevContainer設定の経緯と対応
最終更新：2025-02-01

## 1. 環境情報
- ホストOS: Linux Ubuntu
- マウント情報：SSHFSによるリモートマウント
- ユーザー情報：
  - UID: 1001
  - GID: 1001
  - グループ所属: docker グループに所属済み

## 2. 主要な問題と解決策

### 2.1 SSHFSマウントの問題
#### 問題
```bash
docker: Error response from daemon: invalid mount config for type "bind": stat /home/yuki1209/vermeer/RL_tasks/DFT_4p/iTTC/simu_imbalance_effects: permission denied.
```

#### 解決策
従来のホスト側でのSSHFSマウントは使用せず、コンテナ内で直接SSHFSマウントを行う方式を採用します。
これにより、ホスト側のマウントポイントに関する権限の問題を回避し、コンテナ内で完結した安定した環境を構築できます。

具体的な設定は、2.5節「DevContainer内でのSSHFSマウント」に記載しています。

### 2.2 DevContainerのユーザー権限問題
#### 問題
ベースイメージ（`mcr.microsoft.com/devcontainers/miniconda:3`）の既存設定との競合：
```bash
groupadd: group 'vscode' already exists
useradd: user 'vscode' already exists
```

#### 解決策
1. 既存ユーザー/グループの修正
```dockerfile
RUN usermod -u 1001 vscode \
    && groupmod -g 1001 vscode \
    && chown -R vscode:vscode /home/vscode
```

### 2.3 Docker Volumeの問題
#### 問題
1. DevContainer起動時に長時間（2時間以上）ハングする
2. Volumeのマウントが適切に行われない

#### 解決策
1. Docker Compose設定の修正
```yaml
# docker-compose.yml
volumes:
  workspace-vol:
    driver: local
    # 以下のような複雑なdriver_optsは避ける
    # driver_opts:
    #   type: none
    #   o: bind
    #   device: ${PWD}
```

2. トラブルシューティング手順
   - DevContainerの起動が2時間以上進まない場合は、以下の手順でクリーンアップを実施
   ```bash
   # 1. Dockerリソースのクリーンアップ
   cd .devcontainer
   docker compose down
   docker system prune -af

   # 2. Windsurfの設定クリア
   rm -rf ~/.config/windsurf/User/globalStorage/windsurf.windsurf-dev-containers
   ```
   - その後、通常の環境構築手順（3.2節）に従って再セットアップを実施

### 2.4 SSH設定とリモートマウント
#### 設定情報
- SSH設定ディレクトリ: `/home/yuki1209/.ssh/`
- 主要ファイル：
  - `id_rsa`: 秘密鍵（パーミッション: 600）
  - `id_rsa.pub`: 公開鍵
  - `known_hosts`: 既知のホスト情報
  - `authorized_keys`: 認証済み公開鍵

#### マウント設定
各リモートサーバーへの接続は同一の秘密鍵（`id_rsa`）を使用：
```bash
# vermeer
sshfs yuki1209@ncd-node01g:/home/vermeer/yuki1209 ~/vermeer
# magritte
sshfs yuki1209@ncd-node02g:/home/magritte/yuki1209 ~/magritte
# chagall
sshfs yuki1209@ncd-node03g:/home/chagall/yuki1209 ~/chagall
# picasso
sshfs yuki1209@ncd-node04g:/home/picasso/yuki1209 ~/picasso
# ncd
sshfs yuki1209@ncd-node05g:/home/ncd/yuki1209 ~/ncd
# xnef-data1
sshfs yuki1209@ncd-node06g:/home/xnef-data1/yuki1209 ~/xnef-data1
# xnef-data2
sshfs yuki1209@ncd-node07g:/home/xnef-data2/yuki1209 ~/xnef-data2
```

### 2.5 DevContainer内でのSSHFSマウント
#### 問題の分析
1. 従来の方法（ホストのマウントポイントをコンテナにバインドマウント）では以下の問題が発生：
   ```bash
   Error response from daemon: invalid mount config for type "bind": stat /home/yuki1209/vermeer/RL_tasks/DFT_4p/iTTC/simu_imbalance_effects: permission denied
   ```
2. 原因：
   - SSHFSマウントとDockerのバインドマウントの相互作用による問題
   - パーミッションの連鎖的な制約

#### 解決策：コンテナ内での直接SSHFSマウント
1. アプローチ
   - ホスト側のSSHFSマウントは使用せず、コンテナ内で直接SSHFSマウントを実行
   - ホストの `~/.ssh` ディレクトリをコンテナにマウントし、SSH認証を共有
   - コンテナ起動時に自動的にSSHFSマウントを実行

2. Dockerfile の修正
```dockerfile
# Install basic dependencies and SSHFS
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git \
    build-essential \
    sshfs \
    openssh-client \
    fuse3 \
    && rm -rf /var/lib/apt/lists/*

# Create the user and necessary directories
RUN usermod -u 1001 vscode \
    && groupmod -g 1001 vscode \
    && chown -R vscode:vscode /home/vscode \
    && mkdir -p /home/vscode/.ssh \
    && mkdir -p /home/vscode/vermeer \
    && chown -R vscode:vscode /home/vscode/.ssh \
    && chown -R vscode:vscode /home/vscode/vermeer

# Add FUSE device access
RUN echo "user_allow_other" >> /etc/fuse.conf
```

3. docker-compose.yml の設定
```yaml
services:
  workspace:
    # ... 基本設定 ...
    volumes:
      - type: bind
        source: ${HOME}/.ssh
        target: /home/vscode/.ssh
    devices:
      - /dev/fuse
    cap_add:
      - SYS_ADMIN
    security_opt:
      - apparmor:unconfined
    command: |
      /bin/sh -c "
      chmod 600 /home/vscode/.ssh/id_rsa &&
      mkdir -p /home/vscode/vermeer &&
      mkdir -p /home/vscode/magritte &&
      mkdir -p /home/vscode/chagall &&
      mkdir -p /home/vscode/picasso &&
      mkdir -p /home/vscode/ncd &&
      mkdir -p /home/vscode/xnef-data1 &&
      mkdir -p /home/vscode/xnef-data2 &&
      sshfs yuki1209@ncd-node01g:/home/vermeer/yuki1209 /home/vscode/vermeer -o reconnect -o ServerAliveInterval=15 -o ServerAliveCountMax=3 &&
      sshfs yuki1209@ncd-node02g:/home/magritte/yuki1209 /home/vscode/magritte -o reconnect -o ServerAliveInterval=15 -o ServerAliveCountMax=3 &&
      sshfs yuki1209@ncd-node03g:/home/chagall/yuki1209 /home/vscode/chagall -o reconnect -o ServerAliveInterval=15 -o ServerAliveCountMax=3 &&
      sshfs yuki1209@ncd-node04g:/home/picasso/yuki1209 /home/vscode/picasso -o reconnect -o ServerAliveInterval=15 -o ServerAliveCountMax=3 &&
      sshfs yuki1209@ncd-node05g:/home/ncd/yuki1209 /home/vscode/ncd -o reconnect -o ServerAliveInterval=15 -o ServerAliveCountMax=3 &&
      sshfs yuki1209@ncd-node06g:/home/xnef-data1/yuki1209 /home/vscode/xnef-data1 -o reconnect -o ServerAliveInterval=15 -o ServerAliveCountMax=3 &&
      sshfs yuki1209@ncd-node07g:/home/xnef-data2/yuki1209 /home/vscode/xnef-data2 -o reconnect -o ServerAliveInterval=15 -o ServerAliveCountMax=3 &&
      sleep infinity"
```

4. 重要な設定ポイント
   - SSHFSとその依存パッケージの完全なインストール
   - FUSEデバイスへのアクセス権限の付与
   - SSH鍵の適切な権限設定（600）
   - 各マウントポイントの事前作成
   - コンテナに必要な権限の付与（SYS_ADMIN, apparmor:unconfined）

### 2.6 Windsurfの設定共有
#### 問題
DevContainer環境ではデフォルトでホストの設定（global rules含む）が共有されない

#### 解決策
1. devcontainer.jsonの設定
```json
{
  "mounts": [
    "source=${localEnv:HOME}/.codeium,target=/home/vscode/.codeium,type=bind,consistency=cached"
  ]
}
```

2. docker-compose.ymlの設定
```yaml
services:
  workspace:
    volumes:
      - type: bind
        source: ${HOME}/.codeium
        target: /home/vscode/.codeium
```

## 3. 環境構築手順

### 3.1 前提条件
1. Dockerがインストールされていること
2. ユーザーがdockerグループに所属していること
3. SSH鍵が適切に設定されていること

### 3.2 環境構築手順
1. プロジェクトのクローンまたは作成
   ```bash
   # 既存プロジェクトの場合
   git clone <repository_url>
   cd <project_directory>
   ```

2. .devcontainerディレクトリの設定
   - `/home/yuki1209/vermeer/container_envs/.devcontainer`から必要なファイルをコピー
   ```bash
   cp -r /home/yuki1209/vermeer/container_envs/.devcontainer <project_directory>/
   ```

3. 環境変数の設定
   - 必要に応じて`.env`ファイルを作成し、環境変数を設定

4. DevContainer環境の起動
   1. Windsurfを起動
   2. プロジェクトフォルダを開く
   3. "Open in Container"を選択

### 3.3 トラブルシューティング
1. 起動に時間がかかる場合のクリーンアップ手順
   ```bash
   # 1. Dockerリソースのクリーンアップ
   cd .devcontainer
   docker compose down
   docker system prune -af

   # 2. Windsurfの設定クリア
   rm -rf ~/.config/windsurf/User/globalStorage/windsurf.windsurf-dev-containers
   ```

2. 環境の確認
   ```bash
   # SSHFSマウントの確認
   mount | grep sshfs

   # ファイルアクセスの確認
   ls -la /home/vscode/vermeer

   # Conda環境の確認
   conda env list
   conda list
   ```

## 4. 補足事項
1. SSHFSマウントの切断と再接続
   - コンテナ再起動時は自動的に再マウントされる
   - 手動での再マウントが必要な場合は、docker-compose.ymlのcommandセクションに記載されているsshfsコマンドを実行

2. パフォーマンスの最適化
   - ServerAliveIntervalとServerAliveCountMaxの設定により、接続の安定性を確保
   - reconnectオプションにより、ネットワーク切断時の自動再接続を実現

3. セキュリティ考慮事項
   - SSH鍵のパーミッションは600を維持
   - コンテナ内での権限は最小限に設定
   - 機密情報は環境変数として管理
