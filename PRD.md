# Lattice — Product Requirements Document

**Project:** Lattice (A Steelbore NixOS Distribution)
**Version:** 2.1 | **Date:** 2026-04-05
**Author:** Mohamed Hammad | **License:** GPL-3.0-or-later
**Status:** Implemented

---

## 1. Executive Summary

Lattice is a flake-based NixOS configuration implementing the Steelbore Standard. This PRD defines a complete system with a modular, opt-in architecture supporting four desktop environments: GNOME (Wayland), COSMIC (Wayland), Niri (Wayland), and LeftWM (X11).

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
│   │   └── default.nix            # greetd + tuigreet
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

## 4. Login Manager

### 4.1 greetd + tuigreet

The system uses `greetd` with `tuigreet` as the display manager:

```nix
# modules/login/default.nix
services.greetd = {
  enable = true;
  settings = {
    default_session = {
      command = ''
        ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --time \
          --time-format "%Y-%m-%d %H:%M:%S" \
          --remember \
          --remember-session \
          --asterisks \
          --greeting "STEELBORE :: LATTICE" \
          --sessions ${sessionPaths}
      '';
      user = "greeter";
    };
  };
};
```

**Features:**
- ISO 8601 date/time format
- Session memory (remembers last selected session)
- Password asterisks for visual feedback
- Steelbore branding in greeting message
- All four desktop sessions available

---

## 5. Terminal Emulators

All terminal emulators are configured with the Steelbore color palette:

### 5.1 Supported Terminals

| Terminal     | Language | Config Location                    | Theme Status |
|--------------|----------|-------------------------------------|--------------|
| Alacritty    | Rust     | `/etc/alacritty/alacritty.toml`    | Configured   |
| WezTerm      | Rust     | `/etc/wezterm/wezterm.lua`         | Configured   |
| Rio          | Rust     | `/etc/rio/config.toml`             | Configured   |
| Ghostty      | Zig      | `/etc/ghostty/config`              | Configured   |
| COSMIC Term  | Rust     | COSMIC settings                     | Configured   |
| Ptyxis       | C (VTE)  | dconf/gsettings                     | Configured   |
| WaveTerm     | Go       | `/etc/waveterm/config.json`        | Configured   |
| Warp         | Rust     | `/etc/warp/themes/steelbore.yaml`  | Configured   |
| Termius      | Various  | In-app settings                     | Manual       |

### 5.2 Common Configuration

All terminals share these settings:
- Font: JetBrains Mono 12pt
- Background opacity: 95%
- Padding: 10px
- Full Steelbore 16-color palette

---

## 6. Desktop Environments

### 6.1 Niri (Wayland — Scrolling Tiling)

**Components:**
- Compositor: Niri
- Status Bar: Ironbar
- Launcher: onagre / anyrun
- Notifications: wired
- Background: swaybg

**Key Bindings:** See USER_MANUAL.md for complete reference.

### 6.2 LeftWM (X11 — Tiling WM)

**Components:**
- Window Manager: LeftWM
- Status Bar: Polybar
- Launcher: rlaunch / rofi / dmenu
- Notifications: Dunst
- Compositor: Picom

**Key Bindings:** See USER_MANUAL.md for complete reference.

### 6.3 COSMIC (Wayland — Full Desktop)

**Components:**
- Full COSMIC desktop environment from System76
- Native cosmic-panel, cosmic-launcher, cosmic-notifications
- cosmic-term with Steelbore theming

### 6.4 GNOME (Wayland — Full Desktop)

**Components:**
- GNOME Shell on Wayland
- Selected extensions for customization
- Ptyxis terminal with Steelbore profile
- GDM disabled (uses greetd)

---

## 7. Keyboard Layout

- Primary: US English (`us`)
- Secondary: Arabic (`ara`)
- Toggle: Ctrl+Space (`grp:ctrl_space_toggle`)

Configuration location: `hosts/lattice/default.nix`

---

## 8. Hardware Modules

### 8.1 Fingerprint Reader

```nix
config = lib.mkIf config.steelbore.hardware.fingerprint.enable {
  services.fprintd.enable = true;
  environment.systemPackages = [ pkgs.fprintd ];
};
```

### 8.2 Intel Optimizations

```nix
config = lib.mkIf config.steelbore.hardware.intel.enable {
  boot.kernelModules = [ "kvm-intel" ];
  hardware.cpu.intel.updateMicrocode = true;
  environment.sessionVariables = {
    RUSTFLAGS = "-C target-cpu=x86-64-v4 -C opt-level=3";
    GOAMD64 = "v4";
    CFLAGS = "-march=x86-64-v4 -O3 -pipe -fno-plt -flto=auto";
    CXXFLAGS = "-march=x86-64-v4 -O3 -pipe -fno-plt -flto=auto";
  };
};
```

---

## 9. Package Categories

| Category     | Rust | Other | Total |
|--------------|------|-------|-------|
| Browsers     | 0    | 5     | 5     |
| Terminals    | 4    | 5     | 9     |
| Editors      | 6    | 9     | 15    |
| Development  | 10   | 8     | 18    |
| Security     | 9    | 4     | 13    |
| Networking   | 12   | 8     | 20    |
| Multimedia   | 12   | 3     | 15    |
| Productivity | 4    | 5     | 9     |
| System       | 45   | 20    | 65    |
| AI           | 2    | 5     | 7     |
| **Total**    | **104** | **72** | **176** |

---

## 10. Verification Plan

### 10.1 Build Verification

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

### 10.2 Desktop Environment Verification

| Desktop | Verification Command       | Expected Result              |
|---------|----------------------------|------------------------------|
| GNOME   | `gnome-session --version`  | Session starts on Wayland    |
| COSMIC  | `cosmic-session --version` | Session starts with panel    |
| Niri    | `niri --version`           | WM starts with Ironbar       |
| LeftWM  | `leftwm --version`         | WM starts with Polybar       |

### 10.3 Steelbore Standard Compliance

- [x] **§2** Metallurgical naming: `Lattice` (crystal structure)
- [x] **§3.1** Memory safety: Rust-first packages, sudo-rs
- [x] **§3.2** Performance: XanMod kernel, x86-64-v4 flags
- [x] **§3.3** Security: Sequoia PGP, polkit, secure boot ready
- [x] **§4** License: GPL-3.0-or-later, SPDX headers
- [x] **§6** PFA: No telemetry, local storage default
- [x] **§7** Key bindings: CUA + Vim (hjkl) in all WMs
- [x] **§8** Color palette: Void Navy background everywhere
- [x] **§9** Typography: Share Tech Mono, JetBrains Mono
- [x] **§11** Date/Time: ISO 8601, 24h, UTC

---

## 11. Desktop Environment Summary

| Desktop | Protocol | Bar      | Launcher        | Notification          |
|---------|----------|----------|-----------------|----------------------|
| GNOME   | Wayland  | Shell    | GNOME           | GNOME                |
| COSMIC  | Wayland  | Panel    | cosmic-launcher | cosmic-notifications |
| Niri    | Wayland  | Ironbar  | onagre/anyrun   | wired                |
| LeftWM  | X11      | Polybar  | rlaunch/rofi    | dunst                |

---

*--- Forged in Steelbore ---*
