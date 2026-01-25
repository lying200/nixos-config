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

### 前置要求

- NixOS 已安装（最小化安装即可）
- 有网络连接
- 有 GitHub 访问权限

### 步骤 1：启用 Flakes 和 Git

```bash
# 临时启用 Flakes（安装 Git）
nix-shell -p git nixFlakes

# 配置 Git（如果需要）
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### 步骤 2：克隆配置仓库

```bash
# 克隆到 ~/nixos-config
git clone https://github.com/yourusername/nixos-config.git ~/nixos-config
cd ~/nixos-config
```

### 步骤 3：生成硬件配置

```bash
# 生成新机器的硬件配置
sudo nixos-generate-config --show-hardware-config > hardware-new.nix

# 创建新主机目录（如果需要）
mkdir -p hosts/new-host

# 复制模板配置
cp hosts/desktop/{default.nix,configuration.nix} hosts/new-host/
mv hardware-new.nix hosts/new-host/hardware.nix
```

### 步骤 4：修改配置

#### 4.1 修改 flake.nix（单一配置源）

```nix
# flake.nix
let
  # 用户配置（修改这里）
  username = "yourname";              # 👈 修改用户名
  userFullName = "Your Full Name";    # 👈 修改 Git 用户名
  userEmail = "your@email.com";       # 👈 修改邮箱
in {
  nixosConfigurations = {
    # 添加新主机配置
    new-host = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs username userFullName userEmail;
      };
      modules = [
        ./hosts/new-host/default.nix
        # ... Home Manager 配置
      ];
    };
  };
}
```

#### 4.2 修改主机配置

```nix
# hosts/new-host/configuration.nix
{
  # 主机名（修改这里）
  networking.hostName = "new-host";  # 👈 修改主机名

  # 其他主机特定配置...
}
```

#### 4.3 功能选择性启用

```nix
# hosts/new-host/default.nix
{
  # 启用功能模块
  mySystem = {
    desktop = {
      gnome.enable = true;       # 👈 桌面环境
      wayland.enable = true;     # 👈 Wayland 支持
      monitoring.enable = true;  # 👈 系统监控
    };

    services = {
      tailscale.enable = true;   # 👈 VPN
      sunshine.enable = false;   # 👈 游戏串流（按需开启）
    };
  };
}
```

### 步骤 5：构建并切换

```bash
# 测试构建（不切换）
sudo nixos-rebuild test --flake .#new-host

# 如果测试通过，切换到新配置
sudo nixos-rebuild switch --flake .#new-host

# 重启系统
reboot
```

### 步骤 6：验证

```bash
# 检查主机名
hostname

# 检查用户
whoami

# 检查 Git 配置
git config --global user.name
git config --global user.email
```

---

## 🔧 配置定制指南

### 修改用户名

**只需修改一处：**
```nix
# flake.nix
username = "newuser";
userFullName = "New User";
userEmail = "newuser@example.com";
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

```bash
# 使用脚本（推荐）
./update.sh

# 或手动更新
nix flake update
sudo nixos-rebuild switch --flake .#desktop
```

### 修改配置

```bash
# 1. 编辑配置
vim modules/programs/applications.nix

# 2. 测试
sudo nixos-rebuild test --flake .#desktop

# 3. 应用
sudo nixos-rebuild switch --flake .#desktop

# 4. 提交
git add .
git commit -m "feat: 添加新应用"
git push
```

### 回滚系统

```bash
# 回滚到上一代
sudo nixos-rebuild switch --rollback

# 查看所有代
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

---

## 🏗️ 添加新主机

### 场景 1：同用户的新机器

```nix
# flake.nix - 只需添加新的 nixosConfiguration
nixosConfigurations = {
  desktop = { ... };

  laptop = nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs username userFullName userEmail;  # 使用相同用户
    };
    modules = [ ./hosts/laptop/default.nix ];
  };
};
```

### 场景 2：不同用户的新机器

```nix
# flake.nix - 为新机器指定不同用户
server = nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit inputs;
    username = "admin";           # 不同用户名
    userFullName = "Admin User";
    userEmail = "admin@example.com";
  };
  modules = [ ./hosts/server/default.nix ];
};
```

---

## 📚 最佳实践

### 1. 配置分层

- **系统级** (`modules/`) - 系统服务、驱动、框架
- **用户级** (`home/shared/`) - GUI 应用、个人配置

### 2. 单一配置源

所有个人信息在 `flake.nix` 中定义：
```nix
username = "echoyn";
userFullName = "lying200";
userEmail = "lying200@outlook.com";
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
A: 只需修改 `flake.nix` 中的 `username`、`userFullName`、`userEmail`，然后重新构建。

### Q: 如何添加新应用？
A: 编辑 `home/shared/programs/applications.nix`，添加到 `home.packages` 列表。

### Q: 如何禁用某个功能？
A: 在 `hosts/your-host/default.nix` 中设置对应的 `enable = false`。

### Q: 硬件配置文件在哪里？
A: 每个主机目录下的 `hardware.nix`，由 `nixos-generate-config` 自动生成。

### Q: 如何备份配置？
A: 只需推送到 Git 仓库，所有配置都已版本化。

---

**License**: MIT
**Maintainer**: Echoyn (lying200@outlook.com)
