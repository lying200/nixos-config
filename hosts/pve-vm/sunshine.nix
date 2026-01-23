{ pkgs, config, ... }:

{
  # 1. 启用 Sunshine
  services.sunshine = {
    enable = true;
    autoStart = true;
    openFirewall = true;
    capSysAdmin = true;
  };

  # 2. 禁用 GDM 锁屏时挂起会话，保持 Sunshine 连接
  services.displayManager.gdm.autoSuspend = false;

  # 3. 启用自动登录，避免锁屏后需要重新配对
  services.displayManager.autoLogin = {
    enable = true;
    user = "echoyn";
  };

  # 4. 解决自动登录与 GNOME Keyring 的冲突
  security.pam.services.gdm-autologin.text = ''
    auth     required  pam_succeed_if.so uid >= 1000 quiet
    auth     required  pam_permit.so
    account  include   gdm
    password include   gdm
    session  include   gdm
  '';

  # setsid 用于启动 Steam/Desktop 环境，xrandr 用于调整分辨率
  environment.systemPackages = with pkgs; [
    util-linux    # 包含 setsid
    xorg.xrandr   # 包含 xrandr
  ];

  # 强制加载 uinput 模块
  boot.kernelModules = [ "uinput" ];

  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", MODE="0666"
  '';
}
