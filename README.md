# 红米 AX5 · jolycqt373 云编译包

把本包上传到**你自己的** GitHub 仓库，点一下就能云端编译出「界面标识为 jolycqt373」的红米 AX5 OpenWrt 固件，全程不需要本地电脑。

> 本包已按「**标准版红米 AX5（设备名 `redmi_ax5`）**」配好，无需改动。

---

## 零、不想编译？有现成固件可直接刷（最快方案）

如果你的目的只是「把 AX5 刷成能用的 OpenWrt」，可以跳过编译，直接下载 KWRT（openwrt.ai）已发布的现成固件。以下是 **2026-10-01** 构建、已核实可下载的文件（在 `https://dl.openwrt.ai/releases/targets/qualcommax/ipq60xx/` 目录下）：

| 用途 | 文件名 | 大小 |
| --- | --- | --- |
| 首次刷入 / U-Boot 恢复（factory） | `kwrt-10.01.2026-qualcommax-ipq60xx-redmi_ax5-squashfs-factory.ubi` | 50.4 MB |
| 网页后台升级（sysupgrade） | `kwrt-10.01.2026-qualcommax-ipq60xx-redmi_ax5-squashfs-sysupgrade.bin` | 48.5 MB |
| 过渡固件（initramfs 底包） | `kwrt-qualcommax-ipq60xx-redmi_ax5-initramfs-uImage.itb` | 23.8 MB |

> 注意：这是 **KWRT 官方构建**，界面标识显示的是 KWRT 而非 jolycqt373。想要 jolycqt373 标识，仍走本包编译。

---

## 一、先回答你最关心的问题：我能不能直接操作你的 GitHub 账号

**不能替你登录。** 账号密码这类凭据我不会收取、不会保存，这是硬性边界；而且 GitHub 登录带图形验证码/两步验证，只能你本人在实时工作区里完成。

能给你的价值是：**把编译这件事从「你要会写配置」变成「你只要会点按钮」**——也就是本包。你要做的只有：注册/登录 GitHub → 上传本包 → 点 Run。

---

## 二、本包已核实的关键信息（写错就会编译失败或刷成砖）

| 项目 | 值 |
| --- | --- |
| 上游源码 | `https://github.com/LiBwrt/LibWrt.git` |
| 分支 | `25.12-nss` |
| 目标平台 | `qualcommax` / 子目标 `ipq60xx` |
| 架构 | `aarch64_cortex-a53`（**64 位**） |
| 标准版 AX5 设备名 | `redmi_ax5`（NAND，UbiFit） |
| 京东云版 AX5 设备名 | `redmi_ax5-jdcloud`（eMMC） |

> 踩坑点：不同上游源码给红米 AX5 起的**设备名不一样**。比如 Lean's LEDE（coolsnowwolf/lede）里叫 `xiaomi_rm1800` / `redmi_ax5-jdcloud`；而 ImmortalWrt 当前主线 `qualcommax/ipq60xx` 里**已经没有 AX5**了。所以`.config` 里的设备行必须和你选的源码严格配套，本包已经配好，不要乱改。

`.config` 里设备行的正确写法（已在 `configs/redmi_ax5.config` 中）：

```
CONFIG_TARGET_qualcommax=y
CONFIG_TARGET_qualcommax_ipq60xx=y
CONFIG_TARGET_MULTI_PROFILE=y
CONFIG_TARGET_DEVICE_qualcommax_ipq60xx_DEVICE_redmi_ax5=y
CONFIG_TARGET_DEVICE_PACKAGES_qualcommax_ipq60xx_DEVICE_redmi_ax5="ipq-wifi-redmi_ax5"
```

---

## 三、目录结构

