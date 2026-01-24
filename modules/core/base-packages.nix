{ pkgs, ... }:

{
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

    # 进程管理
    psmisc           # killall, pstree 等工具
    procps           # ps, top, pgrep 等工具

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
}
