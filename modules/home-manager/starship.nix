{ lib, input, unstablePkgs, ... }:
{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$nodejs"
        "$python"
        "$nix_shell"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      nix_shell = {
        format = "❄️ ";
      };

      directory = {
        truncation_length = 2;
        truncate_to_repo = false;
        style = "#d5a8e3";
      };

      character = {
        success_symbol = "[▲](bright-pink)";
        error_symbol = "[▼](bright-red)";
        vicmd_symbol = "[❮](green)";
      };

      git_branch = {
        format = "[$branch]($style)";
        style = "#4C566A";
      };

      git_status = {
        # format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)"
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind)]($style)";
        style = "cyan";
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };

      git_state = {
        format = "([ $state ($progress_current/$progress_total) ] ($style)) ";
        style = "black";
      };

      cmd_duration = {
        format = " [$duration]($style) ";
        style = "yellow";
      };

      python = {
        format = "[$virtualenv]($style) ";
        style = "bright-black";
      };

      nodejs = {
        format = "[$symbol($version)]($style) ";
        style = "#88C0D0";
        version_format = "\${raw}";
      };

      aws = {
        disabled = true;
      };

      terraform = {
        disabled = true;
      };
    };
  };
}
