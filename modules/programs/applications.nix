{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # 开发工具
    jetbrains-toolbox
    vscode
    antigravity

    # 浏览器
    google-chrome

    # 通讯
    wechat
    qq  # QQ for Linux

    # AI 工具
    gemini-cli

    # 启动器与截图
    ulauncher
    wmctrl
    snipaste

    # 多媒体
    vlc                    # 视频播放器
    mpv                    # 轻量视频播放器
    obs-studio             # 录屏/直播工具

    # 壁纸管理
    variety                # 自动切换壁纸

    # 办公/文档
    libreoffice-fresh      # Office 套件
    obsidian               # Markdown 笔记/知识库
    typora

    # 文件管理
    syncthing              # 文件同步
    rclone                 # 云存储管理

    # 实用工具
    motrix                 # 下载工具（支持 HTTP/BT/磁力）
    thunderbird            # 邮件客户端
  ];
}
