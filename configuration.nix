# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable flatpak
  services.flatpak.enable = true;

  # Enable default window manager
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Fish as default shell
  programs.fish = {
    enable = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable sudo-rs
  security.sudo-rs.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  environment.variables = {
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ahummaitra = {
    isNormalUser = true;
    description = "Ahum Maitra";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      neovim
      git
      waybar
      mise
      hyprshutdown
      hypridle
      hyprlock
      kitty
      ghostty
      libnotify
      neovim
      wlogout
      nemo
      yaru-theme
      papirus-icon-theme
      awww
      starship
      vscode
      fish
      rustup
      gtk3
      lua
      gtk4
      libadwaita
      cliphist
      btop
      wl-clipboard
      glib
      gsettings-desktop-schemas
      gobject-introspection
      pango
      cairo
      gdk-pixbuf
      librsvg
      graphene
      wget
      uv
      unzip
      pkg-config
      pkg-config
      quickshell
      qt6.qtwayland
      firefox
      openssl
      sqlite
      curl
      libsoup_3
      json-glib
      gcc
      gnumake
      gdb
      clang
      cmake
      meson
      ninja
      pkg-config
      autoconf
      swaynotificationcenter
      automake
      libtool
      polkit_gnome
      hyprshot
      brightnessctl
      wiremix
      evince
      xfce.parole
      eog
    ];
  };

  # Enable authentication manager
  security.polkit.enable = true;

  # Start it
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Get all required fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    dejavu_fonts
    noto-fonts
    noto-fonts-color-emoji
  ];

  # Get default emoji font
  fonts.fontconfig = {
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable SDDM
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    git
    glib
    wget
    curl
    nixfmt
  ];

  # Disable pulseaudio
  services.pulseaudio.enable = false;

  # Enable rtkit for video/audio real time
  security.rtkit.enable = true;

  # Enable Pipreware
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Required for 32-bit games (e.g., Steam)
    pulse.enable = true; # Emulates PulseAudio

    # WirePlumber is the default session manager and is enabled by default,
    # but you can declare it explicitly like this:
    wireplumber.enable = true;

    # Optional: Uncomment if you use professional audio/JACK apps
    # jack.enable = true;
  };

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
  system.stateVersion = "25.11"; # Did you read the comment?

}
