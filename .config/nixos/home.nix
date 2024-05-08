{ pkgs, vars, lib, ... }:
let
  brave = (pkgs.brave.override {
    commandLineArgs = [
      "--force-device-scale-factor=1.5"
      # Get rid of weird tab scrolling
      "--enable-features=ScrollableTabStrip"
    ];
  });
  appId = "org.kde.plasma.browser_integration.json";
  source =
    "${pkgs.kdePackages.plasma-browser-integration}/etc/chromium/native-messaging-hosts/${appId}";
in {
  imports = [ ./home-modules/plasma.nix ];

  home.username = "${vars.username}";
  home.homeDirectory = "/home/${vars.username}";

  home.stateVersion = "${vars.version}";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables.BROWSER = "brave";

  home.packages = with pkgs;
    let
      R = rWrapper.override { packages = with rPackages; [ languageserver ]; };
      rust = (rust-bin.stable.latest.default.override {
        extensions = [ "rust-analyzer" "rust-src" ];
      });
    in [
      (spotify.override { deviceScaleFactor = 1.5; })
      R
      bat
      betterdiscordctl # install with `betterdiscordctl install`
      blesh
      brave
      ccache
      clang-tools
      cmake # for building Neovim
      delta
      deno
      discord
      emmet-language-server
      eza
      fastfetch
      firefox
      gettext # for building Neovim
      gh
      ghc
      rust
      go
      gopls
      haskell-language-server
      lua
      lua-language-server
      marksman
      nil
      ninja
      nixfmt-classic
      nodePackages_latest.bash-language-server
      nodePackages_latest.typescript-language-server
      nodejs_22
      prettierd
      python3
      python311Packages.pycodestyle
      python311Packages.pyflakes
      python311Packages.python-lsp-server
      python311Packages.yapf
      ripgrep
      sd
      shellcheck
      shfmt
      stylua
      tree-sitter
      typescript
      unzip
      vscode-langservers-extracted
      wget
      wl-clipboard
      xz
    ];

  xdg.enable = true;

  # Browser integration
  xdg.configFile."BraveSoftware/Brave-Browser/NativeMessagingHosts/${appId}".source =
    source;

  xdg.mimeApps = rec {
    enable = true;
    associations.added = defaultApplications;
    defaultApplications = let
      imageViewer = "brave-browser.desktop";
      mediaPlayer = "brave-browser.desktop";
      documentViewer = "brave-browser.desktop";
      browser = "brave-browser.desktop";
      textEditor = "neovim.desktop";
    in {
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
      {
        # Bypass paywalls
        id = "dcpihecpambacapedldabdbpakmachpb";
        updateUrl =
          "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/src/updates/updates.xml";
      }
      {
        # Vimium
        id = "dbepggeogbaibhgnhhndojpepiihcmeb";
        # Mappings:
        # map <c-h> previousTab
        # map <c-H> moveTabLeft
        # map <c-L> moveTabRight
        # map <c-l> nextTab
        # map :q<enter> removeTab
      }
    ];
  };

  programs.bash = {
    enable = true;
    initExtra = (builtins.readFile ./home-modules/bash/bashrc) +
      # bash
      ''
        # Sourcery
        source "${pkgs.blesh}/share/blesh/ble.sh"
        source "${pkgs.git}/share/bash-completion/completions/git"
        __git_complete g __git_main
        __git_complete d __git_main
        __git_complete dots __git_main
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
