# dotcfg

## 新电脑部署桌面

这套配置来自 Ubuntu 26.04，已用 Alacritty 0.16.1、Niri 26.04 和 DMS 2.1.2 验证配置部署。Ubuntu 26.04 可以从 Dux Labs PPA 安装桌面组件。 [DMS 安装文档](https://duxlabs.dev/docs/dms/installation/)

```bash
sudo add-apt-repository ppa:duxlabs/dux-repo
sudo add-apt-repository ppa:duxlabs/dms
sudo apt update
sudo apt install alacritty niri dms xdg-terminal-exec xdg-desktop-portal-gnome xdg-desktop-portal-gtk
```

克隆仓库后，在首次登录 Niri 前，以自己的账号在仓库根目录运行以下命令。

```bash
./setup.sh --desktop
```

脚本会复制配置到 `$XDG_CONFIG_HOME`（默认 `~/.config`），将浅色模式和 Bloom 壁纸预设写入初始 DMS 状态，并启用 DMS 随 Niri 会话启动。注销后在登录界面选择 **Niri**。从 TTY 启动时使用 `niri-session`。 [DMS 自启文档](https://duxlabs.dev/docs/dms/cli-systemd)

- `Super+Enter` 和 `Super+T` 通过 `xdg-terminal-exec` 启动 Alacritty。字体装齐 **Maple Mono NF**、**DejaVu Sans Mono**、**MiSans VF** 和 **DM Serif Display** 后可复现当前显示效果。
- `Ctrl+Shift+A` 打开 Screenshot+ 区域截图标注。仓库包含当前使用的插件 0.5.3 和 MIT 许可证。OCR 功能可按插件说明安装 `oar-ocr`。 [Screenshot+ 源码](https://github.com/pcmid/dms-screenshot-plus/tree/4b170c828507616cff46183c81dd4cde394444ab)
- Niri 配置保留了当前机器的 `HDMI-A-1` 缩放设置。新机器可在登录后用 `niri msg outputs` 查看接口名，按需调整本机的 `niri/config.kdl`。

已有的同名配置目录和文件会保留，并在安装时列出。需要应用仓库版本时，退出 Niri，将相应的配置目录或文件移到备份位置，再重跑安装。DMS 会在运行时更新本机配置副本。要共享后续调整，可以将所需的配置文件更新到 `desktop/config/` 后提交。

## Shell 和 Git 配置

安装 GNU Stow 后运行 `./setup.sh`，可部署 Fish、Git 和 tmux 配置。
