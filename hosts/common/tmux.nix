{ pkgs, input, ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    newSession = true;
    historyLimit = 10000;
    prefix = "C-a";
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = mode-indicator;
      }
      # "ofirgall/tmux-window-name"
      #   Not in nixpkgs.tmuxPlugins
      #   Manual installation: https://github.com/ofirgall/tmux-window-name#manual-installation
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'

          set -g @catppuccin_user off
          set -g @catppuccin_host off
          set -g @catppuccin_date_time "%Y-%m-%d %H:%M"

          set -g @catppuccin_window_left_separator "█"
          set -g @catppuccin_window_right_separator "█"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_middle_separator "  █"
          set -g @catppuccin_window_status_enable "no"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W"

          set -g @catppuccin_status_modules_left "application date_time"
          set -g @catppuccin_status_modules_right "prefix_highlight"
          set -g @catppuccin_status_left_separator "█"
          set -g @catppuccin_status_right_separator "█ "
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "all"
          set -g @catppuccin_status_connect_separator "no"
        '';
      }
      {
        plugin = tmux-thumbs;
        # run-shell ~/.config/tmux/plugins/tmux-thumbs/tmux-thumbs.tmux
        extraConfig = ''
          set -g @thumbs-command 'echo -n {} | wl-copy'
        '';
      }
    ];
    extraConfig = ''
      # for nested tmux sessions
      bind-key a send-prefix 

      setw -g aggressive-resize on

      # basic settings
      set-window-option -g xterm-keys on # for vim
      set-window-option -g monitor-activity on

      # start panes at 1 - 0 is too far away :)
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Undercurl
      set -g default-terminal "xterm-256color"
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

      # FZF-TMUX WINDOW SWITCH
      bind-key    -T prefix s                choose-tree
      bind-key    -T prefix W                choose-window
      bind        -T prefix w                run-shell -b "$HOME/.dotfiles/scripts/tmux-switch-panes.sh"

      # Titles (window number, program name, active (or not))
      set-option -g set-titles on
      set-option -g set-titles-string '#H #W'

      # Unbinds
      unbind j
      unbind C-b # unbind default leader key
      unbind '"' # unbind horizontal split
      unbind %   # unbind vertical split

      # reload tmux conf
      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "~/.config/tmux/tmux.conf reloaded"

      # new split in current pane (horizontal / vertical)
      bind-key c split-window -v # split pane horizontally
      bind-key v split-window -h # split pane vertically

      # windows
      bind-key m new-window
      bind C-j previous-window
      bind C-k next-window
      bind-key C-a last-window # C-a C-a for last active window
      bind A command-prompt "rename-window %%"

      # use the vim motion keys to move between panes
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # Resizing
      bind-key C-h resize-pane -L 5
      bind-key C-j resize-pane -D 5
      bind-key C-k resize-pane -U 5
      bind-key C-l resize-pane -R 5

      # use vim motion keys while in copy mode
      setw -g mode-keys vi

      # layouts
      bind o select-layout 4582,187x95,0,0[187x69,0,0,0,187x25,0,70,23]
      bind C-r rotate-window
    '';
  };
}
