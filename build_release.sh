#!/bin/bash

# 🚀 Flutter iOS 一键安全混淆打包脚本 - 多能相机专用
# Author: zzz

set -e

# 1️⃣ 自动生成构建标识文件（保证每次产物唯一）
BUILD_TAG=$(date +%Y%m%d_%H%M%S)_$(uuidgen | cut -c1-8)
echo "📦 生成构建标识: $BUILD_TAG"

cat > lib/build_meta.dart <<EOF
/// Auto-generated build info (DO NOT EDIT)
const String buildTag = "$BUILD_TAG";
EOF

# 2️⃣ 清理旧构建
echo "🧹 清理旧构建缓存..."
flutter clean
flutter pub get

# 3️⃣ 创建混淆符号目录
SYMBOL_DIR="./symbols/$BUILD_TAG"
mkdir -p $SYMBOL_DIR

# 4️⃣ 执行混淆构建
echo "🔐 正在混淆并构建 release 版本..."
flutter build ios --release --obfuscate --split-debug-info=$SYMBOL_DIR

# 5️⃣ 输出构建结果路径
IPA_PATH="build/ios/iphoneos"
echo "✅ 构建完成！IPA 文件在: $IPA_PATH"
echo "🧩 混淆符号保存在: $SYMBOL_DIR"

# 6️⃣ 计算二进制签名特征（验证差异）
IPA_FILE=$(find $IPA_PATH -name "*.ipa" | head -n 1)
if [ -f "$IPA_FILE" ]; then
  echo "🔍 生成 SHA256 校验码:"
  shasum -a 256 "$IPA_FILE"
else
  echo "⚠️ 未检测到 .ipa 文件，请在 Xcode Organizer 中导出 IPA。"
fi

echo "🎉 多能相机 - 安全混淆构建已完成！"