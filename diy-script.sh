#!/bin/bash
# 定制修改：主题、主机名、IP、时区、默认设置 + 添加nand-factory.bin镜像

# 修改默认IP为192.168.1.1
sed -i 's/192.168.1.1/192.168.1.1/g' package/base-files/files/bin/config_generate

# 修改默认主机名为 OpenWrt
sed -i "s/hostname='.*'/hostname='OpenWrt'/g" package/base-files/files/bin/config_generate

# 修改时区为上海
sed -i "s/timezone='UTC'/timezone='CST-8'/g" package/base-files/files/bin/config_generate
sed -i "/timezone='CST-8'/a \\\t\tset system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate

# 设置默认主题为Argon
mkdir -p files/etc/uci-defaults

# === 为红米AX5添加 squashfs-nand-factory.bin 镜像生成 ===
IPQ60XX_MK="target/linux/qualcommax/image/ipq60xx.mk"
if [ -f "$IPQ60XX_MK" ]; then
  echo "正在为 redmi_ax5 添加 nand-factory.bin 镜像生成规则..."
  # 在DEVICE_PACKAGES行之后追加两行：IMAGES和IMAGE规则
  # 使用 awk 精准定位到 redmi_ax5 的 DEVICE_PACKAGES 行后面插入
  awk '
  /^define Device\/redmi_ax5$/ { in_device=1 }
  in_device && /^TARGET_DEVICES \+= redmi_ax5$/ {
    # 插入两行在TARGET_DEVICES之前
    print "\tIMAGES += nand-factory.bin"
    print "\tIMAGE/nand-factory.bin := append-ubi | qsdk-ipq-factory-nand"
    print $0
    in_device=0
    next
  }
  { print }
  ' "$IPQ60XX_MK" > "$IPQ60XX_MK.tmp" && mv "$IPQ60XX_MK.tmp" "$IPQ60XX_MK"
  echo "已成功添加 nand-factory.bin 镜像生成规则"
  grep -A 2 "IMAGES += nand-factory" "$IPQ60XX_MK" || echo "警告: 规则添加可能失败，请检查"
else
  echo "警告: 未找到 $IPQ60XX_MK 文件，跳过nand-factory.bin添加"
fi
