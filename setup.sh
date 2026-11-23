#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

copy_desktop_config() (
    local source=$1 target=$2 temporary_dir
    if [[ -e "$target" || -L "$target" ]]; then
        printf '保留已有配置 %s\n' "$target"
        return
    fi

    temporary_dir="$(mktemp -d -- "$(dirname "$target")/.dotcfg.XXXXXXXX")"
    trap 'rm -rf -- "$temporary_dir"' EXIT
    cp -R -- "$source" "$temporary_dir/config"
    mv --update=none --no-target-directory -- "$temporary_dir/config" "$target"
)

setup_desktop() {
    local config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
    local state_home=${XDG_STATE_HOME:-"$HOME/.local/state"}
    local dependency source

    for dependency in alacritty niri niri-session dms xdg-terminal-exec; do
        if ! command -v "$dependency" >/dev/null; then
            printf '缺少 %s，请按 README.md 安装依赖。\n' "$dependency" >&2
            return 1
        fi
    done

    # 旧版安装脚本可能把整个 ~/.config 链接到 Fish 包。
    if [[ "$config_home" -ef "$SCRIPT_DIR/fish/.config" ]]; then
        stow --no-folding -R -t "$HOME" fish
        if [[ "$config_home" -ef "$SCRIPT_DIR/fish/.config" ]]; then
            printf '请将 XDG_CONFIG_HOME 指向仓库外的配置目录。\n' >&2
            return 1
        fi
    fi

    mkdir -p -- "$config_home" "$state_home/dms"
    for source in desktop/config/*; do
        copy_desktop_config "$source" "$config_home/${source##*/}"
    done
    copy_desktop_config desktop/dms-session.json "$state_home/dms/session.json"

    niri validate --config "$config_home/niri/config.kdl"
    dms systemd enable --compositor niri
}

if [[ $# -eq 1 && $1 == --desktop ]]; then
    setup_desktop
    exit
fi

if [[ $# -ne 0 ]]; then
    printf '用法：%s [--desktop]\n' "$0" >&2
    exit 2
fi

mkdir -p -- "$HOME/.config"
for dir in */; do
    [[ $dir == desktop/ ]] && continue
    stow -R -t "$HOME" "$dir"  # Restow 到 $HOME，避免受当前工作目录影响
done
