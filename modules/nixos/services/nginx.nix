{ inputs, pkgs, ... }:
{
  services.nginx = {
    enable = true;

    recommendedOptimisation = true;
    # recommendedGzipSettings = true;
    # recommendedProxySettings = true;
    # recommendedTlsSettings = true;

    streamConfig = ''
      server {
        listen 127.0.0.1:5432;
        proxy_connect_timeout 60s;
        proxy_socket_keepalive on;
        proxy_pass 10.0.0.25:5432;
      }
    '';

    # upstreams = {
    #   dockerPostgres = {
    #     servers = {
    #       "docker-pi.puff.lan:5432" = {
    #         extraConfig = ''
    #           proxy_connect_timeout 60s;
    #           proxy_socket_keepalive on;
    #         '';
    #       };
    #     };
    #   };
    # };

    # virtualHosts."db.puff.lan" = {
    #   listen = [{
    #     addr = "127.0.0.1";
    #     port = 5432;
    #   }];
    #   locations."/" = {
    #     proxyPass = "dockerPostgres";
    #   };
    # };
  };

  # Unnecessary for local domains
  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "yo@ndo.dev";
  # };
}
