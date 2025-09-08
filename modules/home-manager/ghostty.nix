{ lib, inputs, pkgs, ... }:
let
  # Required until this is fixed upstream: https://github.com/ghostty-org/ghostty/discussions/7356
  # ghosttyPatched = inputs.ghostty.packages.x86_64-linux.default.overrideAttrs (drv: {
  #   patches = drv.patches or [ ] ++ [
  #     (pkgs.fetchpatch {
  #       url = "https://github.com/Opposite34/ghostty/commit/5b871c595254eece6bf44ab48f71409b7ed36088.patch";
  #       hash = "sha256-hCWp2MdoD89oYN3I+Pq/HW4k4RcozS1tDuXHO3Nd+Y8=";
  #     })
  #   ];
  # });
in
{
  home.packages = with pkgs; [
    ghostty
  ];

  xdg.desktopEntries."com.mitchellh.ghostty" = {
    name = "Ghostty";
    genericName = "Terminal";
    comment = "Modern terminal for the desktop";
    # Run Ghostty with the env var set
    exec = "env GDK_BACKEND=x11 ${lib.getExe pkgs.ghostty}";
    terminal = false;
    type = "Application";
    icon = "com.mitchellh.ghostty";
    categories = [ "Utility" "TerminalEmulator" ];
    # If you like, you can pass extra keys under `settings`:
    # settings = { StartupWMClass = "ghostty"; };
  };

  xdg.configFile."ghostty/config" = {
    force = true;
    source = ../../dotfiles/ghostty.conf;
  };
}
