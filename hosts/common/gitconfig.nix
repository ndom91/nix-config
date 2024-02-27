{ input, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "ndom91";
    userEmail = "yo@ndo.dev";
    signing = {
      key = "~/.ssh/id_ndo4.pub";
      signByDefault = true;
    };
    diff-so-fancy.enable = true;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "nvim";
        excludesfile = "~/.gitignore-global";
      };
      credential = {
        helper = "cache --timeout=360000";
      };
      merge = {
        conflictStyle = "zdiff3";
        tool = "nvim";
        # tool = "meld";
      };
      pull = {
        rebase = false;
        default = "current";
      };
      push = {
        default = "current";
        autoSetupRemote = true;
      };
      remote = {
        pushDefault = "origin";
      };
      branch = {
        autosetupmerge = "always";
        sort = "-committerdate";
      };
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      maintenance = {
        repo = "/opt/nextauthjs/next-auth";
      };
      gpg = {
        format = "ssh";
        # ssh = {
        # program = "/opt/1Password/op-ssh-sign";
        # };
      };
    };
  };
}
