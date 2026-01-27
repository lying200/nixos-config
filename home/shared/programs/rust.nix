{ pkgs, lib, ... }:

{
  # Rust 开发工具（用户级）
  home.packages = with pkgs; [
    rust-analyzer    # LSP 服务器
    cargo-edit       # cargo add/rm/upgrade
    cargo-watch      # 文件监听自动编译
    cargo-llvm-cov   # 代码覆盖率
  ];

  # Rust 环境变量
  home.sessionVariables =
    let
      libPath = lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib
        pkgs.zlib
      ];
    in {
      RUST_BACKTRACE = "1";
      RUSTUP_HOME = "$HOME/.rustup";
      CARGO_HOME = "$HOME/.cargo";

      # NixOS 修复：使用正确的动态链接器和库路径
      CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER = "${pkgs.gcc}/bin/gcc";
      LD_LIBRARY_PATH = libPath;
    };

  # 添加 cargo 到 PATH
  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];

  # 用户级：初始化 rustup（首次激活时）
  home.activation.rustupInit = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.cargo/bin/cargo" ]; then
      $DRY_RUN_CMD echo "🦀 初始化 Rust 工具链..."
      $DRY_RUN_CMD ${pkgs.rustup}/bin/rustup default stable
      $DRY_RUN_CMD ${pkgs.rustup}/bin/rustup component add rust-src clippy rustfmt
    fi
  '';
}
