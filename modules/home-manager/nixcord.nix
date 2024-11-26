{ inputs, config, unstablePkgs, pkgs, ... }:
{
  # TODO: Import
  # https://github.com/kaylorben/nixcord
  programs.nixcord = {
    enable = true;
    # disable discord (enabled by default)
    discord = {
      enable = false;
      openASAR.enable = false;
      vencord = {
        enable = false;
        # still relevant for vesktop even if not enabled here
        package = unstablePkgs.vencord;
      };
    };
    # use vesktop instead (wayland optimized discord client)
    vesktop = {
      enable = true;
      package = unstablePkgs.vesktop;
    };

    config = {
      themeLinks = [
        "https://refact0r.github.io/midnight-discord/flavors/midnight-catppuccin-mocha.theme.css"
      ];
      frameless = true;
      plugins = {
        alwaysTrust.enable = true;
        betterFolders.enable = true;
        betterUploadButton.enable = true;
        callTimer.enable = true;
        clearURLs.enable = true;
        copyFileContents.enable = true;
        crashHandler.enable = true;
        fakeNitro.enable = true;
        favoriteEmojiFirst.enable = true;
        friendsSince.enable = true;
        fullSearchContext.enable = true;
        gifPaste.enable = true;
        imageZoom.enable = true;
        imageLink.enable = true;
        memberCount.enable = true;
        mentionAvatars.enable = true;
        messageLinkEmbeds.enable = true;
        noDevtoolsWarning.enable = true;
        noServerEmojis = {
          enable = true;
          shownEmojis = "currentServer";
        };
        noScreensharePreview.enable = true;
        noTypingAnimation.enable = true;
        onePingPerDM.enable = true;
        platformIndicators.enable = true;
        previewMessage.enable = true;
        readAllNotificationsButton.enable = true;
        serverInfo.enable = true;
        serverListIndicators.enable = true;
        shikiCodeblocks = {
          enable = true;
          tryHljs = true;
        };
        showAllMessageButtons.enable = true;
        showHiddenChannels.enable = true;
        showMeYourName.enable = true;
        silentTyping.enable = true;
        unsuppressEmbeds.enable = true;
        voiceChatDoubleClick.enable = true;
        vencordToolbox.enable = true;
        unindent.enable = true;
        webKeybinds.enable = true;
        whoReacted.enable = true;
        # volumeBooster.enable = true;
        # notificationVolume.enable = true;
        webScreenShareFixes.enable = true;
      };
    };
  };
}
