{ pkgs, ... }: {

  imports = [ ./home-modules/plasma.nix ];

  home.username = "rileyb";
  home.homeDirectory = "/home/rileyb";

  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs =
      [ "--ozone-platform-hint=auto" "--force-device-scale-factor=1.5" ];
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
