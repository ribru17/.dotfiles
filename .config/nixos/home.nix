{ pkgs, ... }:
let
  brave = (pkgs.brave.override {
    # NOTE: Enable this bad boy to get rid of weird tab scrolling:
    # brave://flags/#scrollable-tabstrip
    commandLineArgs = [ "--force-device-scale-factor=1.5" ];
  });
in {
  imports = [ ./home-modules/plasma.nix ];

  home.username = "rileyb";
  home.homeDirectory = "/home/rileyb";

  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables.BROWSER = "brave";

  home.packages = with pkgs; [
    bat
    bibata-cursors
    blesh
    brave
    clang-tools
    delta
    deno
    emmet-language-server
    fastfetch
    firefox
    gopls
    lua-language-server
    marksman
    nil
    nixfmt
    nodePackages_latest.bash-language-server
    nodePackages_latest.typescript-language-server
    nodePackages_latest.vscode-css-languageserver-bin
    nodejs_21
    prettierd
    python311Packages.pycodestyle
    python311Packages.pyflakes
    python311Packages.python-lsp-server
    python311Packages.yapf
    ripgrep
    shellcheck
    shfmt
    stylua
    typescript
    unzip
    wget
    wl-clipboard
    xz
  ];

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
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark reader
    ];
  };

  programs.bash = {
    enable = true;
    initExtra = (builtins.readFile ./home-modules/bash/.bashrc) + ''
      source "${pkgs.git}/share/bash-completion/completions/git"
      __git_complete g __git_main
      __git_complete d __git_main
      __git_complete dots __git_main
    '';
    profileExtra = builtins.readFile ./home-modules/bash/.profile;
  };
}
