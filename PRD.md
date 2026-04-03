# Lattice — Product Requirements Document

**Project:** Lattice (A Steelbore NixOS Distribution)
**Version:** 2.0 | **Date:** 2026-04-02
**Author:** Mohamed Hammad | **License:** GPL-3.0-or-later
**Status:** Draft — Pending Approval

---

## 1. Executive Summary

Lattice is a flake-based NixOS configuration implementing the Steelbore Standard. This PRD defines a complete rewrite from the ground up with a modular, opt-in architecture supporting four desktop environments: GNOME (Wayland), COSMIC (Wayland), Niri (Wayland), and LeftWM (X11).

**Core Principles:**

- Memory-safe tooling preferred (Rust-first ecosystem)
- Opt-in modularity via `lib.mkEnableOption`
- Steelbore Color Palette applied universally
- Self-sufficient configuration (no external dependencies beyond nixpkgs)

---

## 2. Architecture Overview

### 2.1 Directory Structure

```text
lattice/
├── flake.nix                      # Flake entry point
├── flake.lock                     # Pinned dependencies
├── lib/                           # Custom Nix helper functions
│   └── default.nix                # mkSteelboreModule, color palette
├── hosts/                         # Machine-specific configurations
│   └── lattice/                   # Primary host
│       ├── default.nix            # Host traits (boot, locale, user)
│       └── hardware.nix           # Hardware configuration
├── modules/                       # NixOS modules (steelbore.* namespace)
│   ├── core/                      # Always-enabled necessities
│   │   ├── default.nix            # Core module entry
│   │   ├── nix.nix                # Nix settings, flakes
│   │   ├── boot.nix               # Bootloader, kernel
│   │   ├── locale.nix             # Timezone, i18n
│   │   ├── audio.nix              # PipeWire audio stack
│   │   └── security.nix           # sudo-rs, polkit
│   ├── theme/                     # Steelbore visual identity
│   │   ├── default.nix            # Color palette, TTY colors
│   │   └── fonts.nix              # Typography
│   ├── hardware/                  # Hardware-specific modules
│   │   ├── fingerprint.nix        # fprintd
│   │   └── intel.nix              # Intel-specific optimizations
│   ├── desktops/                  # Desktop environments (opt-in)
│   │   ├── gnome.nix              # GNOME on Wayland
│   │   ├── cosmic.nix             # COSMIC DE on Wayland
│   │   ├── niri.nix               # Niri + Ironbar on Wayland
│   │   └── leftwm.nix             # LeftWM + Polybar on X11
│   ├── login/                     # Display/login managers
│   │   └── greetd.nix             # greetd + tuigreet
│   └── packages/                  # Application bundles (opt-in)
│       ├── browsers.nix           # Web browsers
│       ├── terminals.nix          # Terminal emulators
│       ├── editors.nix            # Text editors & IDEs
│       ├── development.nix        # Dev tools & languages
│       ├── security.nix           # Encryption & auth
│       ├── networking.nix         # Network tools
│       ├── multimedia.nix         # Media players & processing
│       ├── productivity.nix       # Office & notes
│       ├── system.nix             # System utilities
│       └── ai.nix                 # AI coding assistants
├── users/                         # User profiles
│   └── mj/                        # User "mj"
│       ├── default.nix            # System-level user config
│       └── home.nix               # Home Manager configuration
└── overlays/                      # Package overlays
    └── default.nix                # Custom derivations
```

### 2.2 Module Design Pattern

All modules use the `steelbore.*` namespace with `lib.mkEnableOption`:

```nix
# Example: modules/desktops/niri.nix
{ config, lib, pkgs, ... }:
{
  options.steelbore.desktops.niri = {
    enable = lib.mkEnableOption "Niri scrolling tiling compositor";
  };

  config = lib.mkIf config.steelbore.desktops.niri.enable {
    # Module implementation
  };
}
```

