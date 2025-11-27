{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    use-xdg-base-directories = true;
  };

  boot.tmp.useTmpfs = true;

  swapDevices = [ {
    device = "/dev/nvme0n1p3";
    randomEncryption.enable = true;
  } ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true; # Required by 32-bit games.

  powerManagement.powertop.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.dbus.implementation = "broker";

  services.speechd.enable = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModprobeConfig = ''
    options rtw89_core disable_ps_mode=y
  '';

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  networking.hostName = "e14g6"; # Define your hostname.

  networking.networkmanager.enable = false;
  networking.dhcpcd.enable = false; # iwd has a built-in DHCP client.
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };
  services.resolved.enable = true;

  time.timeZone = "Europe/Stockholm";

  i18n.defaultLocale = "C.utf8";

  services.xserver = {
    enable = true;

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
  };

  services.libinput = {
    enable = true;
    touchpad.tapping = false;
  };

  console.keyMap = "sv-latin1";

  programs.fish.enable = true;
  programs.slock.enable = true;

  users.users.johanmi = {
    isNormalUser = true;
    description = "Johan Milanov";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
