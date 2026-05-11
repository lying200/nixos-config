# NixOS Configuration

Echoyn 的模块化 NixOS 配置，基于 Flake 构建。

> 该文档使用 AI 生成

## ✨ 特性

- 🎯 **完全参数化** - 单一配置源，轻松切换用户/主机
- 🔧 **模块化设计** - 功能独立，可选择性启用
- 👤 **用户/系统分离** - Home Manager 管理用户配置
- 🎮 **灵活可配置** - 所有模块支持 enable 开关
- 🔒 **类型安全** - 使用 NixOS 模块系统

---

## 📁 项目结构

```
nixos-config/
├── flake.nix                    # Flake 入口配置（单一配置源）
├── flake.lock                   # 锁定的依赖版本
├── update.sh                    # 系统更新脚本
│
├── hosts/                       # 🖥️ 主机特定配置
│   └── desktop/                 # 桌面主机
│       ├── default.nix          # 模块导入 + 功能开关
│       ├── hardware.nix         # 硬件配置（nixos-generate-config 生成）
│       └── configuration.nix    # 主机配置（bootloader、用户、网络）
│
├── modules/                     # 📦 系统级可复用模块
│   ├── core/                    # 核心系统配置（必需）
│   │   ├── locale.nix           # 时区、语言设置
│   │   ├── fonts.nix            # 字体配置
│   │   ├── base-packages.nix    # 基础工具包
│   │   └── nix.nix              # Nix 配置（Flakes、GC、SSH）
│   │
│   ├── hardware/                # 硬件支持
│   │   └── amd-gpu.nix          # AMD GPU 驱动
│   │
│   ├── desktop/                 # 桌面环境（可选）
│   │   ├── wayland.nix          # Wayland 支持
│   │   ├── gnome.nix            # GNOME 桌面
│   │   └── monitoring.nix       # 系统监控（Vitals 扩展）
│   │
│   ├── services/                # 系统服务（可选）
│   │   ├── tailscale.nix        # Tailscale VPN
│   │   └── sunshine.nix         # 游戏串流
│   │
│   └── programs/                # 系统级程序配置
│       ├── fcitx5.nix           # Fcitx5 输入法（雾凇拼音）
│       ├── qqmusic.nix          # QQ 音乐
│       ├── dev-tools.nix        # 开发工具
│       ├── autostart.nix        # 开机自启动
│       └── default-shell.nix    # 默认 Shell
│
├── home/shared/                 # 👤 用户级配置（Home Manager）
│   ├── default.nix              # Home Manager 入口
│   ├── programs/
│   │   ├── git.nix              # Git 配置
│   │   ├── applications.nix     # 用户应用（GUI 软件）
│   │   └── keybindings.nix      # 快捷键配置
│   └── terminal/
│       ├── fish.nix             # Fish Shell
│       ├── starship.nix         # Starship 提示符
│       ├── zellij.nix           # Zellij 终端复用器
│       └── ghostty.nix          # Ghostty 终端
│
└── .github/workflows/           # GitHub Actions
    ├── ci.yml                   # PR 构建检查
    └── update-flake.yml         # 自动更新依赖
```

---

## 🚀 新机器快速部署

> 💡 **提示**：第一次使用可以直接复用现有配置，只需修改用户名和主机名即可！

### 方案 A：快速开始

直接使用现有的 `desktop` 配置

#### 步骤 1：启用 Flakes 和 Git

```bash
# 临时启用 Flakes 和 Git
nix-shell -p git --extra-experimental-features "nix-command flakes"
```

#### 步骤 2：克隆配置仓库

```bash
# 克隆到 ~/nixos-config
git clone https://github.com/lying200/nixos-config.git ~/nixos-config
cd ~/nixos-config
```

#### 步骤 3：修改基本信息

```nix
# 编辑 flake.nix
username = "yourname";                  # 👈 系统用户名
gitUserName = "Your Full Name";         # 👈 Git 提交作者名
gitUserEmail = "your@email.com";        # 👈 Git 提交作者邮箱
```

