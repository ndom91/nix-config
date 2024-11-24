{ lib, unstablePkgs, input }:
{
  # TODO: Import
  # https://github.com/kaylorben/nixcord
  programs.nixcord = {
    enable = true;
    # disable discord (enabled by default)
    discord = {
      enable = false;
      openASAR.enable = false;
      vencord = {
        enable = false;
        # still relevant for vesktop even if not enabled here
        package = unstablePkgs.vencord;
      };
    };
    # use vesktop instead (wayland optimized discord client)
    vesktop = {
      enable = true;
      package = unstablePkgs.vesktop;
    };

    config = {
      themeLinks = [
        "https://refact0r.github.io/midnight-discord/midnight.css"
      ];
      frameless = true;
      plugins = {
        fakeNitro.enable = true;
        callTimer.enable = true;
        friendsSince.enable = true;
        crashHandler.enable = true;
        volumeBooster.enable = true;
        notificationVolume.enable = true;
        webScreenShareFixes.enable = true;
      };
    };
  };
}
