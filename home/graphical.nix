{ pkgs, config, ... }:

{
  home.packages = [
    pkgs.alsa-utils
    pkgs.cryptsetup
    pkgs.brightnessctl
    pkgs.grim
    pkgs.libnotify
    (pkgs.prismlauncher.override {
      prismlauncher-unwrapped = pkgs.prismlauncher-unwrapped.overrideAttrs {
        patches = [ ./prismlauncher-offline.patch ];
      };
    })
    pkgs.portablemc
    (pkgs.steam.override {
      extraPkgs = ps: with ps.pkgsi686Linux; [ libpng12 SDL2 ];
    }).run-free
    pkgs.sunsetr
    pkgs.swaybg
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

  xdg.configFile."xkb/symbols/se_tweaks".source = ./se_tweaks;
  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;

  home.file."${config.xdg.cacheHome}/helix/helix.log".source = config.lib.file.mkOutOfStoreSymlink /dev/null;

  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk3.extraConfig = {
      gtk-recent-files-max-age = 0;
      gtk-recent-files-limit = 0;
    };
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 24;
    gtk.enable = true;
    dotIcons.enable = false;
  };

  home.sessionVariables = {
    MOZ_USE_XINPUT2 = 1; # Firefox touchpad gestures
  };

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
        "media.ffmpeg.vaapi.enabled" = true; # Hardware video acceleration
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "toolkit.tabbox.switchByScrolling" = true;
      };
      userChrome = builtins.readFile ./firefox/userChrome.css;
      userContent = builtins.readFile ./firefox/userContent.css;
    };
    configPath = "${config.xdg.configHome}/mozilla/firefox";
  };
  home.file.".mozilla/native-messaging-hosts".enable = false;

  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      ytdl-format = "bestvideo[height<=?1200]+bestaudio/best";
    };
  };

  programs.rofi = {
    enable = true;
    extraConfig = {
      modes = "run";
      disable-history = true;
    };
  };

  programs.swaylock.enable = true;

  programs.waybar = {
    enable = true;
    settings.main = {
      modules-left = [ "hyprland/workspaces" "hyprland/window" ];
      modules-right = [ "battery" "clock" ];
      clock.format = "{:%c}";
    };
    style = ./waybar.css;
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        geometry = "300x5-12+34";
        frame_color = "#bbc2cf";
        font = "Liberation Sans 11";
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
}
