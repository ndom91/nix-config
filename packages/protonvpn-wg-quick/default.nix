# https://github.com/emmanuelrosa/erosanix/blob/master/modules/protonvpn.nix
{ config, pkgs, lib, ... }: with lib;
let
  cfg = config.services.protonvpn;
in
{
  options = {
    services.protonvpn = {
      enable = mkEnableOption "Enable ProtonVPN (using Wireguard).";

      autostart = mkOption {
        default = true;
        example = "true";
        type = types.bool;
        description = "Automatically set up ProtonVPN when NixOS boots.";
      };

      interface = {
        name = mkOption {
          default = "wg0";
          example = "wg0";
          type = types.str;
          description = "The name of the Wireguard network interface to create. Go to https://account.protonmail.com/u/0/vpn/WireGuard to create a Linux Wireguard certificate and download it. You'll need it's content to set the options for this module.";
        };

        ip = mkOption {
          default = "10.2.0.2/32";
          example = "10.2.0.2/32";
          type = types.str;
          description = "The IP address of the interface. See your Wireguard certificate.";
        };

        port = mkOption {
          default = 51820;
          example = 51820;
          type = types.port;
          description = "The port number of the interface.";
        };

        privateKeyFile = mkOption {
          example = "/root/secrets/protonvpn";
          type = types.path;
          description = "The path to a file containing the private key for this interface/peer. Only root should have access to the file. See your Wireguard certificate.";
        };

        dns = {
          enable = mkOption {
            default = true;
            example = "true";
            type = types.bool;
            description = "Enable the DNS provided by ProtonVPN";
          };

          ip = mkOption {
            default = "10.2.0.1";
            example = "10.2.0.1";
            type = types.str;
            description = "The IP address of the DNS provided by the VPN. See your Wireguard certificate.";
          };
        };
      };

      endpoint = {
        publicKey = mkOption {
          example = "23*********************************************=";
          type = types.str;
          description = "The public key of the VPN endpoint. See your Wireguard certificate.";
        };

        ip = mkOption {
          example = "48.1.3.4";
          type = types.str;
          description = "The IP address of the VPN endpoint. See your Wireguard certificate.";
        };

        port = mkOption {
          default = 51820;
          example = 51820;
          type = types.port;
          description = "The port number of the VPN peer endpoint. See your Wireguard certificate.";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    networking.wg-quick.interfaces."${cfg.interface.name}" = {
      autostart = cfg.autostart;
      dns = if cfg.interface.dns.enable then [ cfg.interface.dns.ip ] else [ ];
      privateKeyFile = cfg.interface.privateKeyFile;
      address = [ cfg.interface.ip ];
      listenPort = cfg.interface.port;

      peers = [
        {
          publicKey = cfg.endpoint.publicKey;
          # allowedIPs = [ "0.0.0.0/0" "::/0" ];
          allowedIPs = [ "0.0.0.0/5" "8.0.0.0/7" "10.0.4.0/22" "10.0.8.0/21" "10.0.16.0/20" "10.0.32.0/19" "10.0.64.0/18" "10.0.128.0/17" "10.1.0.0/16" "10.2.0.0/15" "10.4.0.0/14" "10.8.0.0/15" "10.10.1.0/24" "10.10.2.0/23" "10.10.4.0/22" "10.10.8.0/21" "10.10.16.0/20" "10.10.32.0/19" "10.10.64.0/18" "10.10.128.0/17" "10.11.0.0/16" "10.12.0.0/14" "10.16.0.0/12" "10.32.0.0/11" "10.64.0.0/10" "10.128.0.0/9" "11.0.0.0/8" "12.0.0.0/6" "16.0.0.0/4" "32.0.0.0/3" "64.0.0.0/3" "96.0.0.0/6" "100.0.0.0/10" "100.128.0.0/9" "101.0.0.0/8" "102.0.0.0/7" "104.0.0.0/5" "112.0.0.0/4" "128.0.0.0/1" ];
          endpoint = "${cfg.endpoint.ip}:${builtins.toString cfg.endpoint.port}";
        }
      ];
    };
  };

  meta.maintainers = with maintainers; [ emmanuelrosa ];
}
