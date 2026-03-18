{ pkgs, username, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    use-xdg-base-directories = true;
  };

  boot.tmp.useTmpfs = true;

  powerManagement.powertop.enable = true;

  services.dbus.implementation = "broker";

  services.speechd.enable = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "10s";
  };

  time.timeZone = "Europe/Stockholm";

  i18n.defaultLocale = "C.UTF-8";

  console.keyMap = "sv-latin1";

  programs.fish.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = "Johan Milanov";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  networking.firewall.enable = false;
}
