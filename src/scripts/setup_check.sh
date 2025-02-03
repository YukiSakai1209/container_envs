#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔍 環境セットアップチェックを開始します..."

# Function to check and fix permissions
check_permissions() {
    local path=$1
    local expected_perms=$2
    local current_perms=$(stat -c "%a" "$path" 2>/dev/null)
    
    if [ "$current_perms" != "$expected_perms" ]; then
        echo -e "${YELLOW}⚠️  $path の権限を $expected_perms に修正します${NC}"
        chmod "$expected_perms" "$path"
    else
        echo -e "${GREEN}✅ $path の権限は正しいです${NC}"
    fi
}

# Function to check if directory exists and create if not
check_directory() {
    local dir=$1
    if [ ! -d "$dir" ]; then
        echo -e "${YELLOW}⚠️  $dir を作成します${NC}"
        mkdir -p "$dir"
    else
        echo -e "${GREEN}✅ $dir は存在します${NC}"
    fi
}

# Check system requirements
echo "📋 システム要件の確認"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Dockerがインストールされていません${NC}"
    exit 1
fi

if ! command -v sshfs &> /dev/null; then
    echo -e "${RED}❌ SSHFSがインストールされていません${NC}"
    exit 1
fi

# Check Docker group membership
if ! groups | grep -q docker; then
    echo -e "${RED}❌ ユーザーがdockerグループに属していません${NC}"
    echo "次のコマンドを実行してください："
    echo "sudo usermod -aG docker $USER"
    exit 1
fi

# Check SSH directory and key permissions
echo "🔐 SSH設定の確認"
check_permissions ~/.ssh 700
if [ -f ~/.ssh/id_rsa ]; then
    check_permissions ~/.ssh/id_rsa 600
fi

# Check configuration files
echo "📁 設定ファイルの確認"
for file in .devcontainer/devcontainer.json .devcontainer/Dockerfile base/environment.yml; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $file は存在します${NC}"
    else
        echo -e "${RED}❌ $file が見つかりません${NC}"
        exit 1
    fi
done

# Check if container needs rebuild
echo "🐳 Dockerコンテナの状態確認"
if docker ps -a | grep -q vsc-container_envs; then
    echo -e "${YELLOW}⚠️  既存のコンテナが見つかりました${NC}"
    read -p "コンテナを再構築しますか？ (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🔄 コンテナを削除して再構築します..."
        docker ps -a | grep vsc-container_envs | awk '{print $1}' | xargs -r docker rm -f
        docker images | grep vsc-container_envs | awk '{print $3}' | xargs -r docker rmi -f
    fi
fi

echo -e "\n${GREEN}✅ セットアップチェックが完了しました${NC}"
echo "Windsurfで開発環境を開き直してください"
