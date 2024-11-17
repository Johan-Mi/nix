{ pkgs, config, ... }: {
  home.username = "johanmi";
  home.homeDirectory = /home/johanmi;

  home.packages = [
    pkgs.alsa-utils
    pkgs.brave
    pkgs.cryptsetup
    pkgs.brightnessctl
    pkgs.htop
    pkgs.libnotify
    pkgs.portablemc
    pkgs.rustup
    pkgs.scrot
    pkgs.xdotool
    (builtins.getFlake "github:Johan-Mi/dwmblocks/092cea0ddc55c09e98b2cf83b83fcc51dad76bbf").packages.${builtins.currentSystem}.default
    (pkgs.sxiv.overrideAttrs (old: {
      src = pkgs.fetchFromGitHub {
        owner = "Johan-Mi";
        repo = "sxiv";
        rev = "0b061ee5dbc306c3ed2bb4b7f1b4bdc4e25da9c3";
        sha256 = "LImNdfcmx1U6X0XOH14TCyfsKph/Z7sDVjiuqXUpzk0=";
      };
      buildInputs = old.buildInputs ++ [ pkgs.pkg-config pkgs.librsvg ];
    }))
  ];

  home.file.".local/bin" = {
    source = ./bin;
    recursive = true;
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables = {
    EDITOR = "hx";
    MOZ_USE_XINPUT2 = 1; # Firefox touchpad gestures
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    XINITRC = "${config.xdg.configHome}/X11/xinitrc";
  };

  xresources.properties = {
    "Xft.dpi" = 120; # Scale GUI applications up slightly
  };

  programs.home-manager.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        cursor.cursor = "#61afef";
        cursor.text = "#020202";
        normal = {
          black = "#020202";
          blue = "#61afef";
          cyan = "#56b6c2";
          green = "#98c379";
          magenta = "#c678dd";
          red = "#e06c75";
          white = "#eeeeee";
          yellow = "#d19a66";
        };
        primary = {
          background = "#020202";
          foreground = "#eeeeee";
        };
      };
      cursor.style = {
        blinking = "Never";
        shape = "Beam";
      };
      font.size = 11;
      font.normal.family = "Iosevka Term SS05";
      keyboard.bindings = [
        { action = "Paste"; key = "V"; mods = "Alt"; }
        { action = "Copy"; key = "C"; mods = "Alt"; }
        { action = "ScrollLineUp"; key = "K"; mods = "Alt"; }
        { action = "ScrollLineDown"; key = "J"; mods = "Alt"; }
        { action = "ScrollHalfPageUp"; key = "U"; mods = "Alt"; }
        { action = "ScrollHalfPageDown"; key = "D"; mods = "Alt"; }
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "Johan-Mi";
    userEmail = "johanmi@protonmail.com";
    extraConfig = {
      user.signingkey = "/home/johanmi/.ssh/id_rsa.pub";
      core.editor = "hx";
      grep.lineNumber = true;
      credential.helper = "store";
      init.defaultBranch = "master";
      gpg.format = "ssh";
      commit.gpgsign = true;
      diff.colormoved = "default";
      diff.colormovedws = "allow-indentation-change";
    };
    aliases.lg = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "browser.display.use_document_fonts" = 0;
        "browser.newtabpage.enabled" = false;
        "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
        "browser.uidensity" = 1; # Compact
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "font.default.x-western" = "sans-serif";
        "font.name.monospace.x-western" = "Liberation Mono";
        "font.name.sans-serif.x-western" = "Liberation Sans";
        "font.name.serif.x-western" = "Liberation Serif";
        "full-screen-api.ignore-widgets" = true; # Fixes full-screen issues
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "toolkit.tabbox.switchByScrolling" = true;
      };
      userChrome = builtins.readFile ./firefox/userChrome.css;
    };
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "onedarkest";
      editor = {
        true-color = true;
        completion-trigger-len = 1;
        # completion-timeout = 0;
        idle-timeout = 0;
        scrolloff = 999;
        soft-wrap.enable = true;
        file-picker.git-exclude = false;
      };
      editor.cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      editor.lsp = {
        goto-reference-include-declaration = false;
      };
      keys.normal = {
        X = [ "extend_line_up" "extend_to_line_bounds" ];
        A-e = "expand_selection";
        A-w = "shrink_selection";
        A-n = "select_prev_sibling";
        A-m = "select_next_sibling";
        A-space = "collapse_selection";
        g.q = ":reflow";
        "(" = [ "goto_prev_diag" "code_action" ];
        ")" = [ "goto_next_diag" "code_action" ];
        "\\" = "make_search_word_bounded";
      };
      keys.normal.space = {
        q.q = ":xa";
        q.Q = ":qa!";
        c.s = ":update";
        "," = ":bc";
        # space = "goto_word";
        t.a = ":theme acme";
        t.i = ":theme onelight";
        t.o = ":theme onedarkest";
        t.m = ":theme modus_operandi";
        t.v = ":theme modus_vivendi";
        t.p = ":theme pink";
        t.e = ":theme merionette";
      };
      keys.insert = {
        C-space = "completion";
      };
    };
    themes.onedarkest = {
      inherits = "onedark";
      tag = { fg = "cyan"; };
      "tag.error" = { fg = "red"; modifiers = [ "bold" ]; };
      "ui.virtual.whitespace" = { fg = "white"; };
      palette.black = "#020202";
    };
    themes.pink = {
      inherits = "onelight";
      "ui.background" = { bg = "#f7a8e3"; };
    };
  };

  programs.lf = {
    enable = true;
    settings = {
      scrolloff = 10;
      icons = true;
      info = "size";
      dircounts = true;
      ratios = "1:3:4";
      tabstop = 4;
      hidden = true;
    };
    extraConfig = ''
      set promptfmt "\033[34;1m%w/\033[0m\033[1m%f\033[0m"
      set hiddenfiles ~/.ssh:~/.pki:~/.java:~/.nix-defexpr:~/.nix-profile:~/.nix-channels:~/.var:~/snes9x.conf:~/.mozilla:~/Downloads
      set truncatechar "…"
      set autoquit
    '';
  };

  programs.rofi = {
    enable = true;
    extraConfig = {
      modes = "run";
      disable-history = true;
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        geometry = "300x5-12+34";
        frame_color = "#bbc2cf";
        font = "Noto Sans 11";
      };
      urgency_low = {
        background = "#222222";
        foreground = "#bbc2cf";
        timeout = 10;
      };
      urgency_normal = {
        background = "#020202";
        foreground = "#bbc2cf";
        timeout = 10;
      };
      urgency_critical = {
        background = "#900000";
        foreground = "#bbc2cf";
        frame_color = "#ff0000";
        timeout = 0;
      };
    };
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    shellAliases =  {
      ls = "ls -1Av --color=auto";
      sl = "ls";
      l = "ls";
      ka = "killall";
      gs = "git status";
      gd = "git diff";
      gds = "git diff --stat";
      gdst = "git diff --staged";
      gg = "git grep";
      gc = "git checkout";
      gcs = "git clone --depth = 1";
      nvim = "nvim -p";
      v = "hx";
      cr = "cargo run";
      crr = "cargo run --release";
      cb = "cargo build";
      cbr = "cargo build --release";
      c = "cargo";
      cl = "cargo clippy";
      info = "info --vi-keys";
      "clippy!" = "cargo clippy -- -W clippy::nursery -W clippy::pedantic";
      objdump = "objdump -dCMintel --disassembler-color=color --visualize-jumps=color";
    };
    history.save = 0;
  };

  home.stateVersion = "23.05";
}
