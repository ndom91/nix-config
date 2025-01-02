{ pkgs, input, ... }:
{
  environment.systemPackages = with pkgs; [
    python312Full
    python312Packages.requests
    python312Packages.libtmux
    python312Packages.pip
    python312Packages.pipx
  ];
}
