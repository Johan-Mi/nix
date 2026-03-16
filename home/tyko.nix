{ pkgs, ... }:

{
  home.packages = [
    pkgs.tmux
  ];

  programs.fish = {
    interactiveShellInit = ''
      function fish_prompt
        echo \e\[42m\e\[30m (prompt_pwd) \e\[m\e\[32m' '\e\[m
      end
    '';
  };

  home.stateVersion = "26.05";
}