#### 步骤 4：选择或创建主机配置

该配置支持多主机，当前已有 `desktop` 和 `legion` 两个配置。

**方案 A：使用现有配置**
- 直接使用 `desktop` 或 `legion`，跳到步骤 5

**方案 B：创建新主机配置**

如需自定义主机名（如 `my-laptop`）：

```bash
# 1. 复制现有配置
cp -r hosts/desktop hosts/my-laptop

# 2. 编辑 hosts/my-laptop/configuration.nix
# 修改: networking.hostName = "my-laptop";
```

```nix
# 3. 编辑 flake.nix，在 nixosConfigurations 中添加：
nixosConfigurations = {
  desktop = mkHost "desktop";
  legion = mkHost "legion";
  my-laptop = mkHost "my-laptop";  # 👈 添加新主机
};
```

> 💡 配置名和 `networking.hostName` 必须一致

#### 步骤 5：配置显卡

```nix
# 编辑 hosts/<hostname>/default.nix（默认是 hosts/desktop/default.nix）
mySystem.hardware = {
  amdgpu.enable = true;      # 👈 AMD 显卡（默认配置）
  # nvidia.enable = true;    # 👈 NVIDIA 显卡（取消注释并禁用 AMD）
  # intelgpu.enable = true;  # 👈 Intel 核显（取消注释）
};
```

