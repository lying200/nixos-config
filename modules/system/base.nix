{ pkgs, ... }:

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
    git vim wget
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland,x11";
    SDL_VIDEODRIVER = "wayland";
  };  

  services.openssh.enable = true;
}
