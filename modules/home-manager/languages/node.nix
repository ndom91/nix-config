{ pkgs, inputs, lib, unstablePkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nodejs_22
    unstablePkgs.corepack_22
    unstablePkgs.bun
    openssl
    pkg-config

    # unstablePkgs.playwright
    unstablePkgs.playwright-driver
    unstablePkgs.playwright-test
    pkgs.prisma-engines
    vips # for sharp
  ];

  environment.variables = {
    # Prisma:
    PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
    PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
    PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
    PRISMA_ENGINES_CHECKSUM_IGNORE_MISSING = "1";

    # Playwright
    PLAYWRIGHT_BROWSERS_PATH = unstablePkgs.playwright-driver.browsers;
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = 1;
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };

  # Vite large project workarounds - https://vitejs.dev/guide/troubleshooting#requests-are-stalled-forever
  # See also: https://github.com/NixOS/nixpkgs/issues/159964#issuecomment-1252682060
  systemd.user.extraConfig = ''
    DefaultLimitNOFILE=524288
  '';
  systemd.extraConfig = ''
    DefaultLimitNOFILE=524288
  '';

  boot = {
    kernel.sysctl = {
      # Vite large project workarounds - https://vitejs.dev/guide/troubleshooting#requests-are-stalled-forever
      "fs.inotify.max_queued_events" = lib.mkForce 16384;
      "fs.inotify.max_user_instances" = lib.mkForce 8192;
      "fs.inotify.max_user_watches" = lib.mkForce 524288;
    };
  };
}
