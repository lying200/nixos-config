# NixOS Configuration

Echoyn 的模块化 NixOS 配置，基于 Flake 构建。

> 该文档使用 AI 生成

## 📁 项目结构

```
nixos-config/
├── flake.nix                    # Flake 入口配置
├── flake.lock                   # 锁定的依赖版本
├── update.sh                    # 系统更新脚本
│
├── hosts/                       # 🖥️ 主机特定配置
│   └── pve-vm/                 # PVE 虚拟机
│       ├── default.nix         # 模块导入入口
│       ├── hardware.nix        # 硬件配置（自动生成）
│       └── configuration.nix   # 主机配置（bootloader、用户、网络）
│
├── modules/                     # 📦 可复用模块
│   ├── core/                   # 核心系统配置
│   │   ├── locale.nix          # 时区、语言设置
│   │   ├── fonts.nix           # 字体配置
│   │   ├── base-packages.nix   # 基础工具包
│   │   └── nix.nix             # Nix 配置（Flakes、GC、SSH）
│   │
│   ├── hardware/               # 硬件支持
│   │   └── amd-gpu.nix         # AMD GPU 驱动和传感器
│   │
│   ├── desktop/                # 桌面环境
│   │   ├── wayland.nix         # Wayland 环境变量和 Portal
│   │   ├── gnome.nix           # GNOME 桌面和音频
│   │   └── monitoring.nix      # 系统监控工具（Vitals、lm_sensors）
│   │
│   ├── services/               # 系统服务
│   │   ├── tailscale.nix       # Tailscale VPN
│   │   └── sunshine.nix        # 串流服务
│   │
│   └── programs/               # 应用程序配置
│       ├── fcitx5.nix          # Fcitx5 输入法（雾凇拼音）
│       ├── applications.nix    # 应用软件列表
│       ├── app-shortcuts.nix   # GNOME 自定义快捷键
│       ├── autostart.nix       # 开机自启动应用
│       ├── variety.nix         # Variety 壁纸配置
│       └── git.nix             # Git 全局配置
│
├── .github/workflows/           # GitHub Actions
│   ├── ci.yml                  # PR 构建检查
│   └── update-flake.yml        # 自动更新依赖
│
└── lib/                         # 辅助函数库（预留）
```

## 🚀 快速开始

### 初次部署

```bash
# 1. 克隆仓库
git clone https://github.com/yourusername/nixos-config.git ~/nixos-config
cd ~/nixos-config

# 2. 构建并切换到新配置
sudo nixos-rebuild switch --flake .#nixos

# 3. 重启系统
reboot
```

## 🔄 日常使用

### 更新系统

#### 推荐方式：使用更新脚本
```bash
./update.sh
```

脚本会自动完成：
1. ✅ 更新 flake inputs (nixpkgs 等)
2. ✅ 测试构建新配置
3. ✅ 询问是否切换到新配置

#### 手动更新流程
```bash
# 1. 更新所有依赖
nix flake update

# 2. 测试新配置（不切换）
sudo nixos-rebuild test --flake .#nixos

# 3. 切换到新配置
sudo nixos-rebuild switch --flake .#nixos
```

#### 更新特定依赖
```bash
# 只更新 nixpkgs
nix flake lock --update-input nixpkgs

# 只更新 rime-ice 输入法词库
nix flake lock --update-input rime-ice
```

### 修改配置

```bash
# 1. 编辑配置文件（任何 modules/ 或 hosts/ 下的 .nix 文件）
vim modules/programs/applications.nix

# 2. 测试配置
sudo nixos-rebuild test --flake .#nixos

# 3. 确认无误后切换
sudo nixos-rebuild switch --flake .#nixos

# 4. 提交到 Git
git add .
git commit -m "feat: 添加新应用"
git push
```

## 🛠️ 常用命令

### 系统管理
```bash
# 查看当前系统生成（generation）
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# 回滚到上一个生成
sudo nixos-rebuild switch --rollback

# 回滚到指定生成（如 42）
sudo nixos-rebuild switch --rollback --to 42
```

### Flake 操作
```bash
# 查看 flake 结构
nix flake show

# 检查 flake 配置
nix flake check

# 查看 flake 元数据
nix flake metadata
```

### 垃圾回收
```bash
# 手动清理旧生成（释放空间）
sudo nix-collect-garbage -d

# 删除超过 7 天的旧生成
sudo nix-collect-garbage --delete-older-than 7d

# 查看 /nix/store 占用
du -sh /nix/store

# 优化 store（硬链接重复文件）
nix-store --optimise
```

### 包管理
```bash
# 搜索软件包
nix search nixpkgs <package-name>

# 临时安装包（不写入配置）
nix shell nixpkgs#<package-name>

# 查看包信息
nix eval nixpkgs#<package-name>.meta.description
```

## 🤖 自动化

### 自动垃圾回收
系统已配置自动清理：
- **频率**: 每周
- **策略**: 删除 30 天前的旧生成
- **配置**: `modules/core/nix.nix`

### GitHub Actions

#### CI 构建检查
- **触发**: PR 和推送到 main 分支
- **功能**: 验证配置语法和构建

