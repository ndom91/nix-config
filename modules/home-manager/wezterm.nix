{ input, unstablePkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    package = unstablePkgs.wezterm;
    enableBashIntegration = false;
    enableZshIntegration = false;
    extraConfig = ''
        local config = {}

        -- In newer versions of wezterm, use the config_builder which will
        -- help provide clearer error messages
        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        config.warn_about_missing_glyphs = false

        config.enable_wayland = true

        config.default_prog = { 'tmux', 'new-session' }

        config.debug_key_events = true

        -- For example, changing the color scheme:
        config.color_scheme = 'Rosé Pine (base16)'
        -- config.color_scheme = 'Catppuccin Mocha (Gogh)'
        -- config.color_scheme = 'Tokyo Night (Gogh)'
        config.window_background_opacity = 0.92

        config.font = wezterm.font_with_fallback {
          -- TODO Buy when have job - https://berkeleygraphics.com/typefaces/berkeley-mono/
          -- { family = 'Berkeley Mono Trial', weight = 'Light' },
          { family = 'Operator Mono Light', harfbuzz_features = { 'liga=1' } },
          { family = 'GeistMono Nerd Font' },
          'FiraCode Nerd Font',
          'Ubuntu Mono',
        }
        config.font_size = 10.0

        config.hide_tab_bar_if_only_one_tab = true

        config.window_padding = {
          left = 0,
          right = 0,
          top = 0,
          bottom = 0,
        }

        config.keys = {
          {
            key = 'R',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.ReloadConfiguration,
          },
          {
            key = 'S',
            mods = 'SHIFT|CTRL',
            action = wezterm.action.QuickSelect,
          },
        }

      return config
    '';
  };

  home.sessionVariables = {
    TERM = "wezterm";
  };
}
