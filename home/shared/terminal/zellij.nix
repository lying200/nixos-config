{ pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      theme = "catppuccin-mocha";
      default_layout = "compact";

      simplified_ui = true;
      pane_frames = false;

      mouse_mode = true;
      scroll_buffer_size = 10000;

      copy_command = "wl-copy";
      copy_on_select = false;

      session_serialization = true;
      pane_viewport_serialization = true;
      scrollback_lines_to_serialize = 10000;

      auto_layout = true;
      mirror_session = false;

      on_force_close = "quit";
      default_shell = "fish";
      show_startup_tips = false;
      scrollback_editor = "nvim";
    };
  };

  xdg.configFile."zellij/config.kdl".text = ''
    keybinds {
      scroll {
        bind "e" {
          EditScrollback;
          SwitchToMode "Normal";
        }

        bind "J" { ScrollDown; }
        bind "K" { ScrollUp; }

        bind "g" { ScrollToTop; }
        bind "G" { ScrollToBottom; }
      }
    }
  '';

  xdg.configFile."zellij/layouts/default.kdl".text = ''
    layout {
      default_tab_template {
        children
        pane size=1 borderless=true {
          plugin location="zellij:tab-bar"
        }
      }

      tab name="main" focus=true {
        pane
      }
    }
  '';

  xdg.configFile."zellij/themes/catppuccin-mocha.kdl".text = ''
    themes {
      catppuccin-mocha {
        fg "#CDD6F4"
        bg "#1E1E2E"
        black "#45475A"
        red "#F38BA8"
        green "#A6E3A1"
        yellow "#F9E2AF"
        blue "#89B4FA"
        magenta "#F5C2E7"
        cyan "#94E2D5"
        white "#BAC2DE"
        orange "#FAB387"
      }
    }
  '';

}
