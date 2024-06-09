{ inputs, pkgs, config, ... }:
let

  wgIfaceName = "pvpn-wg-nl256";
  # This peer's IPv4 and IPv6 addresses
  wgIpv4 = "10.2.0.2";
  wgIpv6 = "1:2:3:4::";

  # Variables controlling connection marks and routing tables IDs. You probably
  # don't need to touch this.
  wgFwMark = 4242;
  wgTable = 4000;
in
{
  # DNS is required if the Wireguard endpoint is a hostname.
  # networking.nameservers = [
  #   "1.1.1.1"
  #   "9.9.9.9"
  # ];
  services.resolved.enable = true;

  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    netdevs."15-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = wgIfaceName;
        MTUBytes = "1420";
      };
      wireguardConfig = {
        PrivateKeyFile = config.age.secrets.pvpn.path;
        FirewallMark = wgFwMark;
        RouteTable = "off";
      };
      wireguardPeers = [
        {
          wireguardPeerConfig = {
            PublicKey = "Zee6nAIrhwMYEHBolukyS/ir3FK76KRf0OE8FGtKUnI=";
            AllowedIPs = [ "0.0.0.0/5" "8.0.0.0/7" "10.0.4.0/22" "10.0.8.0/21" "10.0.16.0/20" "10.0.32.0/19" "10.0.64.0/18" "10.0.128.0/17" "10.1.0.0/16" "10.2.0.0/15" "10.4.0.0/14" "10.8.0.0/15" "10.10.1.0/24" "10.10.2.0/23" "10.10.4.0/22" "10.10.8.0/21" "10.10.16.0/20" "10.10.32.0/19" "10.10.64.0/18" "10.10.128.0/17" "10.11.0.0/16" "10.12.0.0/14" "10.16.0.0/12" "10.32.0.0/11" "10.64.0.0/10" "10.128.0.0/9" "11.0.0.0/8" "12.0.0.0/6" "16.0.0.0/4" "32.0.0.0/3" "64.0.0.0/3" "96.0.0.0/6" "100.0.0.0/10" "100.128.0.0/9" "101.0.0.0/8" "102.0.0.0/7" "104.0.0.0/5" "112.0.0.0/4" "128.0.0.0/1" ];

            Endpoint = "77.247.178.58:51820";
            # PersistentKeepalive = 25;
            RouteTable = "off";
          };
        }
      ];
    };
    networks."15-wg0" = {
      matchConfig.Name = wgIfaceName;
      # Set to this peer's assigned Wireguard address
      address = [
        "${wgIpv4}/32"
        # "${wgIpv6}/128"
      ];
      networkConfig = {
        # If DNS requests should go to a specific nameserver when the tunnel is
        # established, uncomment this line and set it to the address of that
        # nameserver. But see the note at the bottom of this page.
        DNS = "10.2.0.1";
        DNSDefaultRoute = "yes";

        # for networkd >= 244 KeepConfiguration stops networkd from
        # removing routes on this interface when restarting
        KeepConfiguration = "yes";
        IPv6AcceptRA = false;
      };
      routingPolicyRules = [
        {
          routingPolicyRuleConfig = {
            Family = "both";
            Table = "main";
            SuppressPrefixLength = 0;
            Priority = 10;
          };
        }
        {
          routingPolicyRuleConfig = {
            Family = "both";
            InvertRule = true;
            FirewallMark = wgFwMark;
            Table = wgTable;
            Priority = 11;
          };
        }
      ];
      routes = [
        {
          routeConfig = {
            Destination = "0.0.0.0/0";
            Table = wgTable;
            Scope = "link";
          };
        }
        # {
        #   routeConfig = {
        #     Destination = "::/0";
        #     Table = wgTable;
        #     Scope = "link";
        #   };
        # }
      ];
      linkConfig = {
        ActivationPolicy = "manual";
        RequiredForOnline = false;
      };
    };
  };

  networking.nftables = {
    enable = true;
    ruleset = ''
      table inet wg-wg0 {
        chain preraw {
          type filter hook prerouting priority raw; policy accept;
          iifname != "${wgIfaceName}" ip daddr ${wgIpv4} fib saddr type != local drop
        }
        chain premangle {
          type filter hook prerouting priority mangle; policy accept;
          meta l4proto udp meta mark set ct mark
        }
        chain postmangle {
          type filter hook postrouting priority mangle; policy accept;
          meta l4proto udp meta mark ${toString wgFwMark} ct mark set meta mark
        }
      }
    '';
    # iifname != "wg0" ip6 daddr ${wgIpv6} fib saddr type != local drop
  };
}
