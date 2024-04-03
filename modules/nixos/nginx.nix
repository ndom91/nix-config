{ inputs, pkgs, ... }:
{
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    upstreams = {
      dockerPostgres = {
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
        proxyPass = "dockerPostgres";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "yo@ndo.dev";
  };
}
