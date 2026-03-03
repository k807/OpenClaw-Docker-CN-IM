#!/bin/bash

# macOS Docker 环境自动安装脚本
# 包含 Colima、Docker、Docker Compose 的安装和配置
# 作者: 九七
# 日期: 2026-03-03

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查是否为 macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "此脚本仅支持 macOS 系统"
        exit 1
    fi
    log_info "检测到 macOS 系统"
}

# 检查并安装 Homebrew
install_homebrew() {
    if command -v brew >/dev/null 2>&1; then
        log_success "Homebrew 已安装"
        # 更新 Homebrew
        log_info "更新 Homebrew..."
        brew update
    else
        log_info "安装 Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # 添加 Homebrew 到 PATH (适用于 Apple Silicon Mac)
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        
        log_success "Homebrew 安装完成"
    fi
}

# 检查并安装 Colima
install_colima() {
    if command -v colima >/dev/null 2>&1; then
        log_success "Colima 已安装 (版本: $(colima version))"
    else
        log_info "安装 Colima..."
        brew install colima
        log_success "Colima 安装完成"
    fi
}

# 检查并安装 Docker
install_docker() {
    if command -v docker >/dev/null 2>&1; then
        log_success "Docker 已安装 (版本: $(docker --version))"
    else
        log_info "安装 Docker..."
        brew install docker
        log_success "Docker 安装完成"
    fi
}

# 检查并安装 Docker Compose
install_docker_compose() {
    if command -v docker-compose >/dev/null 2>&1; then
        log_success "Docker Compose 已安装 (版本: $(docker-compose --version))"
    else
        log_info "安装 Docker Compose..."
        brew install docker-compose
        log_success "Docker Compose 安装完成"
    fi
}

# 配置 Docker 镜像源
configure_docker_registry() {
    log_info "配置 Docker 镜像源..."
    
    # 创建 Docker 配置目录
    mkdir -p ~/.docker
    
    # 创建 daemon.json 配置文件
    cat > ~/.docker/daemon.json << EOF
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com",
    "https://ccr.ccs.tencentyun.com"
  ],
  "insecure-registries": [],
  "debug": false,
  "experimental": false,
  "features": {
    "buildkit": true
  }
}
EOF
    
    log_success "Docker 镜像源配置完成"
}

# 启动 Colima
start_colima() {
    log_info "检查 Colima 状态..."
    
    if colima status >/dev/null 2>&1; then
        log_success "Colima 已在运行"
    else
        log_info "启动 Colima..."
        # 使用推荐配置启动 Colima
        colima start --cpu 4 --memory 8 --disk 100
        log_success "Colima 启动完成"
    fi
}

# 验证安装
verify_installation() {
    log_info "验证安装..."
    
    # 检查 Docker 是否可用
    if docker info >/dev/null 2>&1; then
        log_success "Docker 运行正常"
    else
        log_error "Docker 无法正常运行"
        return 1
    fi
    
    # 检查 Docker Compose 是否可用
    if docker-compose version >/dev/null 2>&1; then
        log_success "Docker Compose 运行正常"
    else
        log_error "Docker Compose 无法正常运行"
        return 1
    fi
    
    # 测试拉取镜像
    log_info "测试镜像拉取..."
    if docker pull hello-world >/dev/null 2>&1; then
        log_success "镜像拉取测试成功"
        docker rmi hello-world >/dev/null 2>&1
    else
        log_warning "镜像拉取测试失败，可能是网络问题"
    fi
}

# 显示使用说明
show_usage() {
    echo ""
    log_info "安装完成！使用说明："
    echo "  • 启动 Docker 环境: colima start"
    echo "  • 停止 Docker 环境: colima stop"
    echo "  • 查看 Colima 状态: colima status"
    echo "  • 重启 Colima: colima restart"
    echo "  • 查看 Docker 信息: docker info"
    echo "  • 运行 Docker Compose: docker-compose up"
    echo ""
    log_info "配置文件位置："
    echo "  • Docker 配置: ~/.docker/daemon.json"
    echo "  • Colima 配置: ~/.colima/"
    echo ""
}

# 主函数
main() {
    echo "======================================"
    echo "    macOS Docker 环境自动安装脚本"
    echo "======================================"
    echo ""
    
    # 检查系统
    check_macos
    
    # 安装组件
    install_homebrew
    install_colima
    install_docker
    install_docker_compose
    
    # 配置镜像源
    configure_docker_registry
    
    # 启动服务
    start_colima
    
    # 验证安装
    if verify_installation; then
        log_success "所有组件安装并验证成功！"
        show_usage
    else
        log_error "安装验证失败，请检查错误信息"
        exit 1
    fi
}

# 执行主函数
main "$@"
