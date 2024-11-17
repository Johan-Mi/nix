# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "e14g6"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "C.UTF-8";

  services.xserver = {
    enable = true;

    # Configure keymap in X11
    xkb.layout = "se_tweaks";
    xkb.variant = "nodeadkeys";
    xkb.options = "caps:swapescape,compose:prsc,compose:menu";
    xkb.extraLayouts.se_tweaks = {
      description = "Swedish layout but optimized for programming";
      languages = [ "sv" ];
      symbolsFile = /home/johanmi/.config/home-manager/X11/se_tweaks;
    };
    autoRepeatDelay = 300;
    autoRepeatInterval = 40;

    videoDrivers = [ "amdgpu" ];
    deviceSection = ''Option "TearFree" "true"'';
    displayManager.startx.enable = true;
    windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs {
        src = /home/johanmi/Repos/dwm;
      };
    };
  };

  services.libinput = {
    enable = true;
    touchpad.tapping = false;
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

  programs.slock.enable = true;
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.johanmi = {
    isNormalUser = true;
    description = "Johan Milanov";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
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
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
