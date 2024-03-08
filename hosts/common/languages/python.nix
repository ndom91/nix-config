{ pkgs, input, ... }:
{
  environment.systemPackages = with pkgs; [
    python311Full
    python311Packages.requests
    python311Packages.libtmux
    python311Packages.pip
    python311Packages.pipx
  ];
}
