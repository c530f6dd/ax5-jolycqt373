#!/bin/bash
# 定制脚本：主机名 OpenWrt、时区上海、默认 Argon 主题，并为红米AX5增加 squashfs-nand-factory.bin
set -e

CG="package/base-files/files/bin/config_generate"

# 1) 主机名统一改为 OpenWrt（源码默认是 LibWrt）
sed -i "s/hostname='[^']*'/hostname='OpenWrt'/g" "$CG"
# 2) 时区固定为上海（幂等，源码默认已是 CST-8，这里做双保险）
sed -i "s/timezone='[^']*'/timezone='CST-8'/g" "$CG"
sed -i "s|zonename='[^']*'|zonename='Asia/Shanghai'|g" "$CG"

echo "=== config_generate 校验 ==="
grep -n "hostname=\|timezone=\|zonename=" "$CG" | head

# 3) 为 redmi_ax5 增加 nand-factory.bin 镜像规则
#    关键：必须插在设备定义块内部（endef 之前），否则规则不生效
IPQ60XX_MK="target/linux/qualcommax/image/ipq60xx.mk"
if [ ! -f "$IPQ60XX_MK" ]; then
  echo "错误：未找到 $IPQ60XX_MK"
  exit 1
fi

awk '
/^define Device\/redmi_ax5$/ { in_dev=1 }
in_dev && /^endef$/ {
    print "\tIMAGES += nand-factory.bin"
    print "\tIMAGE/nand-factory.bin := append-ubi | qsdk-ipq-factory-nand"
    in_dev=0
}
{ print }
' "$IPQ60XX_MK" > "$IPQ60XX_MK.tmp" && mv "$IPQ60XX_MK.tmp" "$IPQ60XX_MK"

echo "=== ipq60xx.mk 插桩结果 ==="
sed -n '/define Device\/redmi_ax5$/,/TARGET_DEVICES += redmi_ax5/p' "$IPQ60XX_MK"

grep -q "IMAGE/nand-factory.bin := append-ubi | qsdk-ipq-factory-nand" "$IPQ60XX_MK" || {
  echo "错误：nand-factory 规则插入失败"
  exit 1
}

echo "diy-script 执行完成"
