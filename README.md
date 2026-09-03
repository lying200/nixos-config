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
flake.nix                # 入口：用户信息、desktop profile、host registry、checks
lib/mk-hosts.nix         # 主机构造：hostname、Home Manager、profile 配对
hosts/
├── legion/              # 台式机：硬件、启动和主机功能选择
└── wsl-common.nix       # 两台 WSL 共用的系统配置
modules/                 # 系统级模块
├── default.nix          # module catalog：所有主机只导入这一处
├── core/                # locale、fonts、基础包、Nix、nh、nix-index
├── hardware/            # GPU adapter、bluetooth、power-management
├── desktop/             # gnome、niri、wayland、monitoring（mySystem.desktop.*）
├── services/            # tailscale、podman、k3s、mihomo 等（mySystem.services.*）
└── programs/            # fcitx5、steam、dev-tools、nix-ld 等
home/                    # Home Manager 用户级配置
├── common/              # 终端、git、ssh、neovim、direnv、nix-index timer
├── desktop/             # 图形主机：GUI 应用、GNOME 设置、niri/dms/noctalia、主题
└── wsl/                 # WSL 专属：wsl-copy 剪贴板等
tests/flake-checks.nix   # host invariants、格式、deadnix、statix、ShellCheck
update.sh                # 安全更新、检查、构建、generation diff、确认切换
```

## 日常使用

Fish 别名（定义在 `home/common/terminal/fish.nix`）：

| 别名 | 作用 |
|------|------|
| `rebuild` | 使用 `nh` 构建、显示 diff 并切换当前主机 |
| `rebuild-check` | 使用 `nh` 构建但不切换 |
| `update` | 更新 inputs，运行 checks，构建并确认后切换 |
| `clean` | 使用 `nh` 保留最近 5 代并优化 store |
| `nixcfg` | 进入配置目录 |

手动操作：

```bash
nh os switch . -H "$(hostname)"
./update.sh                 # 交互确认
./update.sh --yes           # CI/无人值守终端中跳过确认
./update.sh --host legion   # 显式选择目标主机
```

`update.sh` 会在 build/check 失败或取消切换时恢复原来的 `flake.lock`。
Fish 会设置 `NIXOS_CONFIG_DIR`；脚本也接受 `NIXOS_CONFIG_DIR` 和 `NIXOS_HOST` 作为自动化 adapter，以覆盖仓库路径和默认 hostname。

## 检查

```bash
nix flake check --no-build  # 快速求值全部 host 与 checks
nix flake check             # 执行格式、deadnix、statix、ShellCheck
nix fmt                     # 使用 Alejandra 格式化 Nix 文件
```

同一组 checks 由 `.github/workflows/check.yml` 在 push 和 pull request 中执行，host 列表直接从 registry 派生。

## 添加新主机

1. 物理机参考 `hosts/legion/` 添加主机目录；WSL 直接复用 `hosts/wsl-common.nix`
2. 在 `flake.nix` 的 `hosts` registry 声明 system、host module、Home profile，以及可选的 desktop profile
3. 运行 `nix flake check --no-build`，host invariants 会验证 registry 名与 `networking.hostName`
4. `nh os switch . -H <name>`

`networking.hostName` 由主机构造 module 从 registry 的名称生成，不在 host 文件重复声明。

## 模块约定

- 所有系统 module 只在 `modules/default.nix` 注册；host 只选择 `mySystem` 能力，不再同时维护 import 与 enable
- 模块间依赖用 `assertions` 显式声明（参见 `monitoring.nix`、`fcitx5.nix`）
- 个人信息（username / git 用户名邮箱）只在 `flake.nix` 定义，经 `specialArgs` 注入
- GPU 通过 `mySystem.hardware.gpu = "none" | "amd" | "intel" | "nvidia"` 单选，adapter 位于 `modules/hardware/gpu/`
- desktop profile 同时驱动 NixOS 的 GNOME/niri/Wayland 选择和 Home Manager 的 shell 配置

## AI CLI

Claude Code、Codex 和 Kimi Code 使用官方安装器，避免 nixpkgs 或自维护包的版本延迟：

```bash
curl -fsSL https://claude.ai/install.sh | bash
curl -fsSL https://chatgpt.com/codex/install.sh | sh
curl -fsSL https://code.kimi.com/kimi-code/install.sh | env KIMI_NO_MODIFY_PATH=1 bash
```

Claude Code 和 Codex 安装到 `~/.local/bin`，Kimi Code 安装到 `~/.kimi-code/bin`；两个目录均由 Home Manager 加入 `PATH`。Claude Code 会自动更新（也可运行 `claude update`），Codex 重新运行上述脚本即可更新，Kimi Code 使用 `kimi upgrade`。

## 已知注意点

- `flake.nix` 的 desktop profile 可切换 `dms` / `noctalia` / `none`，niri 键位、启动项和窗口规则会随之配对切换
- 启用 Flatpak 后会幂等添加 Flathub remote，不再需要首次手工执行 `flatpak remote-add`
- `comma` 使用每周更新的本地 nix-index 数据库，可通过 `, <command>` 临时运行未安装工具
- mihomo / k3s 的用户侧配置文件（`~/.config/mihomo/config.yaml`、`~/.kube/config`）仅在首次部署时生成，之后不会被覆盖，订阅等敏感信息不入库
