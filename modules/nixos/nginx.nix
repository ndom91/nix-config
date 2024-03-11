{ inputs, pkgs, ... }:
{
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."db.puff.lan" = {
      listen = [{
        port = 5432;
      }];
      upstreams = {
        docker-postgres = {
          servers = {
            "docker-pi.puff.lan:5432" = { };
          };
        };
      };
      locations."/" = {
        proxyPass = "docker-postgres";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "yo@ndo.dev";
  };
}