### 2.3 Host Configuration Pattern

Hosts toggle modules declaratively:

```nix
# hosts/lattice/default.nix
{
  steelbore = {
    # Desktops
    desktops.gnome.enable = true;
    desktops.cosmic.enable = true;
    desktops.niri.enable = true;
    desktops.leftwm.enable = true;

    # Hardware
    hardware.fingerprint.enable = true;
    hardware.intel.enable = true;

    # Packages
    packages.browsers.enable = true;
    packages.terminals.enable = true;
    packages.editors.enable = true;
    packages.development.enable = true;
  };
}
```

---

## 3. Steelbore Visual Identity

### 3.1 Color Palette

| Token          | Hex       | RGB                | Role                           |
|----------------|-----------|--------------------|--------------------------------|
| Void Navy      | `#000027` | RGB(000, 000, 039) | Background / Canvas            |
| Molten Amber   | `#D98E32` | RGB(217, 142, 050) | Primary Text / Active Readout  |
| Steel Blue     | `#4B7EB0` | RGB(075, 126, 176) | Primary Accent / Structural    |
| Radium Green   | `#50FA7B` | RGB(080, 250, 123) | Success / Safe Status          |
| Red Oxide      | `#FF5C5C` | RGB(255, 092, 092) | Warning / Error Status         |
| Liquid Coolant | `#8BE9FD` | RGB(139, 233, 253) | Info / Links                   |

**`#000027` (Void Navy) is the mandatory background for ALL Steelbore surfaces.**

### 3.2 Typography

| Context       | Font             | License | Fallback        |
|---------------|------------------|---------|-----------------|
| UI Headers    | Orbitron         | OFL     | Share Tech Mono |
| Code/Terminal | JetBrains Mono   | OFL     | Cascadia Code   |
| HUD/Status    | Share Tech Mono  | OFL     | monospace       |
| Brand/Hero    | Future Earth     | Free    | Orbitron        |

---

## 4. Flake Configuration

### 4.1 Complete `flake.nix`

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{
  description = "Lattice — A Steelbore NixOS Distribution";

  inputs = {
    # Core — single stable channel for all packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";

      config.allowUnfree = true;
    };

    # Steelbore color palette as a reusable attribute set
    steelborePalette = {
      voidNavy     = "#000027";
    nixosConfigurations.lattice = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit steelborePalette;
      };
      modules = [
        # External modules
        home-manager.nixosModules.home-manager

        # Lattice modules
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = { inherit steelborePalette; };
          home-manager.users.mj = import ./users/mj/home.nix;
        }
      ];

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, pkgs, ... }:

{
  # Bootloader: systemd-boot
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel: XanMod Latest (performance-optimized)
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # Kernel modules
  boot.initrd.availableKernelModules = [
  };

  config = lib.mkIf config.steelbore.desktops.cosmic.enable {
    # Enable COSMIC (stable nixpkgs NixOS module — bundles all COSMIC packages)
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = false; # Use greetd
  };
}
```

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, pkgs, steelborePalette, ... }:

{
  options.steelbore.desktops.niri = {
      xwayland-satellite        # X11 app support
      ironbar                   # Status bar (Rust)
      waybar                    # Alternative bar
      anyrun                    # Application launcher (Rust)
      onagre                    # Application launcher (Rust)
      wired                     # Notification daemon (Rust)
      swaylock                  # Screen locker

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, pkgs, steelborePalette, ... }:

{
  options.steelbore.desktops.leftwm = {
      leftwm-config

      # Launcher
      rlaunch                    # Application launcher (Rust)
      rofi                       # Alternative launcher
      dmenu                      # Minimal launcher


```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, pkgs, ... }:

{
  options.steelbore.packages.browsers = {
    # Firefox (system-managed)
    programs.firefox.enable = true;

    environment.systemPackages = with pkgs; [
      google-chrome
      brave
      microsoft-edge
      librewolf
    ];
  };
}

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, pkgs, steelborePalette, ... }:

