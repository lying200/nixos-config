# NixOS Configuration

Echoyn 的模块化 NixOS 配置，基于 Flake 构建。

## 主机

| 主机 | 说明 | Home 配置 |
|------|------|-----------|
| `legion` | 主力台式机（NVIDIA，GNOME + niri） | `home/desktop` |
| `legion-wsl` | legion 上的 WSL | `home/wsl` |
| `wsl` | 另一台机器上的 WSL | `home/wsl` |

## 目录结构

```
flake.nix                # 入口：用户信息（单一数据源）、mkHost、主机注册
hosts/
├── legion/              # 台式机：default.nix（模块导入+开关）、configuration.nix、hardware.nix
├── wsl-common.nix       # 两台 WSL 的全部公共配置（hostName 由 flake 参数注入）
├── wsl/                 # 仅一行 import ../wsl-common.nix
└── legion-wsl/          # 同上
modules/                 # 系统级模块
├── core/                # 必装无开关：locale、fonts、base-packages、nix、compatibility
├── hardware/            # amd/intel/nvidia-gpu、bluetooth、power-management（mySystem.hardware.*）
├── desktop/             # gnome、niri、wayland、monitoring（mySystem.desktop.*）
├── services/            # tailscale、podman、k3s、mihomo 等（mySystem.services.*）
└── programs/            # fcitx5、steam、dev-tools、nix-ld 等
home/                    # Home Manager 用户级配置
├── common/              # 所有主机共享：终端（fish/starship/zellij）、git、ssh、neovim、direnv
├── desktop/             # 图形主机：GUI 应用、GNOME 设置、niri/dms/noctalia、主题
└── wsl/                 # WSL 专属：wsl-copy 剪贴板等
update.sh                # 更新 flake 依赖 + rebuild
```

## 日常使用

Fish 别名（定义在 `home/common/terminal/fish.nix`）：

| 别名 | 作用 |
|------|------|
| `rebuild` | `sudo nixos-rebuild switch --flake ~/nixos-config#<hostname>` |
| `rebuild-check` | 仅构建不切换（无需 sudo） |
| `update` | 运行 `./update.sh`（更新 flake 依赖并 rebuild） |
| `clean` | GC + store 优化 |
| `nixcfg` | 进入配置目录 |

手动操作：

```bash
sudo nixos-rebuild switch --flake .          # 按当前 hostname 自动选配置
sudo nixos-rebuild switch --rollback         # 回滚上一代
```

## 添加新主机

1. `mkdir hosts/<name>`，参考 `hosts/legion/` 写 `default.nix`（导入需要的模块 + `mySystem` 开关）和 `configuration.nix`；物理机需 `sudo nixos-generate-config --show-hardware-config > hosts/<name>/hardware.nix`
2. `flake.nix` 注册：`<name> = mkHost "<name>" {};`（WSL 主机加 `{ homeModule = ./home/wsl; }`，并仿照 `hosts/wsl/default.nix` 复用 `wsl-common.nix`）
3. `sudo nixos-rebuild switch --flake .#<name>`

主机名必须与 `networking.hostName` 一致（WSL 主机由 `wsl-common.nix` 自动设置）。

## 模块约定

- 可选功能模块声明 `mySystem.<域>.<名>.enable` 开关，由主机的 `default.nix` 导入并启用；`modules/core/` 为必装模块，无开关
- 模块间依赖用 `assertions` 显式声明（参见 `monitoring.nix`、`fcitx5.nix`）
- 个人信息（username / git 用户名邮箱）只在 `flake.nix` 定义，经 `specialArgs` 注入
- GPU 模块互斥，一台主机只导入实际使用的那个（legion 用 nvidia；amd/intel 模块保留备用，标注未实测）

## AI CLI

Claude Code、Codex 和 Kimi Code 使用官方安装器，避免 nixpkgs 或自维护包的版本延迟：

```bash
curl -fsSL https://claude.ai/install.sh | bash
curl -fsSL https://chatgpt.com/codex/install.sh | sh
curl -fsSL https://code.kimi.com/kimi-code/install.sh | env KIMI_NO_MODIFY_PATH=1 bash
```

Claude Code 和 Codex 安装到 `~/.local/bin`，Kimi Code 安装到 `~/.kimi-code/bin`；两个目录均由 Home Manager 加入 `PATH`。Claude Code 会自动更新（也可运行 `claude update`），Codex 重新运行上述脚本即可更新，Kimi Code 使用 `kimi upgrade`。

## 已知注意点

- `home/desktop/wayland/default.nix` 的 `myHome.desktop.wayland.shell` 可切换 `dms` / `noctalia` / `none`（默认 dms），niri 键位、启动项、窗口规则会随之配对切换
- mihomo / k3s 的用户侧配置文件（`~/.config/mihomo/config.yaml`、`~/.kube/config`）仅在首次部署时生成，之后不会被覆盖，订阅等敏感信息不入库