#### 自动依赖更新
- **触发**: 每周一凌晨 2:00 (也可手动触发)
- **功能**:
  1. 自动运行 `nix flake update`
  2. 测试构建
  3. 创建 PR 等待 review
  4. 合并后其他机器只需 `git pull`

## 🎨 自定义配置

### 添加新软件

编辑 `modules/programs/applications.nix`:
```nix
environment.systemPackages = with pkgs; [
  # ... 现有软件
  neovim  # 添加新软件
];
```

### 添加自定义快捷键

编辑 `modules/programs/app-shortcuts.nix`:
```nix
"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
  name = "My Custom Shortcut";
  command = "your-command";
  binding = "<Super>x";
};
```

### 当前快捷键
- `F1` - Snipaste 截图
- `Alt+Space` - ulauncher 启动器

### 开机自启动应用
以下应用已配置为开机自动启动（`modules/programs/autostart.nix`）：
- ✅ **JetBrains Toolbox** - IDE 管理器（最小化启动）
- ✅ **ulauncher** - 应用启动器（后台运行）
- ✅ **Snipaste** - 截图工具（快捷键随时可用）
- ✅ **Variety** - 壁纸自动切换
- ✅ **CopyQ** - 剪贴板历史管理（通过 XWayland 运行）

**注意**：
- JetBrains Toolbox 启动后会最小化到系统托盘，方便快速打开 IDE
- CopyQ 在 Wayland 下需要使用 XWayland (xcb) 才能正常访问剪贴板
- 配置已自动添加 `QT_QPA_PLATFORM=xcb` 环境变量
- 如需禁用某个自启动，编辑 `modules/programs/autostart.nix` 并注释掉对应配置

## 🏠 添加新主机

```bash
# 1. 在新机器上生成硬件配置
sudo nixos-generate-config --show-hardware-config > hardware.nix

# 2. 创建主机目录
mkdir -p hosts/new-host
cp hosts/pve-vm/{default.nix,configuration.nix} hosts/new-host/
mv hardware.nix hosts/new-host/

# 3. 修改 configuration.nix 中的主机名和用户

# 4. 在 flake.nix 中添加新主机
nixosConfigurations.new-host = nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs; };
  modules = [ ./hosts/new-host/default.nix ];
};

# 5. 在新主机上部署
sudo nixos-rebuild switch --flake .#new-host
```

## 📊 配置特性

### 核心功能
- ✅ Flakes 支持
- ✅ 模块化配置
- ✅ 自动垃圾回收
- ✅ Store 自动优化

### 桌面环境
- ✅ GNOME 46+ (Wayland)
- ✅ Pipewire 音频
- ✅ HiDPI 缩放支持
- ✅ 系统监控工具
- ✅ Variety 自动壁纸切换

### 输入法
- ✅ Fcitx5 + 雾凇拼音
- ✅ 小鹤双拼方案
- ✅ GNOME 原生集成

### 硬件支持
- ✅ AMD GPU (AMDGPU 驱动)
- ✅ OpenCL 支持
- ✅ 硬件传感器监控

## 📦 已安装软件列表

### 开发工具
- **JetBrains Toolbox** - JetBrains IDE 管理器
- **VSCode** - 代码编辑器

### 浏览器
- **Google Chrome** - 主流浏览器

### 通讯
- **微信** - 即时通讯
- **QQ** - QQ for Linux
- **Thunderbird** - 邮件客户端

### 多媒体
- **VLC** - 全能视频播放器
- **MPV** - 轻量级播放器
- **OBS Studio** - 录屏/直播工具

### 办公/文档
- **LibreOffice** - Office 套件（Writer/Calc/Impress）
- **Obsidian** - Markdown 笔记/知识库

### 文件管理
- **Syncthing** - P2P 文件同步
- **rclone** - 云存储管理工具

### 实用工具
- **ulauncher** - 应用启动器 (Alt+Space)
- **Snipaste** - 截图工具 (F1)
- **Variety** - 壁纸自动切换
- **CopyQ** - 剪贴板历史管理
- **Motrix** - 下载工具（支持 HTTP/BT/磁力）

### AI 工具
- **Gemini CLI** - Google Gemini 命令行工具

## 📚 参考资源

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Flakes Wiki](https://nixos.wiki/wiki/Flakes)
- [NixOS Options Search](https://search.nixos.org/options)
- [Home Manager](https://github.com/nix-community/home-manager)
- [Awesome NixOS](https://github.com/nix-community/awesome-nix)

## 📝 开发说明

### 项目原则
1. **模块化**: 每个功能独立为单独的 `.nix` 文件
2. **分层清晰**: hosts (主机) / modules (复用)
3. **职责分离**: 按功能域分类 (core/hardware/desktop/services/programs)
4. **声明式**: 所有配置通过 Nix 声明，避免命令式操作

### 提交规范
- `feat:` 新功能
- `fix:` 修复问题
- `refactor:` 重构代码
- `chore:` 依赖更新等杂项
- `docs:` 文档更新

---

**License**: MIT
**Maintainer**: Echoyn (lying200@outlook.com)
