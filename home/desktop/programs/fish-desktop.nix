{lib, ...}: let
  # JetBrains IDE 启动函数：无参数时打开当前目录，后台运行不占用终端
  mkJetbrainsLauncher = name: description: {
    inherit description;
    body = ''
      set -l target $argv
      if test (count $argv) -eq 0
        set target "."
      end
      nohup ${name} $target > /dev/null 2>&1 &
    '';
  };
in {
  programs.fish.functions = lib.mapAttrs mkJetbrainsLauncher {
    idea = "启动 IntelliJ IDEA Ultimate";
    rust-rover = "启动 RustRover";
    datagrip = "启动 DataGrip";
    webstorm = "启动 WebStorm";
    goland = "启动 GoLand";
    pycharm = "启动 PyCharm";
  };

  programs.fish.shellAliases = {
    rebuild-help = "echo 'Please run this in a real terminal (Ghostty/Gnome Terminal), not in IDEA'";
  };
}
