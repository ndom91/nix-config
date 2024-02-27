{ inputs, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        StrictHostKeyChecking no
        SetEnv TERM=xterm-256color
    '';
    matchBlocks = {
      ndo2 = {
        hostname = "ndo2.puff.lan";
        user = "ndo";
        # identityFile = "${inputs.id_rsa}";
        identityFile = "~/.ssh/id_ndo4";
      };
      ndo4 = {
        hostname = "ndo4.puff.lan";
        user = "ndo";
        identityFile = "~/.ssh/id_ndo4";
      };
      tursteher = {
        hostname = "tursteher.puff.lan";
        user = "ndo";
        identityFile = "~/.ssh/id_ndo4";
      };
    };
  };
}
