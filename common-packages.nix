{ pkgs, ... }:

with pkgs; [
  ## Unstable
  # TODO: Needs setup
  # unstable.neovim
  neovim

  # alejandra # nix code formatter
  coreutils
  difftastic
  docker-compose
  dua
  fd
  ffmpeg
  git
  htop
  ipmitool
  jq
  lm_sensors
  neofetch
  nmap
  ouch
  qemu
  ripgrep
  smartmontools
  # terraform
  tmux
  tree
  tree
  watch
  wget
]

# programs.neovim = {
  # enable = true;
  # defaultEditor = true;
# }
