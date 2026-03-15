{ inputs, pkgs, config, ... }: {
  home.username = "johanmi";
  home.homeDirectory = "/home/${config.home.username}";

  nix = {
    package = pkgs.nix;
    registry.nixpkgs.flake = inputs.nixpkgs;
    assumeXdg = true;
  };

  home.packages = [
    pkgs.file # Used by `open` command in lf
    pkgs.gcc # Rust uses `cc` as its linker
    pkgs.htop
    pkgs.rustup
    pkgs.sunsetr
    pkgs.tokei
  ];

  home.file.".local/bin" = {
    source = ./bin;
    recursive = true;
  };

  xdg.enable = true;

  xdg.configFile."helix/runtime/queries/sc2".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Repos/scratch-compiler-2/tree-sitter-sc2/queries";

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables = {
    EDITOR = "hx";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    XAUTHORITY = "${config.xdg.configHome}/X11/Xauthority";
    LESSHISTFILE = "-";
    PISTOL_CHROMA_FORMATTER = "terminal16m";
    PISTOL_CHROMA_STYLE = "onedark";
    LF_DATA_HOME = "/tmp/lf";
    _JAVA_OPTIONS="-Djava.util.prefs.userRoot=${config.xdg.cacheHome}/java";
  };

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      set fish_history
      set fish_prompt_pwd_full_dirs 10
      bind \ca 'commandline "cd ~/Repos/"'
      bind \cg 'commandline "git clone https://github.com/"'
      bind \cz 'fg 2>/dev/null; commandline -f repaint'
    '';
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
      nvim = "nvim -p";
      v = "hx";
      cr = "cargo run";
      crr = "cargo run --release";
      cb = "cargo build";
      cbr = "cargo build --release";
      c = "cargo";
      cl = "cargo clippy";
      clad = "cargo clippy -- -A dead_code";
      info = "info --vi-keys";
      "clippy!" = "cargo clippy -- -W clippy::nursery -W clippy::pedantic";
      objdump = "objdump -dCMintel --disassembler-color=color --visualize-jumps=color";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Johan-Mi";
      user.email = "johanmi@protonmail.com";
      user.signingkey = "${config.home.homeDirectory}/.ssh/id_rsa.pub";
      core.editor = "hx";
      grep.lineNumber = true;
      credential.helper = "store";
      init.defaultBranch = "master";
      gpg.format = "ssh";
      commit.gpgsign = true;
      diff.colormoved = "default";
      diff.colormovedws = "allow-indentation-change";
      alias.lg = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
    };
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "onedarkest";
      editor = {
        true-color = true;
        completion-trigger-len = 1;
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
        space = "goto_word";
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
    languages.language-server.rust-analyzer.config.check.command = "clippy";
    languages.language = [
      {
        name = "sc2";
        scope = "source.sc2";
        injection-regex = "sc2";
        roots = [ ".git" ];
        file-types = [ "sc2" ];
        comment-token = "#";
        indent = { tab-width = 4; unit = "    "; };
        formatter = {
          command = "${config.home.homeDirectory}/Repos/scratch-compiler-2/target/debug/scratch-compiler-2";
          args = [ "format" ];
        };
        auto-format = true;
        auto-pairs = {
          "(" = ")";
          "{" = "}";
          "[" = "]";
          "\"" = "\"";
        };
      }
    ];
    languages.grammar = [
      {
        name = "sc2";
        # Remember to compile this.
        source.path = "${config.home.homeDirectory}/Repos/scratch-compiler-2/tree-sitter-sc2";
      }
    ];
  };

  programs.lf = {
    enable = true;
    settings = {
      ifs = "\n";
      scrolloff = 10;
      info = "size";
      dircounts = true;
      ratios = "1:3:4";
      tabstop = 4;
      history = false;
      previewer = "pistol";
    };
    commands = {
      open = ''
        ''${{
          case ''$(file --mime-type ''$f -b) in
            text/*) hx ''$fx ;;
            image/*) sxiv ''$fx; sleep 0.1 ;;
            application/pdf) zathura ''$fx; sleep 0.05 ;;
            video/*) mpv ''$fx; sleep 0.05 ;;
            *) ''$EDITOR ''$fx ;;
          esac
        }}
      '';
      open-with = ''
        ''${{
          ''$@ ''$f
        }}
      '';
    };
    keybindings = {
      J = "half-down";
      K = "half-up";
      d = null;
      dD = "delete";
      dd = "cut";
      r = "push :open-with<space>";
      R = "rename";
      i = "$pistol $f | less -R";
      S = "$strip -s $f";
      "<c-j>" = ":updir; down; open";
      "<c-k>" = ":updir; up; open";
      gr = "cd /";
      gn = "cd /nix/";
      gs = "cd /sys/";
      ge = "cd /etc/";
      gv = "cd /var/";
      "<lt><lt>" = ":cut; updir; paste; open";
    };
    extraConfig = ''
      set promptfmt "\033[34;1m%w/\033[0m\033[1m%f\033[0m"
      set cursorpreviewfmt "\033[7m"
      set hiddenfiles ~/.ssh:~/.pki:~/.java:~/.nix-defexpr:~/.nix-profile:~/.nix-channels:~/.var:~/snes9x.conf:~/.mozilla:~/.dbus:~/.serverauth.*:~/.zshenv:~/Downloads
      set truncatechar "…"
      set autoquit
    '';
  };

  programs.man.generateCaches = false; # Enabled by Fish, cluttering the home directory.

  programs.pistol.enable = true;
}
