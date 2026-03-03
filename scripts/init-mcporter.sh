#!/bin/bash

set -e

echo "=== 初始化 MCP Porter 配置 ==="

OPENCLAW_HOME="/home/node/.openclaw"
OPENCLAW_WORKSPACE="${WORKSPACE:-/home/node/.openclaw/workspace}"
NODE_UID="$(id -u node)"
NODE_GID="$(id -g node)"

# 检查必要的环境变量
if [ -z "$AONE_PRIVATE_TOKEN" ]; then
    echo "❌ 错误: 环境变量 AONE_PRIVATE_TOKEN 未设置"
    exit 1
fi

if [ -z "$OPENCLAW_WORKSPACE" ]; then
    echo "❌ 错误: 环境变量 OPENCLAW_WORKSPACE 未设置"
    exit 1
fi

# 创建配置目录
CONFIG_DIR="$OPENCLAW_WORKSPACE/config"
mkdir -p "$CONFIG_DIR"

# MCP 配置文件路径
MCP_CONFIG_FILE="$CONFIG_DIR/mcporter.json"

echo "📁 配置目录: $CONFIG_DIR"
echo "📄 配置文件: $MCP_CONFIG_FILE"

# 创建 MCP Porter 配置
cat > "$MCP_CONFIG_FILE" <<EOF
{
  "mcpServers": {
    "code": {
      "baseUrl": "https://mcp.alibaba-inc.com/code/mcp",
      "headers": {
        "PRIVATE-TOKEN": "$AONE_PRIVATE_TOKEN"
      }
    },
    "dingtalk": {
      "baseUrl": "https://mcp.alibaba-inc.com/aone-km/mcp",
      "command": "dingtalk",
      "headers": {
        "PRIVATE-TOKEN": "$AONE_PRIVATE_TOKEN"
      }
    }
  },
  "imports": []
}
EOF

# 验证配置文件是否创建成功
if [ -f "$MCP_CONFIG_FILE" ]; then
    echo "✅ MCP Porter 配置文件创建成功"
    echo "🔧 配置内容:"
    cat "$MCP_CONFIG_FILE"
else
    echo "❌ 配置文件创建失败"
    exit 1
fi

echo "=== MCP Porter 初始化完成 ==="