{
  options.steelbore.packages.terminals = {
      ghostty                    # Zig, but memory-safe

      # Other terminals
      ptyxis                     # GNOME terminal
      waveterm                   # AI-native terminal
      warp-terminal              # AI-powered terminal
      termius                    # SSH client
      cosmic-term                # COSMIC terminal
    ];

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, pkgs, ... }:

{
  options.steelbore.packages.editors = {

  config = lib.mkIf config.steelbore.packages.editors.enable {
    environment.systemPackages = with pkgs; [
      # Linting
      markdownlint-cli2           # Markdown linter

      # TUI Editors (Rust preferred)
      helix                      # Rust — Modal editor
      amp                        # Rust — Vim-like
      cosmic-edit                # Rust — COSMIC editor

      # GUI Editors (Standard)
      emacs-pgtk                 # Emacs with pure GTK (Wayland-native)
      vscode-fhs                 # VS Code in FHS wrapper
      gedit
    ];
  };

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, pkgs, ... }:

{
  options.steelbore.packages.development = {
      gitui                      # Rust — TUI for Git
      delta                      # Rust — Syntax-highlighting pager
      jujutsu                    # Rust — Git-compatible VCS (jj)
      gh                         # Go — GitHub CLI
      github-desktop

      # Rust Toolchain

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, pkgs, ... }:

{
  options.steelbore.packages.security = {

      # Password Managers
      rbw                        # Rust — Bitwarden CLI
      bitwarden-cli
      bitwarden-desktop
      authenticator              # Rust — 2FA/OTP

      # SSH
      openssh_hpn               # Includes OpenSSH tooling

      # Backup
      pika-backup                # Rust — Borg frontend

      # Secure Boot
      sbctl                      # Rust — Secure Boot manager

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, pkgs, ... }:

{
  options.steelbore.packages.networking = {
      bandwhich                  # Rust — Bandwidth monitor

      # GUI Applications
      sniffnet                   # Rust — Network monitor
      mullvad-vpn                # Rust — VPN client
      rqbit                      # Rust — BitTorrent

      # Download Managers
      aria2

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, pkgs, ... }:

{
  options.steelbore.packages.productivity = {
      iamb                       # Rust — Matrix TUI
      fractal                    # Rust — Matrix GUI
      newsflash                  # Rust — RSS reader
      tutanota-desktop
      onedriver                  # Go — OneDrive
    ];
  };

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, pkgs, ... }:

{
  options.steelbore.packages.system = {
      # File Management (Rust preferred)
      yazi                       # Rust — TUI file manager
      broot                      # Rust — Tree navigator
      superfile                  # Go — TUI file manager
      spacedrive                 # Rust — Cross-platform explorer
      fclones                    # Rust — Duplicate finder
      kondo                      # Rust — Project cleaner
      pipe-rename                # Rust — Interactive rename
      ouch                       # Rust — Archive tool

      # Disk Management (Rust preferred)
      gptman                     # Rust — GPT manager

      # System Monitoring (Rust preferred)
      starship                   # Rust — Prompt
      atuin                      # Rust — Shell history
      pipr                       # Rust — Pipeline builder
      moor                       # Rust — Shell
      powershell

      # Multiplexers
      zellij                     # Rust — Terminal multiplexer

      # ZFS
      zfs
      antigravity                # Rust

      # Benchmarking
      phoronix-test-suite

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, pkgs, ... }:

{
  options.steelbore.packages.ai = {

      # AI Coding Assistants (Other)
      opencode                   # Go — Coding agent
      codex
      github-copilot-cli
      gpt-cli
      mcp-nixos
      claude-code
    ];
  };
}
```

---

## 10. Hardware Modules

### 10.1 Fingerprint Reader (`modules/hardware/fingerprint.nix`)

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, pkgs, ... }:

{
  options.steelbore.hardware.fingerprint = {
    enable = lib.mkEnableOption "Fingerprint reader support";
  };

  config = lib.mkIf config.steelbore.hardware.fingerprint.enable {
    services.fprintd.enable = true;

    environment.systemPackages = [ pkgs.fprintd ];
  };
}
```

### 10.2 Intel Optimizations (`modules/hardware/intel.nix`)

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, lib, pkgs, ... }:

{
  options.steelbore.hardware.intel = {
    enable = lib.mkEnableOption "Intel CPU optimizations";
  };

  config = lib.mkIf config.steelbore.hardware.intel.enable {
    boot.kernelModules = [ "kvm-intel" ];

    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;

    # Build optimization flags for x86-64-v4 (AVX-512)
    environment.sessionVariables = {
      RUSTFLAGS = "-C target-cpu=x86-64-v4 -C opt-level=3";
      GOAMD64 = "v4";
      CFLAGS = "-march=x86-64-v4 -O3 -pipe -fno-plt -flto=auto";
      CXXFLAGS = "-march=x86-64-v4 -O3 -pipe -fno-plt -flto=auto";
    };
  };
}
```

---

## 11. Host Configuration

### 11.1 Lattice Host (`hosts/lattice/default.nix`)

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{
  imports = [
    ./hardware.nix
  ];

  # Hostname
  networking.hostName = "lattice";
  networking.networkmanager.enable = true;

  # X11 (for LeftWM)
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us,ar";
    options = "grp:ctrl_space_toggle";
  };

  # Printing
  services.printing.enable = true;

  # User account
  users.users.mj = {
    isNormalUser = true;
    description = "Mohamed Hammad";
    extraGroups = [ "networkmanager" "wheel" "input" "video" "audio" "docker" ];
    shell = pkgs.nushell;
  };

  # Steelbore module toggles
  steelbore = {
    # Desktop environments
    desktops.gnome.enable = true;
    desktops.cosmic.enable = true;
    desktops.niri.enable = true;
    desktops.leftwm.enable = true;

    # Hardware
    hardware.fingerprint.enable = true;
    hardware.intel.enable = true;

    # Package bundles
    packages.browsers.enable = true;
    packages.terminals.enable = true;
    packages.editors.enable = true;
    packages.development.enable = true;
    packages.security.enable = true;
    packages.networking.enable = true;
    packages.multimedia.enable = true;
    packages.productivity.enable = true;
    packages.system.enable = true;
    packages.ai.enable = true;
  };

  system.stateVersion = "25.11";
}
```

### 11.2 Hardware Configuration (`hosts/lattice/hardware.nix`)

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
# Generated by nixos-generate-config — Do not edit manually
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/667c95b9-16ac-449a-b36c-7a4e156620c3";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/30F4-BB7D";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
```

---

## 12. User Configuration

### 12.1 User System Config (`users/mj/default.nix`)

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, pkgs, ... }:

{
  users.users.mj = {
    isNormalUser = true;
    description = "Mohamed Hammad";
    extraGroups = [ "networkmanager" "wheel" "input" "video" "audio" "docker" ];
    shell = pkgs.nushell;
  };
}
```

### 12.2 Home Manager Config (`users/mj/home.nix`)

```nix
# SPDX-License-Identifier: GPL-3.0-or-later
{ config, pkgs, lib, steelborePalette, ... }:

{
  home.username = "mj";
  home.homeDirectory = "/home/mj";
  home.stateVersion = "25.11";

  # Steelbore project symlink
  home.file."steelbore".source = config.lib.file.mkOutOfStoreSymlink "/steelbore";

  # Keyboard layout
  home.keyboard = {
    layout = "us,ar";
    options = [ "grp:ctrl_space_toggle" ];
  };

  # Session variables
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    STEELBORE_THEME = "true";
  };

  # Programs
  programs = {
    # Git configuration
    git = {
      enable = true;
      signing = {
        key = "B36135D768BF4D704B6061A8C69EC44335B60CCB";
        signByDefault = true;
      };
      extraConfig = {
        user = {
          name = "UnbreakableMJ";
          email = "34196588+UnbreakableMJ@users.noreply.github.com";
        };
        init.defaultBranch = "main";
        gpg = {
          format = "openpgp";
          program = "${pkgs.sequoia-chameleon-gnupg}/bin/gpg";
        };
      };
    };

    # Starship prompt (Steelbore theme)
    starship = {
      enable = true;
      settings = {
        format = "$directory$git_branch$git_status$cmd_duration$character";
        palette = "steelbore";

        palettes.steelbore = {
          void_navy = steelborePalette.voidNavy;
          molten_amber = steelborePalette.moltenAmber;
          steel_blue = steelborePalette.steelBlue;
          radium_green = steelborePalette.radiumGreen;
          red_oxide = steelborePalette.redOxide;
          liquid_coolant = steelborePalette.liquidCool;
        };

        directory = {
          style = "bold steel_blue";
          truncate_to_repo = true;
        };

        character = {
          success_symbol = "[➜](bold radium_green)";
          error_symbol = "[✗](bold red_oxide)";
        };

        git_branch = {
          style = "bold liquid_coolant";
          symbol = " ";
        };

        git_status = {
          style = "bold red_oxide";
          format = "([\\[$all_status$ahead_behind\\]]($style) )";
        };

        cmd_duration = {
          style = "bold molten_amber";
          min_time = 2000;
        };
      };
    };

    # Nushell configuration
    nushell = {
      enable = true;
      configFile.text = ''
        $env.config = {
          show_banner: false,
          ls: { use_ls_colors: true, clickable_links: true },
          cursor_shape: { emacs: block, vi_insert: block, vi_normal: block },
        }

        # Steelbore Telemetry Aliases
        alias ll = ls -l
        alias lla = ls -la
        alias telemetry = macchina
        alias sensors = watch -n 1 sensors
        alias sys-logs = journalctl -p 3 -xb
        alias network-diag = gping google.com
        alias top-processes = bottom
        alias disk-telemetry = yazi
        alias edit = hx

        # Project Steelbore Identity
        def steelbore [] {
          print "╔══════════════════════════════════════════════════════╗"
          print "║  STEELBORE :: Industrial Sci-Fi Utility Environment  ║"
          print "╠══════════════════════════════════════════════════════╣"
          print "║  STATUS    :: ACTIVE                                 ║"
          print "║  LOAD      :: NOMINAL                                ║"
          print "║  INTEGRITY :: VERIFIED                               ║"
          print "╚══════════════════════════════════════════════════════╝"
        }
      '';
    };

    # Alacritty (Steelbore theme)
    alacritty = {
      enable = true;
      settings = {
        window = {
          padding = { x = 10; y = 10; };
          dynamic_title = true;
          opacity = 0.95;
        };
        font = {
          normal = { family = "JetBrains Mono"; style = "Regular"; };
          size = 12.0;
        };
        colors = {
          primary = {
            background = steelborePalette.voidNavy;
            foreground = steelborePalette.moltenAmber;
          };
          cursor = {
            text = steelborePalette.voidNavy;
            cursor = steelborePalette.moltenAmber;
          };
          selection = {
            text = steelborePalette.voidNavy;
            background = steelborePalette.steelBlue;
          };
          normal = {
            black = steelborePalette.voidNavy;
            red = steelborePalette.redOxide;
            green = steelborePalette.radiumGreen;
            yellow = steelborePalette.moltenAmber;
            blue = steelborePalette.steelBlue;
            magenta = steelborePalette.steelBlue;
            cyan = steelborePalette.liquidCool;
            white = steelborePalette.moltenAmber;
          };
          bright = {
            black = steelborePalette.steelBlue;
            red = steelborePalette.redOxide;
            green = steelborePalette.radiumGreen;
            yellow = steelborePalette.moltenAmber;
            blue = steelborePalette.liquidCool;
            magenta = steelborePalette.liquidCool;
            cyan = steelborePalette.liquidCool;
            white = steelborePalette.moltenAmber;
          };
        };
      };
    };
  };

  # XDG config files
  xdg.configFile = {
    # Niri user config (inherits from system, adds user preferences)
    "niri/config.kdl".text = ''
      // User-specific Niri overrides
      // System config at /etc/niri/config.kdl provides base configuration

      layout {
          focus-ring {
              enable
              width 2
              active-color "${steelborePalette.moltenAmber}"
              inactive-color "${steelborePalette.steelBlue}"
          }
          border { off }
          gaps 8
      }

      spawn-at-startup "swaybg" "-c" "${steelborePalette.voidNavy}"
      spawn-at-startup "ironbar"
      spawn-at-startup "wired"

      binds {
          Mod+Shift+E { quit; }
          Mod+Return { spawn "alacritty"; }
          Mod+D { spawn "onagre"; }
          Mod+Q { close-window; }
          Mod+F { maximize-column; }

          Mod+H { focus-column-left; }
          Mod+L { focus-column-right; }
          Mod+K { focus-window-up; }
          Mod+J { focus-window-down; }

          Mod+Shift+H { move-column-left; }
          Mod+Shift+L { move-column-right; }
          Mod+Shift+K { move-window-up; }
          Mod+Shift+J { move-window-down; }

          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
      }
    '';

    # Ironbar user config
    "ironbar/config.yaml".text = ''
      anchor_to_edges: true
      position: top
      height: 32

      start:
        - type: workspaces
        - type: focused

      center:
        - type: clock
          format: "%H:%M:%S :: %Y-%m-%d"

      end:
        - type: sys_info
          interval: 1
          format:
            - "CPU: {cpu_percent}%"
            - "RAM: {memory_percent}%"
        - type: tray
    '';

    "ironbar/style.css".text = ''
      * {
          font-family: "Share Tech Mono", "JetBrains Mono", monospace;
          font-size: 14px;
          transition: none;
      }

      window {
          background-color: ${steelborePalette.voidNavy};
          color: ${steelborePalette.moltenAmber};
          border-bottom: 2px solid ${steelborePalette.steelBlue};
      }

      .widget {
          padding: 0 10px;
          border-left: 1px solid ${steelborePalette.steelBlue};
      }

      .workspaces button {
          color: ${steelborePalette.steelBlue};
          border-bottom: 2px solid transparent;
      }

      .workspaces button.active {
          color: ${steelborePalette.moltenAmber};
          border-bottom: 2px solid ${steelborePalette.moltenAmber};
      }

      .clock {
          color: ${steelborePalette.moltenAmber};
          font-weight: bold;
      }

      .sys_info {
          color: ${steelborePalette.radiumGreen};
      }
    '';

    # WezTerm user config
    "wezterm/wezterm.lua".text = ''
      local wezterm = require 'wezterm'
      return {
        font = wezterm.font 'JetBrains Mono',
        font_size = 12.0,
        window_background_opacity = 0.95,
        colors = {
          foreground = "${steelborePalette.moltenAmber}",
          background = "${steelborePalette.voidNavy}",
          cursor_bg = "${steelborePalette.moltenAmber}",
          cursor_fg = "${steelborePalette.voidNavy}",
          selection_bg = "${steelborePalette.steelBlue}",
          selection_fg = "${steelborePalette.voidNavy}",
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
        }
      }
    '';

    # Rio user config
    "rio/config.toml".text = ''
      [style]
      font = "JetBrains Mono"
      font-size = 14

      [colors]
      background = '${steelborePalette.voidNavy}'
      foreground = '${steelborePalette.moltenAmber}'
      cursor = '${steelborePalette.moltenAmber}'
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
    '';
  };
}
```

---

## 13. Verification Plan

### 13.1 Build Verification

```bash
# Check flake validity
nix flake check

# Show flake outputs
nix flake show

# Dry-run build
nixos-rebuild dry-build --flake .#lattice

# Build without switching
nixos-rebuild build --flake .#lattice

# Switch to new configuration
sudo nixos-rebuild switch --flake .#lattice
```

### 13.2 Desktop Environment Verification

| Desktop | Verification Command | Expected Result |
| ------- | -------------------- | --------------- |
| GNOME | `gnome-session --version` | Session starts on Wayland |
| COSMIC | `cosmic-session --version` | Session starts with panel |
| Niri | `niri --version` | WM starts with Ironbar |
| LeftWM | `leftwm --version` | WM starts with Polybar |

### 13.3 Steelbore Standard Compliance

- [ ] **§2** Metallurgical naming: `Lattice` (crystal structure)
- [ ] **§3.1** Memory safety: Rust-first packages, sudo-rs
- [ ] **§3.2** Performance: XanMod kernel, x86-64-v4 flags
- [ ] **§3.3** Security: Sequoia PGP, polkit, secure boot ready
- [ ] **§4** License: GPL-3.0-or-later, SPDX headers
- [ ] **§6** PFA: No telemetry, local storage default
- [ ] **§7** Key bindings: CUA + Vim (hjkl) in all WMs
- [ ] **§8** Color palette: Void Navy background everywhere
- [ ] **§9** Typography: Share Tech Mono, JetBrains Mono
- [ ] **§11** Date/Time: ISO 8601, 24h, UTC

---

## 14. Migration Checklist

1. [ ] Create new directory structure
2. [ ] Write `lib/default.nix` with helpers
3. [ ] Implement core modules (`boot`, `nix`, `locale`, `audio`, `security`)
4. [ ] Implement theme modules (`colors`, `fonts`)
5. [ ] Implement hardware modules (`fingerprint`, `intel`)
6. [ ] Implement desktop modules (`gnome`, `cosmic`, `niri`, `leftwm`)
7. [ ] Implement login module (`greetd`)
8. [ ] Implement package modules (10 categories)
9. [ ] Implement user configuration (`mj`)
10. [ ] Write `flake.nix` with all inputs
11. [ ] Copy `hardware.nix` from current system
12. [ ] Run `nix flake check`
13. [ ] Run `nixos-rebuild dry-build --flake .#lattice`
14. [ ] Run `nixos-rebuild switch --flake .#lattice`
15. [ ] Verify all four desktop environments boot
16. [ ] Verify Steelbore theme applies to all surfaces

---

## 15. Package Summary

### 15.1 Total Package Count by Category

| Category | Rust | Other | Total |
| -------- | ---- | ----- | ----- |
| Browsers | 0 | 5 | 5 |
| Terminals | 4 | 5 | 9 |
| Editors | 6 | 9 | 15 |
| Development | 10 | 8 | 18 |
| Security | 9 | 4 | 13 |
| Networking | 12 | 8 | 20 |
| Multimedia | 12 | 3 | 15 |
| Productivity | 4 | 5 | 9 |
| System | 45 | 20 | 65 |
| AI | 2 | 5 | 7 |
| **Total** | **104** | **72** | **176** |

### 15.2 Desktop Environment Summary

| Desktop | Protocol | Bar | Launcher | Notification |
| ------- | -------- | --- | -------- | ------------ |
| GNOME | Wayland | GNOME Shell | GNOME | GNOME |
| COSMIC | Wayland | cosmic-panel | cosmic-launcher | cosmic-notifications |
| Niri | Wayland | Ironbar | onagre/anyrun | wired |
| LeftWM | X11 | Polybar | rlaunch/rofi | dunst |

---

<!-- markdownlint-disable-next-line MD036 -->
*─── Forged in Steelbore ───*
