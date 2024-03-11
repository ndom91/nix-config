{ inputs, ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        StrictHostKeyChecking no
        SetEnv TERM=xterm-256color
    '';
    matchBlocks = {
      github.com = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ndo4";
      };
      ndo2 = {
        hostname = "ndo2.puff.lan";
        user = "ndo";
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
      hassio = {
        hostname = "hassio.puff.lan";
        user = "ndo";
        identityFile = "~/.ssh/id_ndo4";
      };
      usbx = {
        hostname = "netbox.puff.lan";
        user = "ndo";
        identityFile = "~/.ssh/id_ndo4";
      };
      netbox = {
        hostname = "netbox.puff.lan";
        user = "ndo";
        identityFile = "~/.ssh/id_ndo4";
      };
      paperless = {
        hostname = "paperless.puff.lan";
        user = "ndo";
        identityFile = "~/.ssh/id_ndo4";
      };
      zuhalter = {
        hostname = "zuhalter.puff.lan";
        user = "ndo";
        identityFile = "~/.ssh/id_ndo4";
      };
    };
  };
}
