{ inputs, osConfig, ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        StrictHostKeyChecking no
        SetEnv TERM=xterm-256color

      `$(cat "${osConfig.age.secrets.secret1.path}")`
    '';
  };
}
