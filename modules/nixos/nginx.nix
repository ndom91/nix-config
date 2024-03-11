{ inputs, pkgs, ... }:
{
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    upstreams = {
      docker-postgres = {
        servers = {
          "docker-pi.puff.lan:5432" = { };
        };
      };
    };

    virtualHosts."db.puff.lan" = {
      listen = [{
        addr = "127.0.0.1";
        port = 5432;
      }];
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
