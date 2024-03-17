{ unstablePkgs, ... }:
{
  home.file.".dotfiles/colorscripts/" = {
    source = ../../dotfiles/colorscripts;
    recursive = true;
  };

  home.shellAliases = {
    # nix
    nclean = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +3";
    nrebuild = "sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)";
    nswitch = "nh os switch";
    ndiff = "nix store diff-closures $(ls -d  /nix/var/nix/profiles/* | tail -2 | awk '{ print $1 }')";
    nhistory = "nix profile diff-closures --profile /nix/var/nix/profiles/system";
    nvddiff = "nvd diff $(ls -d  /nix/var/nix/profiles/system-*-link | tail -2 | awk '{ print $1 }' | xargs)";
    nupdate = "nix flake lock --update-input ";
    # nix hm
    hmswitch = "home-manager switch --flake /etc/nixos";
    "," = "comma";

    # Nix stuff. Inspired by: 
    # - https://alexfedoseev.com/blog/post/nix-time.
    # - https://github.com/the-nix-way/nome

    # Direnv helpers
    da = "direnv allow";
    dr = "direnv reload";
    dk = "direnv revoke";

    # Run Nix garbage collection
    xgc = "nix store gc -v";

    # Nix flake helpers
    nfc = "nix flake check";
    nfca = "nix flake check --all-systems";
    nfs = "nix flake show";
    nfu = "nix flake update";
    ndc = "nix develop --command";
    nsn = "nix search nixpkgs";

    # coreutils
    ll = "eza --icons -l -a --group-directories-first --time-style long-iso --classify --group --git";
    ls = "eza --icons --group-directories-first --classify";
    tree = "eza --long --tree --time-style long-iso --icons --group";

    # Commands
    vim = "nvim";
    lg = "lazygit";
    hn = "hostname";
    topfolders = "sudo du -hs * | sort -rh | head -5";
    topfiles = "sudo find -type f -exec du -Sh {} + | sort -rh | head -n 5";
    emptytrash = "rm -rf ~/.local/share/Trash/*";
    tb = "nc termbin.com 9999";
    hibernate = "echo disk > sudo /sys/power/state";
    nightmode = "echo 900 > /sys/class/backlight/intel_backlight/brightness > /dev/null & sct 3100 > /dev/null";
    daymode = "echo 3000 > /sys/class/backlight/intel_backlight/brightness > /dev/null & sct 4500 > /dev/null";
    xc = "wl-copy";
    # vivaldi = "${unstablePkgs.vivaldi}/bin/vivaldi --disable-vulkan-surface --use-gl=angle --use-angle=gl --ignore-gpu-blacklist --enable-gpu-rasterization --enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoDecoder,VaapiVideoEncoder,RawDraw,CanvasOopRasterization --enable-gpu-rasterization --enable-zero-copy --enable-hardware-overlays --enable-native-gpu-memory-buffers --enable-webrtc-pipewire-capturer";

    # Git
    gs = "git status";
    gss = "git status --short";
    gd = "git diff";
    gp = "git pull";
    gl = "git log --oneline --color | emojify | most";
    g = "git";
    gpb = "git push origin `git rev-parse --abbrev-ref HEAD`";
    gpl = "git pull origin `git rev-parse --abbrev-ref HEAD`";
    glb = "git checkout $(git for-each-ref --sort=-committerdate --count=20 --format=\"%(refname:short)\" refs/heads/ | gum filter --reverse)";
    ds = "dot status";
    ddi = "dot diff";
    gitroot = "cd \"$(git rev-parse --show-toplevel)\"";

    #### TYPOS ####
    sduo = "sudo";
    udso = "sudo";
    suod = "sudo";
    sodu = "sudo";

    whcih = "which";
    whchi = "which";
    wchih = "which";

    # CD
    "cd." = "cd ..";
    "cd.." = "cd ..";
    ".." = "cd ..";
    "..." = "cd ../../";
    "...." = "cd ../../../";
    "....." = "cd ../../../../";
    ".4" = "cd ../../../../../";
    ".5" = "cd ../../../../../../";

    # Projects
    na = "cd /opt/nextauthjs/next-auth/";
    sk = "cd /opt/ndomino/sveltekasten";
    skd = "cd /opt/ndomino/sveltekasten-docs";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less -R";
    READER = "zathura";
    BROWSER = "vivaldi";
    VIDEO = "vlc";
    RIPGREP_CONFIG_PATH = "$HOME/.ripgreprc";
    CARGO_NET_GIT_FETCH_WITH_CLI = "true";

    # History
    HISTCONTROL = "erasedups:ignoreboth";
    HISTIGNORE = "ls:bg:fg:history:clear:exit";
    HISTTIMEFORMAT = "%F %T ";

    # Npm
    NPM_CONFIG_EDITOR = "$EDITOR";
    NPM_CONFIG_INIT_AUTHOR_NAME = "ndom91";
    NPM_CONFIG_INIT_AUTHOR_EMAIL = "yo@ndo.dev";
    NPM_CONFIG_INIT_AUTHOR_URL = "https://ndo.dev";
    NPM_CONFIG_INIT_LICENSE = "MIT";
    NPM_CONFIG_INIT_VERSION = "0.0.1";
    NPM_CONFIG_PROGRESS = "true";
    NPM_CONFIG_SAVE = "true";
  };

  programs.bat.enable = true;
  # programs.bat.theme = "Coldark-Dark";

  programs.bash.initExtra = ''
    if [ -f "$HOME/.dotfiles/colorscripts/blocks.sh" ]; then
      "$HOME/.dotfiles/colorscripts/blocks.sh"
    fi
    # PNPM
    if [ -d "$HOME/.pnpm-global" ]; then
      export PATH="$HOME/.pnpm-global:$PATH"
      export PNPM_HOME="$HOME/.pnpm-global"
    fi

    # BUN
    if [ -f "$HOME/.bun/bin/bun" ]; then
      export BUN_INSTALL="$HOME/.bun"
      export PATH="$BUN_INSTALL/bin:$PATH"
    fi

    # rust
    if [ "$(command -v cargo)" ]; then
      export PATH="$HOME/.cargo/bin:$PATH"
    fi

    # fnm
    if [ "$(command -v fnm)" ]; then
      eval "$(fnm env --shell bash --use-on-cd --version-file-strategy recursive)"      eval "$(fnm env --use-on-cd --version-file-strategy recursive)"
    fi

    # AWS
    export AWS_DEFAULT_REGION=eu-central-1
    export AWS_REGION=eu-central-1

    nix-clean () {
      nix-env --delete-generations old
      nix-store --gc
      # nix-channel --update
      # nix-env -u --always
      # for link in /nix/var/nix/gcroots/auto/*
      # do
        # rm $(readlink "$link")
      # done
      nix-collect-garbage -d
    }
    
    # Suppress direnv log output (which is super verbose and not that useful)
    # export DIRENV_LOG_FORMAT=
  '';
}

