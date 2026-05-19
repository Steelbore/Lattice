# Changelog

All notable changes to Bravais are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added

- **nix-ld enabled** (`programs.nix-ld.enable = true` in `modules/packages/development.nix`) — allows running unpatched dynamic binaries (npm packages, Python wheels with native extensions, VS Code server, pre-built toolchains).
- **Adit flake input placeholder** in `flake.nix` — commented-out `adit` input with activation checklist for when Adit (Spacecraft Software's universal SSH_ASKPASS helper) ships its flake.

### Fixed

- **Ptyxis `tty: ttyname error: No such device`** — removed `use-custom-command` / `custom-command` from the Ptyxis dconf profile. VTE now resolves the login shell via `getpwuid()` (nushell, set system-wide) and connects it to the PTY correctly, eliminating the `ttyname()` failure.

### Changed

- **Project renamed: Lattice → Bravais** (full name: *Steelbore OS Bravais*).
  The crystallography theme is preserved — a Bravais lattice is a kind of
  lattice — and every identifier follows: `mkLattice` → `mkBravais`, all 10
  `nixosConfigurations` keys (`bravais`, `bravais-v{1..4}`,
  `bravais-unstable`, `bravais-unstable-v{1..4}`), `networking.hostName`,
  the working-tree path (`/steelbore/lattice` → `/steelbore/bravais`), the
  GitHub repo (`Spacecraft-Software/Lattice` → `Spacecraft-Software/Bravais`), all module
  headers, the greetd greeting (`STEELBORE :: BRAVAIS`), and every
  documentation file. `v0/` is intentionally left untouched as a frozen
  pre-flake snapshot of the old name; see `v0/README.md`.

## [2.1.0] — 2026-04-05

### Added

- **greetd + tuigreet login manager** — Professional graphical login replacing TTY-first boot
  - ISO 8601 date/time display (`%Y-%m-%d %H:%M:%S`)
  - Session memory (remembers last selected desktop)
  - Password asterisks for visual feedback
  - Steelbore branding in greeting message
  - PAM integration for GNOME Keyring

- **Steelbore themes for all terminal emulators**
  - Ghostty configuration (`/etc/ghostty/config`)
  - WaveTerm JSON configuration (`/etc/waveterm/config.json`)
  - Warp Terminal YAML theme (`/etc/warp/themes/spacecraft.yaml`)
  - COSMIC Term theme reference
  - Ptyxis dconf profile with full 16-color palette

- **USER_MANUAL.md** — Comprehensive user documentation
  - Complete Niri keybinding reference
  - Complete LeftWM keybinding reference
  - COSMIC and GNOME quick start guides
  - Terminal emulator comparison and usage
  - Shell configuration (Nushell aliases)
  - System administration commands
  - Troubleshooting guide
  - Quick reference card

- **Enhanced Niri keybindings**
  - Arrow key alternatives for all navigation
  - Workspaces 6-9 support
  - Mouse wheel workspace switching
  - Screenshot keybindings (Print, Mod+Print)

- **Enhanced home.nix XDG configurations**
  - User-level Ghostty config
  - User-level WezTerm config with tab bar theming
  - User-level Rio config
  - Ironbar status bar configuration

### Changed

- **modules/login/default.nix** — Complete rewrite from TTY script to greetd service
- **modules/packages/terminals.nix** — Expanded from 3 to 8 terminal configurations
- **users/mj/home.nix** — Added dconf settings, expanded XDG configs
- **PRD.md** — Updated to version 2.1, reflecting actual implementation
- **implementation_plan.md** — Converted to implementation status document

### Fixed

- **XKB layout conflict** — Removed duplicate keyboard layout from leftwm.nix
  - Host configuration (`us,ara`) is now the single source of truth
  - Desktop modules no longer set conflicting layouts

### Removed

- TTY-first `gui` session selector script (replaced by greetd)

---

## [2.0.0] — 2026-04-02

### Added

- **Complete architecture rewrite** — Modular, opt-in design with `steelbore.*` namespace
- **Four desktop environments**
  - Niri (Wayland) — Scrolling tiling compositor with Ironbar
  - LeftWM (X11) — Tiling WM with Polybar
  - COSMIC (Wayland) — Full desktop from System76
  - GNOME (Wayland) — Full desktop with extensions

- **Steelbore color palette** — Unified theming across all components
  - Void Navy (`#000027`) — Mandatory background
  - Molten Amber (`#D98E32`) — Primary text
  - Steel Blue (`#4B7EB0`) — Accents
  - Radium Green (`#50FA7B`) — Success
  - Red Oxide (`#FF5C5C`) — Errors
  - Liquid Coolant (`#8BE9FD`) — Info

- **Module categories**
  - `steelbore.desktops.*` — Desktop environments
  - `steelbore.hardware.*` — Hardware support (fingerprint, Intel)
  - `steelbore.packages.*` — Application bundles (10 categories)

- **Terminal configurations**
  - Alacritty with Steelbore theme
  - WezTerm with Steelbore theme
  - Rio with Steelbore theme

- **Home Manager integration**
  - Starship prompt with Steelbore palette
  - Nushell configuration with aliases
  - Git configuration with SSH signing

- **PRD.md** — Product Requirements Document
- **implementation_plan.md** — Architecture and migration plan

### Changed

- Migrated from monolithic configuration to modular flake structure
- Replaced sudo with sudo-rs (Rust implementation)
- Updated to XanMod kernel

---

## [1.0.0] — 2026-03-15

### Added

- Initial NixOS flake configuration
- Basic GNOME desktop support
- Home Manager for user configuration
- Hardware configuration for bravais host

---

*--- Forged in Spacecraft Software ---*
