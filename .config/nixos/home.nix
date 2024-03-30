{ pkgs, ... }:
let
  brave = (pkgs.brave.override {
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

  home.packages = [ brave ];

  programs.chromium = {
    enable = true;
    package = brave;
    extensions = [
      # Plasma integration
      { id = "cimiefiiaegbelhefglklhhakcgmhkai"; }
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
