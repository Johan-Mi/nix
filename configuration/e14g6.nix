{
  networking.hostName = "e14g6";

  boot.extraModprobeConfig = ''
    options rtw89_core disable_ps_mode=y
  '';

  services.udev.extraHwdb =
    ''
      evdev:name:AT Translated Set 2 keyboard:*
       KEYBOARD_KEY_01=capslock
       KEYBOARD_KEY_3a=esc
    '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
