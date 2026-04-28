{ config, pkgs, ... }:
{
  home.username = "logan";
  home.homeDirectory = "/home/logan";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  # PACKAGES
  home.packages = with pkgs; [
    # Shell tools
    eza
    fzf
    btop
    fastfetch

    # Apps
    ghostty
    firefox-devedition
    zed-editor
    _1password-gui
    _1password-cli

    # Utils
    wl-clipboard
    networkmanagerapplet
  ];

  # ZSH
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
      extended = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git" "sudo" "extract" "colored-man-pages"
        "command-not-found" "safe-paste" "history" "fzf"
      ];
    };

    shellAliases = {
      c = "clear";
      l = "eza -lh --icons=auto";
      ls = "eza -1 --icons=auto";
      ll = "eza -lha --icons=auto --sort=name --group-directories-first";
      ld = "eza -lhD --icons=auto";
      lt = "eza --icons=auto --tree";
      ".." = "cd ..";
      "..." = "cd ../..";
      ".3" = "cd ../../..";
      ".4" = "cd ../../../..";
      vc = "zed";
    };

    initContent = ''
      bindkey '^R' history-incremental-search-backward
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
    '';
  };

  # STARSHIP
  programs.starship.enable = true;

  # FZF
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # ENV VARS
  home.sessionVariables = {
    EDITOR = "zed";
    BROWSER = "firefox-devedition";
    TERMINAL = "ghostty";
  };
}
