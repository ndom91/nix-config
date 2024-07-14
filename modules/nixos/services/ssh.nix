{ config, ... }:
{
  users.users.ndo.openssh.authorizedKeys.keys = [
    (builtins.readFile (builtins.fetchurl {
      url = "https://github.com/ndom91.keys";
      sha256 = "PfSNkhnNXUR9BTD2+0An2ugQAv2eYipQOFxQ3j8XD5Y=";
    }))
  ];

  services.openssh = {
    enable = true;
    settings = {
      UseDns = true;
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };
}
