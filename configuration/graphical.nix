{
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true; # Required by 32-bit games.

  services.pipewire = {
    enable = true;
    alsa.enable = true;
  };

  networking.networkmanager.enable = false;
  networking.dhcpcd.enable = false; # iwd has a built-in DHCP client.
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };
  services.resolved.enable = true;

  services.libinput = {
    enable = true;
    touchpad.tapping = false;
  };

  programs.hyprland.enable = true;
  security.pam.services.swaylock = {};
}
