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

        config = {
          warn_about_missing_glyphs = false,
          enable_wayland = false,
          front_end = "OpenGL",
          -- enable_wayland = true,
          -- front_end = "WebGpu",
          default_prog = { 'tmux', 'new-session' },
          debug_key_events = true,

          -- For example, changing the color scheme:
          color_scheme = 'Rosé Pine (base16)',
          -- color_scheme = 'Catppuccin Mocha (Gogh)',
          -- color_scheme = 'Tokyo Night (Gogh)',
          window_background_opacity = 0.80,

          font = wezterm.font_with_fallback {
            { family = 'Operator Mono Light', harfbuzz_features = { 'liga=1' } },
            -- TODO Buy when have job - https://berkeleygraphics.com/typefaces/berkeley-mono/
            -- { family = 'Berkeley Mono Trial', weight = 'Light' },
            -- { family = 'SFMono Nerd Font', weight = 'Light' },
            -- { family = 'GeistMono Nerd Font Mono', weight = 'Light' },
            'FiraCode Nerd Font',
            'Ubuntu Mono',
          },
          font_size = 10.0,

          hide_tab_bar_if_only_one_tab = true,

          window_padding = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0,
          },

          keys = {
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
          },
        }

      return config
    '';
  };

  home.sessionVariables = {
    TERM = "wezterm";
  };
}