```
红米AX5_jolycqt373云编译包/
├── .github/workflows/build-redmi-ax5.yml   # 云编译工作流
├── configs/redmi_ax5.config                # 设备 + 功能配置
├── diy-script.sh                           # 品牌化定制脚本
├── files/etc/banner                        # SSH 登录 banner（jolycqt373）
├── files/etc/uci-defaults/99-jolycqt373    # 首次启动设置主机名= jolycqt373
└── README.md                               # 本说明
```

**「界面 logo 显示 jolycqt373」是怎么实现的**：你看到的那个位置，是 LuCI(argon 主题) 顶部读取**系统主机名**显示的文字。本包把主机名固定为 `jolycqt373`（脚本 + 首次启动设置双保险），因此编译出来的固件界面顶部就会显示 `jolycqt373`。

---

## 四、操作步骤（照做即可）

1. **注册/登录 GitHub**（已有账号直接登录）。
2. **新建仓库**：右上角 `+` → `New repository` → 名称随意（如 `ax5-jolycqt373`）→ 选 **Public** → 创建。
   - 说明：Public 仓库的 Actions 免费额度宽松；Private 也可，但会消耗每月赠送的分钟数。
3. **上传本包**：把本包**解压后**的所有文件（含隐藏的 `.github` 目录）上传到仓库根目录。
   - 网页上传：`Add file` → `Upload files`，把解压出的文件夹内容拖进去，注意保持目录结构。
   - 或命令行：
     ```bash
     cd 你的解压目录
     git init
     git add -A
     git commit -m "jolycqt373 build"
     git branch -M main
     git remote add origin https://github.com/你的用户名/ax5-jolycqt373.git
     git push -u origin main
     ```
4. **开启 Actions**：进入仓库 `Settings` → `Actions` → `General` → 选 `Allow all actions`，保存。
5. **开始编译**：仓库顶部 `Actions` → 左侧选 `Build Redmi AX5 (jolycqt373)` → 右侧 `Run workflow` → 绿色按钮。
6. **等待**：通常 1–3 小时（首次要拉源码+工具链，较久）。
7. **下载固件**：编译任务变绿后，点进去，页面底部 `Artifacts` 里下载 `redmi-ax5-jolycqt373`，里面是 `openwrt-qualcommax-ipq60xx-redmi_ax5-squashfs-*.bin`。

---

## 五、刷机与避坑

- **刷前务必备份关键分区**（SSH 里执行）：
  ```bash
  dd if=/dev/mtdblock0 of=/tmp/mibib_backup.bin
  ```
  把 `/tmp/mibib_backup.bin` 拷回电脑留底。
- **刷写顺序**：先刷过渡包（底包）→ 再在 LuCI 后台上传本固件的 `sysupgrade` 包。
- **网页上传卡在 100% 不动**：改走 SSH 命令写入，绕开网页超时：
  ```bash
  sysupgrade -n /tmp/固件文件名.bin
  ```
- **装插件认准架构**：本固件为 **64 位**，装包前在系统里跑 `uname -m`，应为 `aarch64`；选 ipk 要选 `arm64/aarch64` 版本，别混入 `armv7` 的 32 位包。
- **内存只有 256M**：插件别堆太多，否则容易 OOM 掉线。想精简，就在 `configs/redmi_ax5.config` 里把第 4 节那些 `luci-app-*` 删掉。

---

## 六、想改的地方

| 想改什么 | 改哪里 |
| --- | --- |
| 京东云版 AX5 | `configs/redmi_ax5.config` 里换成 `redmi_ax5-jdcloud` 两行 |
| 界面标识文字 | `files/etc/uci-defaults/99-jolycqt373` 里的 `hostname` |
| 默认登录 IP | `diy-script.sh` 里第 1 条 sed 的右侧 IP |
| 增删插件 | `configs/redmi_ax5.config` 第 4 节 |

---

## 七、免责声明

本包只是把社区公开源码 + 标准编译流程整理成「可一键复现」的配置，固件功能与稳定性取决于上游 `LiBwrt/LibWrt` 源码本身。刷机有变砖风险，请务必备份分区后再操作。