**⚠️ 注意：**
- 默认配置是 **AMD 显卡**
- 如果你使用 **NVIDIA** 或 **Intel** 显卡，**必须修改此配置**，否则系统可能无法正常启动图形界面
- NVIDIA 和 Intel 配置**未经实际测试**，可能需要根据你的硬件微调，建议结合 AI（Claude/ChatGPT）或 [NixOS Wiki](https://nixos.wiki/) 调整

#### 步骤 6：更新硬件配置

```bash
# 生成当前机器的硬件配置（<hostname> 替换为实际主机名，默认 desktop）
sudo nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware.nix
```

#### 步骤 7：构建并应用

```bash
# 初次安装时指定主机名（desktop/legion/my-laptop）
sudo nixos-rebuild switch --flake .#desktop

# 重启
reboot
```

> 💡 **提示**：
> - 首次需要指定 `--flake .#主机名`
> - 后续 NixOS 会记住主机名，直接运行 `sudo nixos-rebuild switch --flake .` 即可
> - 系统配置了 Fish shell 别名：`rebuild`（快速应用）、`update`（更新依赖）、`nixcfg`（进入配置目录）

**完成！** 🎉 你的新机器已经配置好了！

> 💡 **提示**：如果遇到显卡相关问题，可以：
> 1. 检查 `hosts/<hostname>/default.nix` 中的 GPU 配置是否匹配你的硬件
> 2. 使用 `lspci | grep -i vga` 查看你的显卡型号
> 3. 咨询 AI 助手（Claude/ChatGPT）获取针对你硬件的配置建议

---

### 方案 B：创建独立主机配置

如果你想为新机器创建独立的配置目录，可以参考 [添加新主机](#-添加新主机) 部分。

---

### 🔧 功能调整（可选）

部署完成后，可以根据需要开启/关闭功能：

```nix
# 编辑 hosts/desktop/default.nix
mySystem = {
  hardware = {
    amdgpu.enable = true;      # AMD 显卡
    # nvidia.enable = true;    # NVIDIA 显卡（按需切换）
    # intelgpu.enable = true;  # Intel 核显（按需切换）
  };

  desktop = {
    gnome.enable = true;       # 桌面环境
    wayland.enable = true;     # Wayland 支持
    monitoring.enable = true;  # 系统监控
  };

  services = {
    tailscale.enable = true;   # VPN
    sunshine.enable = false;   # 游戏串流（按需开启）
  };
};
```

修改后重新构建：
```bash
sudo nixos-rebuild switch --flake .#desktop
```

---

## 🔧 配置定制指南

### 修改用户名

**只需修改一处：**
```nix
# flake.nix
username = "newuser";
gitUserName = "New User";
gitUserEmail = "newuser@example.com";
```

所有其他配置自动继承！

### 添加/删除应用

**用户应用（GUI 软件）：**
```nix
# home/shared/programs/applications.nix
home.packages = with pkgs; [
  vscode
  obsidian
  # 添加新应用
  gimp
];
```

**系统工具：**
```nix
# modules/core/base-packages.nix
environment.systemPackages = with pkgs; [
  git
  vim
  # 添加系统工具
  htop
];
```

### 开启/关闭功能模块

```nix
# hosts/your-host/default.nix
mySystem = {
  desktop.gnome.enable = false;      # 关闭 GNOME
  services.sunshine.enable = true;   # 开启 Sunshine
};
```

### 切换桌面环境

```nix
# 关闭 GNOME
mySystem.desktop.gnome.enable = false;

# 可以添加其他桌面环境模块
# modules/desktop/kde.nix
```

---

## 📦 模块功能说明

### 核心模块（必需）

| 模块 | 功能 | 位置 |
|------|------|------|
| locale.nix | 时区、语言 | modules/core/ |
| fonts.nix | 字体配置 | modules/core/ |
| base-packages.nix | 基础工具 | modules/core/ |
| nix.nix | Nix 设置 | modules/core/ |

### 硬件模块（可选）

| 模块 | 功能 | 开关 | 状态 |
|------|------|------|------|
| amd-gpu.nix | AMD 显卡驱动 + OpenCL | `mySystem.hardware.amdgpu.enable` | ✅ 已验证 |
| nvidia-gpu.nix | NVIDIA 专有驱动 + Prime | `mySystem.hardware.nvidia.enable` | ⚠️ 未测试 |
| intel-gpu.nix | Intel 核显 + VA-API | `mySystem.hardware.intelgpu.enable` | ⚠️ 未测试 |

> **注意**：NVIDIA 和 Intel 配置基于 NixOS 最佳实践编写，但未在实际硬件上测试。建议结合 [NixOS Wiki](https://nixos.wiki/) 或 AI 助手根据你的硬件调整。

### 桌面模块（可选）

| 模块 | 功能 | 开关 |
|------|------|------|
| gnome.nix | GNOME 桌面 + 音频 | `mySystem.desktop.gnome.enable` |
| wayland.nix | Wayland 支持 | `mySystem.desktop.wayland.enable` |
| monitoring.nix | 系统监控 | `mySystem.desktop.monitoring.enable` |

### 服务模块（可选）

| 模块 | 功能 | 开关 |
|------|------|------|
| tailscale.nix | Tailscale VPN | `mySystem.services.tailscale.enable` |
| sunshine.nix | 游戏串流 | `mySystem.services.sunshine.enable` |

---

## 🔄 日常使用

### 更新系统

**快捷命令（推荐）**：
```bash
update    # 自动更新 flake 依赖并重新构建系统
```

**完整命令**：
```bash
# 使用脚本
./update.sh

# 或手动更新
nix flake update
sudo nixos-rebuild switch --flake .#desktop
```

> 💡 `update` 是 Fish shell 别名，定义在 `home/common/terminal/fish.nix:27`

### 修改配置

**快捷命令**：
```bash
# 1. 编辑配置
vim modules/programs/applications.nix

# 2. 应用配置
rebuild    # 自动应用当前主机配置

# 3. 提交（使用 Fish 别名）
ga .
gc -m "feat: 添加新应用"
gp
```

**完整命令**：
```bash
# 1. 编辑配置
vim modules/programs/applications.nix

# 2. 测试
sudo nixos-rebuild test --flake .

# 3. 应用（会自动识别当前主机名）
sudo nixos-rebuild switch --flake .

# 4. 提交
git add .
git commit -m "feat: 添加新应用"
git push
```

> 💡 **多主机说明**：
> - NixOS 会自动根据 `networking.hostName` 选择对应配置
> - 无需在 desktop 和 legion 间切换时修改 flake.nix
> - Fish shell 别名：`rebuild`, `ga`, `gc`, `gp`

### 回滚系统

```bash
# 回滚到上一代
sudo nixos-rebuild switch --rollback

# 查看所有代
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

### 🐚 Fish Shell 别名速查

配置文件：`home/common/terminal/fish.nix`

| 别名 | 完整命令 | 说明 |
|------|---------|------|
| **系统管理** |
| `rebuild` | `sudo nixos-rebuild switch --flake /home/{username}/nixos-config#{hostname}` | 快速应用配置 |
| `update` | `cd /home/{username}/nixos-config && ./update.sh` | 更新自维护包和 flake 依赖，并重新构建 |
| `clean` | `sudo nix-collect-garbage -d && sudo nix-store --optimise` | 清理垃圾并优化存储 |
| `nixcfg` | `cd /home/{username}/nixos-config` | 快速进入配置目录 |
| `rebuild-check` | `nixos-rebuild build --flake /home/{username}/nixos-config#{hostname}` | 预览配置变更（无需 sudo） |
| **Git 简写** |
| `g` | `git` | Git 命令简写 |
| `gs` | `git status` | 查看状态 |
| `ga` | `git add` | 添加文件 |
| `gc` | `git commit` | 提交 |
| `gp` | `git push` | 推送 |
| `gl` | `git log --oneline --graph` | 图形化日志 |
| **目录导航** |
| `cd` | `z` (zoxide) | 智能目录跳转 |
| `..` | `cd ..` | 返回上级目录 |
| `...` | `cd ../..` | 返回上两级目录 |
| **命令增强** |
| `ll` | `eza -la --icons --git` | 详细列表 |
| `ls` | `eza --icons` | 图标列表 |
| `l` | `eza -l --icons` | 长格式列表 |
| `tree` | `eza --tree --icons` | 树形显示 |
| `cat` | `bat` | 语法高亮查看文件 |

> 💡 **说明**：`{username}` 和 `{hostname}` 会自动替换为 `flake.nix` 中配置的值

---

## 🏗️ 添加新主机

该配置已内置多主机支持，当前已配置 `desktop` 和 `legion`。添加新主机非常简单：

### 步骤 1：创建主机目录

```bash
# 生成硬件配置
sudo nixos-generate-config --show-hardware-config > hardware-new.nix

# 创建新主机目录
mkdir -p hosts/laptop

# 复制模板配置
cp hosts/desktop/{default.nix,configuration.nix} hosts/laptop/
mv hardware-new.nix hosts/laptop/hardware.nix
```

### 步骤 2：修改主机配置

```nix
# hosts/laptop/configuration.nix
networking.hostName = "laptop";  # 👈 修改为新主机名
# 根据需要调整其他配置...
```

### 步骤 3：在 flake.nix 中注册新主机

编辑 `flake.nix`，在 `nixosConfigurations` 中添加一行：

```nix
nixosConfigurations = {
  desktop = mkHost "desktop";
  legion = mkHost "legion";
  laptop = mkHost "laptop";     # 👈 添加新主机
};
```

> 💡 使用 `mkHost` 函数，无需重复配置代码

### 步骤 4：部署到新机器

```bash
# 初次部署指定主机名
sudo nixos-rebuild switch --flake .#laptop

# 后续更新无需指定，自动识别
sudo nixos-rebuild switch --flake .
```

---

## 📚 最佳实践

### 1. 配置分层

- **系统级** (`modules/`) - 系统服务、驱动、框架
- **用户级** (`home/shared/`) - GUI 应用、个人配置

### 2. 单一配置源

所有个人信息在 `flake.nix` 中定义：
```nix
username = "echoyn";                      # 系统用户名
gitUserName = "lying200";                 # Git 作者名
gitUserEmail = "lying200@outlook.com";    # Git 作者邮箱
```

主机名在各主机的 `configuration.nix` 中设置：
```nix
networking.hostName = "desktop";  # 或 "legion"、"laptop" 等
```

### 3. 功能可选

使用 `enable` 开关控制所有可选功能：
```nix
mySystem.services.sunshine.enable = false;  # 可关闭不需要的服务
```

### 4. 模块化原则

- 每个功能独立为一个模块
- 模块间低耦合
- 通过 `imports` 组合

---

## 🤝 贡献指南

### 提交规范

- `feat:` 新功能
- `fix:` 修复问题
- `refactor:` 重构代码
- `docs:` 文档更新
- `chore:` 依赖更新

### 示例

```bash
git commit -m "feat: 添加 KDE 桌面支持"
git commit -m "fix: 修复 Wayland 环境变量问题"
```

---

## 📖 参考资源

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [Home Manager](https://github.com/nix-community/home-manager)
- [NixOS Options Search](https://search.nixos.org/options)

---

## 📝 常见问题

### Q: 如何切换用户名？
A: 只需修改 `flake.nix` 中的 `username`、`gitUserName`、`gitUserEmail`，然后重新构建。

### Q: 如何添加新应用？
A: 编辑 `home/shared/programs/applications.nix`，添加到 `home.packages` 列表。

### Q: 如何禁用某个功能？
A: 在 `hosts/your-host/default.nix` 中设置对应的 `enable = false`。

### Q: 如何修改主机名？
A:
1. 编辑 `hosts/{旧主机名}/configuration.nix`，修改 `networking.hostName`
2. 编辑 `flake.nix`，在 `nixosConfigurations` 中添加新主机名：`新主机名 = mkHost "新主机名";`
3. 可选：重命名主机目录 `mv hosts/{旧主机名} hosts/{新主机名}`

### Q: 多台电脑如何共享配置？
A: 直接在两台电脑上 git clone 同一个仓库，各自运行 `sudo nixos-rebuild switch --flake .` 即可。NixOS 会自动根据当前 `networking.hostName` 选择对应配置，无需修改 flake.nix。

### Q: 硬件配置文件在哪里？
A: 每个主机目录下的 `hardware.nix`，由 `nixos-generate-config` 自动生成。

### Q: 如何备份配置？
A: 只需推送到 Git 仓库，所有配置都已版本化。

### Q: 如何切换显卡？
A: 编辑 `hosts/desktop/default.nix`，修改 `mySystem.hardware` 配置：

**⚠️ 重要提示**：NVIDIA 和 Intel GPU 配置未经实际测试，可能需要微调。建议：
- 参考 [NixOS Wiki - NVIDIA](https://nixos.wiki/wiki/Nvidia) 或 [Intel Graphics](https://nixos.wiki/wiki/Intel_Graphics)
- 使用 AI 助手（Claude/ChatGPT）根据你的硬件生成配置
- 在虚拟机或测试环境中先验证

```nix
# AMD 显卡（已验证 ✅）
mySystem.hardware.amdgpu.enable = true;

# NVIDIA 显卡（未测试 ⚠️ - 建议结合 AI 调整）
mySystem.hardware.nvidia.enable = true;

# Intel 核显（未测试 ⚠️ - 建议结合 AI 调整）
mySystem.hardware.intelgpu.enable = true;

# 混合显卡笔记本（NVIDIA Prime，未测试 ⚠️）
mySystem.hardware.nvidia = {
  enable = true;
  prime = {
    enable = true;
    nvidiaBusId = "PCI:1:0:0";  # 使用 lspci | grep -i nvidia 查询
    intelBusId = "PCI:0:2:0";   # 使用 lspci | grep -i vga 查询
  };
};
```

---

**License**: MIT
**Maintainer**: Echoyn (lying200@outlook.com)
