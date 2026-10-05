#!/bin/bash
# ============================================================
#  jolycqt373 品牌化定制脚本
#  执行位置：openwrt 源码根目录（工作流已 cd 进来）
#  作用：改默认 IP / 主机名（=界面 logo 文字）/ 时区 / 主题
# ============================================================

echo ">>> [jolycqt373] 开始定制"

GEN="package/base-files/files/bin/config_generate"

if [ -f "$GEN" ]; then
    # 1) 默认 LAN 地址（想换就直接改左边的 IP）
    sed -i "s/192\.168\.1\.1/192.168.1.1/g" "$GEN"

    # 2) 默认主机名 —— LuCI(argon) 顶部显示的就是它，即你要的 jolycqt373
    sed -i "s/'OpenWrt'/'jolycqt373'/" "$GEN" 2>/dev/null || true

    # 3) 默认时区
    sed -i "s/timezone='UTC'/timezone='CST-8'/" "$GEN" 2>/dev/null || true

    echo ">>> [jolycqt373] 已处理 config_generate"
else
    echo ">>> [jolycqt373] 未找到 config_generate，跳过"
fi

# 4) 把默认主题换成 argon（改界面观感，不影响 logo 文字）
if [ -f feeds/luci/collections/luci/Makefile ]; then
    sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" feeds/luci/collections/luci/Makefile 2>/dev/null || true
    echo ">>> [jolycqt373] 默认主题 -> argon"
fi

# 5) 需要额外插件时，在这里追加，例如：
# git clone --depth=1 https://github.com/<作者>/luci-app-xxx package/luci-app-xxx

echo ">>> [jolycqt373] 定制结束"
