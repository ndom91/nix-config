{
  config,
  pkgs,
  ...
}: 
let
  startupScript = pkgs.pkgs.writeShellScriptBin "waybar" ''
    ${pkgs.waybar}/bin/waybar &
  '';
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ndo";
  home.homeDirectory = "/home/ndo";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.vivaldi
    pkgs.gnome.gnome-boxes
    pkgs.slack
    pkgs.virt-manager
    pkgs.lazygit
    pkgs.alejandra
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ndo/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = {
      inputs.hyprland-plugins.packages."${pkgs.system}".h3
    };
    settings = {
      exec-once = [
        "${startupScript}/bin/start"
        "${startupScript}/bin/waybar"
      ];
      general = {
        gaps_in = 10;
        gaps_out = 20;
        border_size = 6;
        "col.active_border" = "rgb(11111b) rgb(181825) 45deg";
        "col.inactive_border" = "rgba(f5e0dc20)";

        layout = hy3;
        resize_on_border = true;
      };
      decoration = {
        rounded = 1;
        drop_shadow = false;
        active_opacity = 0.95;
        inactive_opacity = 0.80;
        fullscreen_opacity = 1.00;
      };
      animations = {
        enabled = "yes";
        bezier = "overshot, 0.05, 0.9, 0.1, 1.05";
      };
      "$mainMod" = "SUPER";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
