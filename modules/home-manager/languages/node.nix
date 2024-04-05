{ pkgs, input, unstablePkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_20
    unstablePkgs.nodePackages.pnpm
    unstablePkgs.bun
    openssl
    pkg-config
    vips # for sharp
    unstablePkgs.prisma-engines
    unstablePkgs.chromium
  ];

  # Prisma:
  programs.bash.sessionVariables.PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
  programs.bash.sessionVariables.PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
  programs.bash.sessionVariables.PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
  programs.bash.sessionVariables.PRISMA_ENGINES_CHECKSUM_IGNORE_MISSING = "1";
}
