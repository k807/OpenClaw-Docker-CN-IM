#!/bin/bash

set -e

echo "=== 初始化 Skills ==="

OPENCLAW_HOME="/home/node/.openclaw"
OPENCLAW_WORKSPACE="${WORKSPACE:-/home/node/.openclaw/workspace}"
NODE_UID="$(id -u node)"
NODE_GID="$(id -g node)"

# 拷贝默认skills
cp -r "/home/node/skills/" "$OPENCLAW_WORKSPACE/skills"

# 遍历skills目录，输出装载的skill名称
echo "=== 装载的 Skills 列表 ==="
if [ -d "$OPENCLAW_WORKSPACE/skills" ]; then
    skill_count=0
    for skill_dir in "$OPENCLAW_WORKSPACE/skills"/*; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")
            echo "📦 装载 Skill: $skill_name"
            skill_count=$((skill_count + 1))
        fi
    done
    
    if [ $skill_count -eq 0 ]; then
        echo "⚠️  未找到任何 Skills"
    else
        echo "✅ 总共装载了 $skill_count 个 Skills"
    fi
else
    echo "❌ Skills 目录不存在: $OPENCLAW_WORKSPACE/skills"
fi

echo "=== Skills 初始化完成 ==="