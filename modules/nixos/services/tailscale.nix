{ config, unstablePkgs, ... }: {
  services.tailscale = {
    enable = true;
    package = unstablePkgs.tailscale;
  };

  networking = {
    extraHosts = ''
      100.106.108.116 ndo4
      100.71.136.83   metrics
      100.101.46.98   nas
      100.121.243.103 ndo-mbp
      100.107.211.65  ndo-op9
      100.89.139.18   ndo-plex
      100.72.150.15   ndo2
      100.101.97.99   pve5
      100.87.42.40    tursteher
    '';
    firewall = {
      checkReversePath = "loose";
      allowedUDPPorts = [ config.services.tailscale.port ];
      trustedInterfaces = [ "tailscale0" ];
    };
  };
}
