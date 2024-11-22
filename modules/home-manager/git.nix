{ input, ... }:
{
  programs.gh.enable = true;
  programs.git = {
    enable = true;
    userName = "ndom91";
    userEmail = "yo@ndo.dev";
    signing = {
      key = "~/.ssh/id_ndo4.pub";
      signByDefault = true;
    };
    aliases = {
      pr = "pull --rebase";
    };
    difftastic.enable = true;
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
      };
      status = {
        short = true;
        branch = true;
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
        autoSetupMerge = "simple";
        sort = "-committerdate";
      };
      # url = {
      #   "git@github.com:" = {
      #     insteadOf = "https://github.com/";
      #   };
      # };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      maintenance = {
        repo = "/opt/nextauthjs/next-auth";
      };
      checkout = { defaultRemote = "origin"; };
      protocol = { version = 2; };
      gpg = {
        format = "ssh";
        # ssh = {
        # program = "/opt/1Password/op-ssh-sign";
        # };
      };
    };
  };
}
