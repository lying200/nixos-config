{ ... }:

{
  programs.fish.functions = {
    idea = {
      description = "启动 IntelliJ IDEA Ultimate";
      body = ''
        set -l target $argv
        if test (count $argv) -eq 0
          set target "."
        end
        nohup idea $target > /dev/null 2>&1 &
      '';
    };

    rust-rover = {
      description = "启动 RustRover";
      body = ''
        set -l target $argv
        if test (count $argv) -eq 0
          set target "."
        end
        nohup rust-rover $target > /dev/null 2>&1 &
      '';
    };

    datagrip = {
      description = "启动 DataGrip";
      body = ''
        set -l target $argv
        if test (count $argv) -eq 0
          set target "."
        end
        nohup datagrip $target > /dev/null 2>&1 &
      '';
    };

    webstorm = {
      description = "启动 WebStorm";
      body = ''
        set -l target $argv
        if test (count $argv) -eq 0
          set target "."
        end
        nohup webstorm $target > /dev/null 2>&1 &
      '';
    };

    goland = {
      description = "启动 GoLand";
      body = ''
        set -l target $argv
        if test (count $argv) -eq 0
          set target "."
        end
        nohup goland $target > /dev/null 2>&1 &
      '';
    };

    pycharm = {
      description = "启动 PyCharm";
      body = ''
        set -l target $argv
        if test (count $argv) -eq 0
          set target "."
        end
        nohup pycharm $target > /dev/null 2>&1 &
      '';
    };
  };

  programs.fish.shellAliases = {
    rebuild-help = "echo 'Please run this in a real terminal (Ghostty/Gnome Terminal), not in IDEA'";
  };
}
