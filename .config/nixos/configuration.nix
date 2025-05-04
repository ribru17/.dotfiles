# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  inputs,
  vars,
  pkgs-iosevka-pin,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Always keep at least the last 3 profiles
  boot.loader.systemd-boot.configurationLimit = 3;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # For Neovim: `:h fswatch-limitations`
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 100000;
    "fs.inotify.max_queued_events" = 100000;
    # For debugging
    "kernel.yama.ptrace_scope" = 0;
  };

  # Hibernation using swapfile, 32GB
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];
  # See https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Acquire_swap_file_offset
  boot.kernelParams = [ "resume_offset=26255360" ];
  # Taken from hardware-configuration.nix
  boot.resumeDevice = "/dev/disk/by-uuid/020a6932-aa44-4c98-afae-84438b8b6ef9";
  systemd.sleep.extraConfig = "HibernateDelaySec=30m";

  # Prevent "too many open files" errors, see the following help thread:
  # https://discourse.nixos.org/t/unable-to-fix-too-many-open-files-error/27094/7
  systemd.extraConfig = "DefaultLimitNOFILE=1048576";

  networking.hostName = "${vars.hostname}";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Basic system libraries commonly needed
      stdenv.cc.cc.lib
      zlib
      openssl

      # Node.js related dependencies that might be needed
      nodejs
      # Add more libraries if needed after testing
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha";
    # BUG: Not working when setting a custom theme?
    settings.Theme.CursorTheme = "Bibata-Modern-Ice";
  };
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages =
    with pkgs;
    with kdePackages;
    [
      ark
      elisa
      gwenview
      kate
      khelpcenter
      konsole
      okular
      print-manager
    ];

  services.fwupd.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez;
  };
  security.rtkit.enable = true;
  # disable fingerprint login because it disables password login
  security.pam.services.login.fprintAuth = false;
  security.pam.services.kde.fprintAuth = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  nix.package = pkgs.nixVersions.latest;
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Replace duplicate software with hardlinks
  # NOTE: This may make builds noticeably slower (but saves a ton of space)
  nix.settings.auto-optimise-store = true;
  nix.settings.cores = 8;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
    # The below is not possible sadly, see the following issue:
    # https://github.com/NixOS/nix/issues/9455
    # options = "--delete-older-than +15"; # keep the last 15 configurations only
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${vars.username} = {
    isNormalUser = true;
    description = "Riley Bruins";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  fonts.packages =
    with pkgs;
    let
      iosevka-custom = (
        pkgs-iosevka-pin.iosevka.override {
          set = "Custom";
          privateBuildPlan = {
            family = "Iosevka Custom";
            spacing = "FontConfig Mono";
            serifs = "Sans";
            noCvSs = true;
            exportGlyphNames = true;
            variants.design = {
              at = "fourfold";
              lig-equal-chain = "without-notch";
              lig-hyphen-chain = "without-notch";
            };
            ligations = {
              inherits = "dlig";
              disables = [
                "brack-bar"
                "brace-bar"
              ];
              enables = [
                "exeqeq"
                "eqeqeq"
                "llggeq"
                "tildeeq"
              ];
            };
          };
        }
      );
    in
    [
      iosevka-custom
      nerd-fonts.symbols-only
    ];
  fonts.fontconfig = {
    hinting.autohint = true;
    antialias = true;
    allowBitmaps = true;
    useEmbeddedBitmaps = true;
  };

  # TODO: Install locally?
  programs.steam.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs;
    let
      custom-catppuccin-sddm = (
        catppuccin-sddm.override {
          background = "${./assets/dsotm_blurred.png}";
          loginBackground = true;
          font = "Iosevka Custom Extended";
          fontSize = "15";
        }
      );
      neovim = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    in
    [
      bash
      bash-completion
      bashInteractive
      bibata-cursors
      curl
      custom-catppuccin-sddm
      gcc
      gimp
      git
      gnumake
      kitty
      mold
      neovim
      nix-bash-completions
      pciutils
      prismlauncher
      wget
    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "${vars.version}"; # Did you read the comment?
}
