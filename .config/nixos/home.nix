{
  pkgs,
  vars,
  lib,
  ...
}:
let
  brave = (
    pkgs.brave.override {
      commandLineArgs = [
        "--force-device-scale-factor=1.25"
        # Get rid of weird tab scrolling
        "--enable-features=ScrollableTabStrip"
      ];
    }
  );
in
{
  imports = [ ./home-modules/plasma.nix ];

  home.username = "${vars.username}";
  home.homeDirectory = "/home/${vars.username}";

  home.stateVersion = "${vars.version}";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables.BROWSER = "brave";

  home.packages =
    with pkgs;
    let
      R = rWrapper.override { packages = with rPackages; [ languageserver ]; };
      rust = (
        rust-bin.stable.latest.default.override {
          extensions = [
            "rust-analyzer"
            "rust-src"
          ];
        }
      );
    in
    [
      (spotify.override { deviceScaleFactor = 1.5; })
      R
      basedpyright
      bat
      biome
      blesh
      brave
      ccache
      clang-tools
      cmake # for building Neovim
      cmake-language-server
      delta
      deno
      discord
      docker-compose
      emmet-language-server
      eza
      fastfetch
      firefox
      fswatch # faster file watching backend for LSP
      fzf
      gdb
      gettext # for building Neovim
      gh
      ghc
      ghostty
      go
      gopls
      haskell-language-server
      htop
      lua
      lua-language-server
      man-pages
      marksman
      nil
      ninja
      nixfmt-rfc-style
      nodePackages_latest.bash-language-server
      nodePackages_latest.typescript-language-server
      nodejs_22
      openconnect
      openssl
      pkg-config
      pnpm
      prettierd
      python3
      ripgrep
      ruff
      rust
      sd
      shellcheck
      shfmt
      stylua
      taplo
      tree-sitter
      typescript
      unzip
      vscode-langservers-extracted
      vtsls
      wget
      wl-clipboard
      xz
      yaml-language-server
      zig
      zip
      zls
    ];

  xdg.enable = true;

  xdg.mimeApps = rec {
    enable = true;
    associations.added = defaultApplications;
    defaultApplications =
      let
        imageViewer = "brave-browser.desktop";
        mediaPlayer = "brave-browser.desktop";
        documentViewer = "brave-browser.desktop";
        browser = "brave-browser.desktop";
        textEditor = "neovim.desktop";
      in
      {
        # Documents
        "application/pdf" = documentViewer;

        # Images
        "image/png" = imageViewer;
        "image/jpeg" = imageViewer;
        "image/gif" = imageViewer;
        "image/svg+xml" = imageViewer;
        "image/avif" = imageViewer;
        "image/jpg" = imageViewer;
        "image/pjpeg" = imageViewer;
        "image/tiff" = imageViewer;
        "image/webp" = imageViewer;
        "image/x-bmp" = imageViewer;
        "image/x-gray" = imageViewer;
        "image/x-icb" = imageViewer;
        "image/x-ico" = imageViewer;
        "image/x-png" = imageViewer;

        # Videos
        "video/webm" = mediaPlayer;
        "video/mp4" = mediaPlayer;
        "video/mkv" = mediaPlayer;

        # Text and code
        "text/english" = textEditor;
        "text/plain" = textEditor;
        "application/x-shellscript" = textEditor;

        # Web
        "text/html" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
      };
  };

  programs.chromium = {
    enable = true;
    package = brave;
    extensions = [
      { id = "cimiefiiaegbelhefglklhhakcgmhkai"; } # Plasma integration
      { id = "pncfbmialoiaghdehhbnbhkkgmjanfhe"; } # uBlacklist
      {
        # Bypass paywalls
        id = "dcpihecpambacapedldabdbpakmachpb";
        updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/src/updates/updates.xml";
      }
    ];
  };

  programs.bash = {
    enable = true;
    initExtra =
      (builtins.readFile ./home-modules/bash/bashrc)
      +
        # bash
        ''
          # Sourcery
          source "${pkgs.blesh}/share/blesh/ble.sh"
          source "${pkgs.git}/share/bash-completion/completions/git"
          __git_complete g __git_main
          __git_complete d __git_main
          __git_complete dots __git_main

          # Extra environment help
          export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig"
        '';
    profileExtra = builtins.readFile ./home-modules/bash/profile;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "bamboo_multiplex";
      italic-text = "always";
    };
  };

  xdg.configFile."bat/themes" = {
    recursive = true;
    source = ./home-modules/bat-themes;
    onChange = "${lib.getExe pkgs.bat} cache --build";
  };
}
