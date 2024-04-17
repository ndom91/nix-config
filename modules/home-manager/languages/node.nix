{ pkgs, input, unstablePkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_20
    unstablePkgs.nodePackages.pnpm
    unstablePkgs.bun
    openssl
    pkg-config
    unstablePkgs.playwright-driver
    vips # for sharp
    unstablePkgs.prisma-engines
    unstablePkgs.chromium
  ];

  programs.bash.sessionVariables = {
    # Prisma:
    PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
    PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
    PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
    PRISMA_ENGINES_CHECKSUM_IGNORE_MISSING = "1";

    # Playwright
    PLAYWRIGHT_BROWSERS_PATH = unstablePkgs.playwright-driver.browsers;
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = true;
  };
}
