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
    # difftastic.enable = true;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      column = {
        ui = "auto";
      };
      core = {
        editor = "nvim";
        excludesfile = "~/.gitignore-global";
      };
      credential = {
        helper = "cache --timeout=360000";
      };
      help = {
        autocorrect = "prompt";
      };
      merge = {
        conflictStyle = "zdiff3";
        tool = "nvim";
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      status = {
        short = true;
        branch = true;
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      remote = {
        pushDefault = "origin";
      };
      commit = {
        verbose = true;
      };
      branch = {
        autoSetupMerge = "simple";
        sort = "-committerdate";
      };
      tag = {
        sort = "version:refname";
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
