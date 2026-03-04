{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # 开发工具
    jetbrains.idea
    jetbrains.goland
    jetbrains.datagrip
    jetbrains.webstorm
    jetbrains.rust-rover
    jetbrains.pycharm

    vscode               # 代码编辑器
    antigravity          # 代码编辑器

    # 浏览器
    google-chrome        # 主流浏览器

    # 通讯
    wechat               # 即时通讯
    qq                   # QQ for Linux
    thunderbird          # 邮件客户端
    telegram-desktop

    # AI 工具
    gemini-cli           # Google Gemini CLI

    # 文件管理
    nautilus             # GNOME 文件管理器
    loupe                # GNOME 图片查看器
    file-roller          # 归档管理器

    # 截图工具
    snipaste             # 截图贴图工具

    # 多媒体
    vlc                  # 视频播放器
    mpv                  # 轻量级播放器
    obs-studio           # 录屏/直播工具

    # 壁纸管理（GNOME 下使用）
    variety              # 自动切换壁纸

    # 办公/文档
    libreoffice-fresh    # Office 套件
    obsidian             # Markdown 笔记/知识库
    typora               # Markdown 编辑器

    # 文件管理
    syncthing            # 文件同步
    rclone               # 云存储管理

    # 实用工具
    motrix               # 下载工具（支持 HTTP/BT/磁力）
    flclash              # 代理工具

    # 远程
    remmina
    moonlight-qt
  ];
}
