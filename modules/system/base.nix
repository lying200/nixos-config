{ pkgs, lib, ... }:

{
  # 时区与语言
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  fonts = {
    fontDir.enable = true;
    
    packages = with pkgs; [
      cascadia-code
      jetbrains-mono
      
      lxgw-wenkai
      
      sarasa-gothic
      
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

    fontconfig.defaultFonts = {
      # 终端/代码编辑器默认字体
      monospace = [ 
        "Cascadia Code"       
        "Sarasa Mono SC"      
      ];

      # 系统 UI / 网页默认字体 (无衬线)
      sansSerif = [ 
        "LXGW WenKai"         # 1. 优先用霞鹜文楷 (非常友好的阅读感)
        "Sarasa UI SC"        # 2. 其次用更纱 UI
        "Noto Sans CJK SC"    # 3. 保底
      ];

      # 文档/衬线字体
      serif = [ 
        "LXGW WenKai"
        "Noto Serif CJK SC" 
      ];
    };
  };

  # 允许闭源软件
  nixpkgs.config.allowUnfree = true;
  
  # 开启 Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # 常用软件
  environment.systemPackages = with pkgs; [
    # 编辑器与版本控制
    git vim wget curl

    # 系统信息查看
    mesa-demos       # OpenGL 信息 (GPU 驱动/渲染器)
    vulkan-tools     # Vulkan 信息 (vulkaninfo)
    pciutils         # lspci (PCI 设备查看)
    usbutils         # lsusb (USB 设备查看)
    lshw             # 硬件信息详细查看
    inxi             # 系统信息汇总工具

    # 网络工具
    nmap             # 网络扫描
    iperf3           # 网络性能测试
    dig              # DNS 查询
    traceroute       # 路由追踪

    # 文件与压缩
    tree             # 目录树显示
    ripgrep          # 快速文件内容搜索 (rg)
    fd               # 快速文件查找 (fd)
    unzip zip        # 压缩解压
    p7zip            # 7z 格式支持

    # 性能与进程
    btop             # 现代化系统监控
    iotop            # IO 监控

    # 其他工具
    neofetch         # 系统信息展示
    tmux             # 终端复用器
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config = {
      common = {
        default = [ "gnome" ];
      };
    };
  };
  services.pipewire.enable = true;
  security.polkit.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
  };  

  services.openssh.enable = true;
}
