{ pkgs, ... }: {
  home.packages = [
    pkgs.tmux
  ];

  home.stateVersion = "26.05";
}
