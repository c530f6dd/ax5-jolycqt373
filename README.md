# 红米AX5 OpenWrt Argon主题版 云编译包

## 修改内容
1. **界面主题**：替换为KWRT同款 `luci-theme-argon` 主题，带可视化设置面板，可自定义壁纸/配色/透明度，和KWRT界面完全一致
2. **主机名**：修改为标准 `OpenWrt`，后台顶部、SSH登录都显示OpenWrt标识
3. **NSS硬件加速**：完整保留，跑满千兆带宽无压力，不修改加速配置
4. **默认配置**：管理IP 192.168.1.1，root密码 password，中文语言，上海时区

## 编译方式（2分钟操作完自动编译）
1. 删除你GitHub仓库里之前的所有旧文件
2. 将本压缩包解压后的所有文件（包含隐藏的.github文件夹）全部上传到仓库根目录
3. 进入Settings → Actions → General，勾选「Read and write permissions」保存
4. 进入Actions页面，点击工作流，点Run workflow触发编译
5. 等待约1-2小时，编译完成后在Artifacts下载固件包

## 刷机注意
- `*sysupgrade.bin`：在已有OpenWrt/U-Boot后台升级使用
- `*factory.ubi`：首次刷入/救砖使用
- 网页上传卡在100%时，改用SSH命令行 `sysupgrade -n /tmp/固件名.bin` 刷入，绕过网页超时
