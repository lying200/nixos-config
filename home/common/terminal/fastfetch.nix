{ ... }:

{
  programs.fastfetch = {
    enable = true;

    # 面向小窗口：nixos_small 小 logo + 缩短各模块 format，最长行约 62 列
    settings = {
      logo = {
        type = "builtin";
        source = "nixos_small";
        padding = {
          top = 1;
          right = 3;
        };
      };

      display.separator = ": ";

      modules = [
        "break"
        {
          type = "title";
          format = "{user-name}@{host-name}";
        }
        "separator"
        {
          type = "os";
          key = "OS";
          keyColor = "34";
          format = "{3}";
        }
        {
          type = "kernel";
          key = "Kernel";
          keyColor = "34";
          format = "{2}";
        }
        {
          type = "uptime";
          key = "Uptime";
          keyColor = "34";
        }
        {
          type = "packages";
          key = "Packages";
          keyColor = "34";
          format = "{nix-system} (system), {nix-user} (user)";
        }
        {
          type = "shell";
          key = "Shell";
          keyColor = "33";
          format = "{1} {4}";
        }
        {
          type = "terminal";
          key = "Terminal";
          keyColor = "33";
          format = "{3}";
        }
        {
          type = "wm";
          key = "WM";
          keyColor = "33";
          format = "{2} ({3})";
        }
        {
          type = "display";
          key = "Display";
          keyColor = "33";
          compactType = "original-with-refresh-rate";
        }
        {
          type = "cpu";
          key = "CPU";
          keyColor = "35";
          format = "{1}";
        }
        {
          type = "gpu";
          key = "GPU";
          keyColor = "35";
          format = "{2}";
        }
        {
          type = "memory";
          key = "Memory";
          keyColor = "35";
        }
        {
          type = "disk";
          key = "Disk";
          keyColor = "35";
          format = "{1} / {2} ({3})";
        }
        {
          type = "battery";
          key = "Battery";
          keyColor = "35";
          format = "{4} [{5}]";
        }
        "break"
        {
          type = "colors";
          symbol = "circle";
        }
      ];
    };
  };
}
