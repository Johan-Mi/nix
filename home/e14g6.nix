{
  programs.fish = {
    interactiveShellInit = ''
      function fish_prompt
        echo \e\[44m\e\[30m (prompt_pwd) \e\[m\e\[34m' '\e\[m
      end
    '';
  };

  home.stateVersion = "23.05";
}
