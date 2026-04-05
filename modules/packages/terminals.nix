# SPDX-License-Identifier: GPL-3.0-or-later
# Steelbore Lattice — Terminal Emulators (All with Steelbore Theme)
{ config, lib, pkgs, steelborePalette, ... }:

{
  options.steelbore.packages.terminals = {
    enable = lib.mkEnableOption "Terminal emulators";
  };

  config = lib.mkIf config.steelbore.packages.terminals.enable {
    environment.systemPackages = with pkgs; [
      # Rust-based (preferred)
      alacritty
      wezterm
      rio
      ghostty                    # Zig, but memory-safe

      # Other terminals
      ptyxis                     # GNOME terminal (VTE-based)
      waveterm                   # AI-native terminal
      warp-terminal              # AI-powered terminal
      termius                    # SSH client
      cosmic-term                # COSMIC terminal
    ];

    # ═══════════════════════════════════════════════════════════════════════════
    # ALACRITTY — Rust-based GPU-accelerated terminal
    # ═══════════════════════════════════════════════════════════════════════════
    environment.etc."alacritty/alacritty.toml".text = ''
      # Steelbore Alacritty Configuration

      [window]
      padding = { x = 10, y = 10 }
      dynamic_title = true
      opacity = 0.95
      decorations = "full"

      [font]
      normal = { family = "JetBrains Mono", style = "Regular" }
      bold = { family = "JetBrains Mono", style = "Bold" }
      italic = { family = "JetBrains Mono", style = "Italic" }
      size = 12.0

      [colors.primary]
      background = "${steelborePalette.voidNavy}"
      foreground = "${steelborePalette.moltenAmber}"

      [colors.cursor]
      text = "${steelborePalette.voidNavy}"
      cursor = "${steelborePalette.moltenAmber}"

      [colors.vi_mode_cursor]
      text = "${steelborePalette.voidNavy}"
      cursor = "${steelborePalette.radiumGreen}"

      [colors.selection]
      text = "${steelborePalette.voidNavy}"
      background = "${steelborePalette.steelBlue}"

      [colors.search.matches]
      foreground = "${steelborePalette.voidNavy}"
      background = "${steelborePalette.liquidCool}"

      [colors.search.focused_match]
      foreground = "${steelborePalette.voidNavy}"
      background = "${steelborePalette.radiumGreen}"

      [colors.normal]
      black = "${steelborePalette.voidNavy}"
      red = "${steelborePalette.redOxide}"
      green = "${steelborePalette.radiumGreen}"
      yellow = "${steelborePalette.moltenAmber}"
      blue = "${steelborePalette.steelBlue}"
      magenta = "${steelborePalette.steelBlue}"
      cyan = "${steelborePalette.liquidCool}"
      white = "${steelborePalette.moltenAmber}"

      [colors.bright]
      black = "${steelborePalette.steelBlue}"
      red = "${steelborePalette.redOxide}"
      green = "${steelborePalette.radiumGreen}"
      yellow = "${steelborePalette.moltenAmber}"
      blue = "${steelborePalette.liquidCool}"
      magenta = "${steelborePalette.liquidCool}"
      cyan = "${steelborePalette.liquidCool}"
      white = "${steelborePalette.moltenAmber}"
    '';

    # ═══════════════════════════════════════════════════════════════════════════
    # WEZTERM — Rust-based GPU-accelerated terminal with Lua config
    # ═══════════════════════════════════════════════════════════════════════════
    environment.etc."wezterm/wezterm.lua".text = ''
      -- Steelbore WezTerm Configuration
      local wezterm = require 'wezterm'
      local config = {}

      -- Font configuration
      config.font = wezterm.font 'JetBrains Mono'
      config.font_size = 12.0

      -- Window configuration
      config.window_background_opacity = 0.95
      config.window_padding = { left = 10, right = 10, top = 10, bottom = 10 }
      config.enable_tab_bar = true
      config.hide_tab_bar_if_only_one_tab = true

      -- Steelbore color scheme
      config.colors = {
        foreground = "${steelborePalette.moltenAmber}",
        background = "${steelborePalette.voidNavy}",
        cursor_bg = "${steelborePalette.moltenAmber}",
        cursor_fg = "${steelborePalette.voidNavy}",
        cursor_border = "${steelborePalette.moltenAmber}",
        selection_bg = "${steelborePalette.steelBlue}",
        selection_fg = "${steelborePalette.voidNavy}",
        scrollbar_thumb = "${steelborePalette.steelBlue}",
        split = "${steelborePalette.steelBlue}",

        ansi = {
          "${steelborePalette.voidNavy}",
          "${steelborePalette.redOxide}",
          "${steelborePalette.radiumGreen}",
          "${steelborePalette.moltenAmber}",
          "${steelborePalette.steelBlue}",
          "${steelborePalette.steelBlue}",
          "${steelborePalette.liquidCool}",
          "${steelborePalette.moltenAmber}"
        },
        brights = {
          "${steelborePalette.steelBlue}",
          "${steelborePalette.redOxide}",
          "${steelborePalette.radiumGreen}",
          "${steelborePalette.moltenAmber}",
          "${steelborePalette.liquidCool}",
          "${steelborePalette.liquidCool}",
          "${steelborePalette.liquidCool}",
          "${steelborePalette.moltenAmber}"
        },

        tab_bar = {
          background = "${steelborePalette.voidNavy}",
          active_tab = {
            bg_color = "${steelborePalette.steelBlue}",
            fg_color = "${steelborePalette.moltenAmber}",
          },
          inactive_tab = {
            bg_color = "${steelborePalette.voidNavy}",
            fg_color = "${steelborePalette.steelBlue}",
          },
          inactive_tab_hover = {
            bg_color = "${steelborePalette.steelBlue}",
            fg_color = "${steelborePalette.moltenAmber}",
          },
          new_tab = {
            bg_color = "${steelborePalette.voidNavy}",
            fg_color = "${steelborePalette.steelBlue}",
          },
          new_tab_hover = {
            bg_color = "${steelborePalette.steelBlue}",
            fg_color = "${steelborePalette.moltenAmber}",
          },
        },
      }

      return config
    '';

    # ═══════════════════════════════════════════════════════════════════════════
    # RIO — Rust-based terminal with native GPU rendering
    # ═══════════════════════════════════════════════════════════════════════════
    environment.etc."rio/config.toml".text = ''
      # Steelbore Rio Configuration

      [window]
      opacity = 0.95
      decorations = "enabled"

      [fonts]
      family = "JetBrains Mono"
      size = 14

      [colors]
      background = '${steelborePalette.voidNavy}'
      foreground = '${steelborePalette.moltenAmber}'
      cursor = '${steelborePalette.moltenAmber}'
      tabs = '${steelborePalette.steelBlue}'
      tabs-active = '${steelborePalette.moltenAmber}'
      selection-background = '${steelborePalette.steelBlue}'
      selection-foreground = '${steelborePalette.voidNavy}'

      [colors.regular]
      black = '${steelborePalette.voidNavy}'
      red = '${steelborePalette.redOxide}'
      green = '${steelborePalette.radiumGreen}'
      yellow = '${steelborePalette.moltenAmber}'
      blue = '${steelborePalette.steelBlue}'
      magenta = '${steelborePalette.steelBlue}'
      cyan = '${steelborePalette.liquidCool}'
      white = '${steelborePalette.moltenAmber}'

      [colors.bright]
      black = '${steelborePalette.steelBlue}'
      red = '${steelborePalette.redOxide}'
      green = '${steelborePalette.radiumGreen}'
      yellow = '${steelborePalette.moltenAmber}'
      blue = '${steelborePalette.liquidCool}'
      magenta = '${steelborePalette.liquidCool}'
      cyan = '${steelborePalette.liquidCool}'
      white = '${steelborePalette.moltenAmber}'
    '';

    # ═══════════════════════════════════════════════════════════════════════════
    # GHOSTTY — Zig-based GPU-accelerated terminal (memory-safe)
    # ═══════════════════════════════════════════════════════════════════════════
    environment.etc."ghostty/config".text = ''
      # Steelbore Ghostty Configuration

      font-family = JetBrains Mono
      font-size = 12

      background-opacity = 0.95
      window-padding-x = 10
      window-padding-y = 10

      # Steelbore color palette
      background = ${steelborePalette.voidNavy}
      foreground = ${steelborePalette.moltenAmber}
      cursor-color = ${steelborePalette.moltenAmber}
      cursor-text = ${steelborePalette.voidNavy}
      selection-background = ${steelborePalette.steelBlue}
      selection-foreground = ${steelborePalette.voidNavy}

      # Normal colors (0-7)
      palette = 0=${steelborePalette.voidNavy}
      palette = 1=${steelborePalette.redOxide}
      palette = 2=${steelborePalette.radiumGreen}
      palette = 3=${steelborePalette.moltenAmber}
      palette = 4=${steelborePalette.steelBlue}
      palette = 5=${steelborePalette.steelBlue}
      palette = 6=${steelborePalette.liquidCool}
      palette = 7=${steelborePalette.moltenAmber}

      # Bright colors (8-15)
      palette = 8=${steelborePalette.steelBlue}
      palette = 9=${steelborePalette.redOxide}
      palette = 10=${steelborePalette.radiumGreen}
      palette = 11=${steelborePalette.moltenAmber}
      palette = 12=${steelborePalette.liquidCool}
      palette = 13=${steelborePalette.liquidCool}
      palette = 14=${steelborePalette.liquidCool}
      palette = 15=${steelborePalette.moltenAmber}
    '';

    # ═══════════════════════════════════════════════════════════════════════════
    # COSMIC-TERM — COSMIC desktop terminal (Rust-based)
    # Config is typically managed by cosmic-settings, but we provide defaults
    # ═══════════════════════════════════════════════════════════════════════════
    environment.etc."cosmic/com.system76.CosmicTerm/v1/syntax_theme_dark".text = ''
      "Steelbore"
    '';

    # ═══════════════════════════════════════════════════════════════════════════
    # PTYXIS (GNOME Console) — VTE-based terminal
    # Uses dconf/gsettings, configured via GNOME module or home-manager
    # Providing a CSS override for theming
    # ═══════════════════════════════════════════════════════════════════════════
    environment.etc."gtk-4.0/gtk.css".text = ''
      /* Steelbore Ptyxis/VTE Terminal Theme Override */
      vte-terminal {
        padding: 10px;
      }
    '';

    # ═══════════════════════════════════════════════════════════════════════════
    # WAVETERM — AI-native terminal
    # Uses JSON configuration
    # ═══════════════════════════════════════════════════════════════════════════
    environment.etc."waveterm/config.json".text = builtins.toJSON {
      term = {
        fontfamily = "JetBrains Mono";
        fontsize = 12;
        theme = "custom";
      };
      themes = {
        custom = {
          display = {
            name = "Steelbore";
            order = 1;
          };
          terminal = {
            background = steelborePalette.voidNavy;
            foreground = steelborePalette.moltenAmber;
            cursor = steelborePalette.moltenAmber;
            selectionBackground = steelborePalette.steelBlue;
            black = steelborePalette.voidNavy;
            red = steelborePalette.redOxide;
            green = steelborePalette.radiumGreen;
            yellow = steelborePalette.moltenAmber;
            blue = steelborePalette.steelBlue;
            magenta = steelborePalette.steelBlue;
            cyan = steelborePalette.liquidCool;
            white = steelborePalette.moltenAmber;
            brightBlack = steelborePalette.steelBlue;
            brightRed = steelborePalette.redOxide;
            brightGreen = steelborePalette.radiumGreen;
            brightYellow = steelborePalette.moltenAmber;
            brightBlue = steelborePalette.liquidCool;
            brightMagenta = steelborePalette.liquidCool;
            brightCyan = steelborePalette.liquidCool;
            brightWhite = steelborePalette.moltenAmber;
          };
        };
      };
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # WARP TERMINAL — AI-powered terminal
    # Uses YAML configuration
    # ═══════════════════════════════════════════════════════════════════════════
    environment.etc."warp/themes/steelbore.yaml".text = ''
      # Steelbore Theme for Warp Terminal
      accent: '${steelborePalette.steelBlue}'
      background: '${steelborePalette.voidNavy}'
      foreground: '${steelborePalette.moltenAmber}'
      details: darker
      terminal_colors:
        normal:
          black: '${steelborePalette.voidNavy}'
          red: '${steelborePalette.redOxide}'
          green: '${steelborePalette.radiumGreen}'
          yellow: '${steelborePalette.moltenAmber}'
          blue: '${steelborePalette.steelBlue}'
          magenta: '${steelborePalette.steelBlue}'
          cyan: '${steelborePalette.liquidCool}'
          white: '${steelborePalette.moltenAmber}'
        bright:
          black: '${steelborePalette.steelBlue}'
          red: '${steelborePalette.redOxide}'
          green: '${steelborePalette.radiumGreen}'
          yellow: '${steelborePalette.moltenAmber}'
          blue: '${steelborePalette.liquidCool}'
          magenta: '${steelborePalette.liquidCool}'
          cyan: '${steelborePalette.liquidCool}'
          white: '${steelborePalette.moltenAmber}'
    '';

    # ═══════════════════════════════════════════════════════════════════════════
    # TERMIUS — SSH client (theming limited, uses app settings)
    # No system-level theming available; users configure in-app
    # ═══════════════════════════════════════════════════════════════════════════
  };
}
