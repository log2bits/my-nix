{ config, pkgs, ... }:
{
  home.username = "logan";
  home.homeDirectory = "/home/logan";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # CATPPUCCIN (user-level)
  catppuccin = {
    enable = true;
    firefox.enable = false;
    flavor = "mocha";
    accent = "mauve";
  };

  # GTK apps
  gtk = {
    enable = true;
    theme = {
      name = "Breeze";
    };
  };

  # PACKAGES
  home.packages = with pkgs; [
    # Shell tools
    eza
    btop
    fastfetch

    # Apps
    firefox-devedition
    zed-editor
    _1password-gui
    _1password-cli
    discord

    # Utils
    wl-clipboard
    networkmanagerapplet
    kdePackages.isoimagewriter
    pciutils
    woeusb-ng
    ntfs3g
    iw

    # Gaming
    steam

    # KDE theming
    (pkgs.catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "mauve" ];
    })
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

  # GHOSTTY
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "Maple Mono NF";
      font-size = 11;
      window-padding-x = 6;
    };
  };

  # ZED
  home.file.".config/zed/settings.json".text = ''
    {
      "theme": "Catppuccin Mocha",
      "buffer_font_family": "Maple Mono NF",
      "buffer_font_size": 14,
      "ui_font_family": "Maple Mono NF",
      "ui_font_size": 14
    }
  '';

  # ENV VARS
  home.sessionVariables = {
    EDITOR = "zed";
    BROWSER = "firefox-devedition";
    TERMINAL = "ghostty";
  };

  programs.btop = {
    enable = true;
  };
}
