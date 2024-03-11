{ inputs, config, ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        StrictHostKeyChecking no
        SetEnv TERM=xterm-256color
    '';
    matchBlocks = config.age.secrets.secret1.path;
  };
}
