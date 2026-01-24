{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # 开发 SDK
    nodejs_24              # Node.js 24 LTS
    jdk25                  # OpenJDK 25 LTS
    python314              # Python 3.14
    go_1_25                # Go 1.25
    rustup                 # Rust 工具链管理器
  ];
}
