{ pkgs, input, ... }:
{
  environment.systemPackages = with pkgs; [
    # python312Full
    python313Packages.requests
    python313Packages.libtmux
    python313Packages.pip
    python313Packages.pipx

    python313Packages.uv
  ];
}
