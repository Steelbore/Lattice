# Lattice Implementation TODO

This document tracks the implementation status of the Lattice NixOS distribution based on the [Product Requirements Document (PRD.md)](./PRD.md).

---

## Phase 1: Foundation & Structure

- [✓] Establish git repository structure
- [✓] Create `flake.nix` entry point with all inputs
- [✓] Configure stable nixpkgs (25.11)
- [✓] Configure unstable nixpkgs channel
- [✓] Configure home-manager input
- [✓] Configure nixos-cosmic input
- [✓] Configure emacs-ng input
- [✓] Define `nixosConfigurations.lattice` output
- [✓] Set up `steelborePalette` in specialArgs
- [✓] Pass `unstable` to modules via specialArgs
- [✓] Build folder hierarchy (`hosts/`, `modules/`, `lib/`, `users/`, `overlays/`)

---

## Phase 2: Core Modules (`modules/core/`)

- [✓] **`default.nix`**: Core module entry point with imports
- [✓] **`boot.nix`**: systemd-boot configuration
- [✓] **`boot.nix`**: XanMod kernel from unstable (`linuxPackages_xanmod_latest`)
- [✓] **`boot.nix`**: initrd kernel modules (xhci_pci, nvme, usb_storage, sd_mod)
- [✓] **`nix.nix`**: Enable flakes and nix-command
- [✓] **`nix.nix`**: Configure garbage collection (weekly, 30d retention)
- [✓] **`nix.nix`**: Allow unfree packages
- [✓] **`nix.nix`**: Configure COSMIC binary cache
- [✓] **`locale.nix`**: Set timezone to UTC
- [✓] **`locale.nix`**: Configure en_US.UTF-8 locale
- [✓] **`locale.nix`**: Console XKB configuration
- [✓] **`audio.nix`**: Disable PulseAudio
- [✓] **`audio.nix`**: Enable PipeWire with ALSA/Pulse compatibility
- [✓] **`audio.nix`**: Enable rtkit for realtime audio
- [✓] **`security.nix`**: Disable standard sudo
- [✓] **`security.nix`**: Enable sudo-rs (Rust implementation)
- [✓] **`security.nix`**: Enable polkit
- [✓] **`security.nix`**: Configure tmpfiles rules

---

## Phase 3: Theme Engine (`modules/theme/`)

- [✓] **`default.nix`**: Define STEELBORE_* environment variables
- [✓] **`default.nix`**: Configure TTY console colors (16-color palette)
- [✓] **`fonts.nix`**: Install Orbitron (UI headers)
- [✓] **`fonts.nix`**: Install JetBrains Mono (code/terminal)
- [✓] **`fonts.nix`**: Install Cascadia Code (fallback)
- [✓] **`fonts.nix`**: Install Nerd Fonts variants
- [✓] **`fonts.nix`**: Install Share Tech Mono (HUD/data)
- [✓] **`fonts.nix`**: Configure fontconfig defaults

---

## Phase 4: Login Management (`modules/login/`)

- [✓] **`default.nix`**: Login module entry point
- [✓] **`greetd.nix`**: Enable greetd service
- [✓] **`greetd.nix`**: Configure tuigreet with session memory
- [✓] **`greetd.nix`**: Default to Niri session
- [✓] **`greetd.nix`**: Create session selector script
- [✓] **`greetd.nix`**: Install lemurs alternative

---

## Phase 5: Desktop Environments (`modules/desktops/`)

### GNOME (`gnome.nix`)

- [✓] Define `steelbore.desktops.gnome` option
- [✓] Enable GNOME on Wayland
- [✓] Disable GDM (use greetd instead)
- [✓] Install GNOME Tweaks, dconf-editor
- [✓] Install extension manager and connector
- [✓] Install curated extensions (Caffeine, Just Perfection, etc.)
- [✓] Configure XDG portals
- [✓] Exclude bloatware (Tour, Music, Epiphany, Geary, Totem)

### COSMIC (`cosmic.nix`)

- [✓] Define `steelbore.desktops.cosmic` option
- [✓] Enable COSMIC from nixos-cosmic flake
- [✓] Disable cosmic-greeter (use greetd)
- [✓] Install core COSMIC packages (session, comp, bg, osd)
- [✓] Install panel and applets
- [✓] Install COSMIC applications (term, edit, files, store)
- [✓] Install COSMIC extensions
- [✓] Configure XDG portal

### Niri (`niri.nix`) — *The Steelbore Standard*

- [✓] Define `steelbore.desktops.niri` option
- [✓] Enable Niri compositor
- [✓] Install companion packages (swaybg, xwayland-satellite)
- [✓] Install ironbar (Rust status bar)
- [✓] Install anyrun from unstable
- [✓] Install onagre launcher
- [✓] Install wired notifications (Rust)
- [✓] Install swaylock/swayidle
- [✓] Install clipboard tools (wl-clipboard, wl-clipboard-rs)
- [✓] Install screenshot tools (grim, slurp)
- [✓] Write `/etc/niri/config.kdl` with Steelbore palette
- [✓] Write `/etc/ironbar/config.yaml`
- [✓] Write `/etc/ironbar/style.css` with Steelbore theme
- [✓] Configure keybindings (Vim-style + arrows)
- [✓] Configure workspaces 1-5
- [✓] Configure startup applications

### LeftWM (`leftwm.nix`)

- [✓] Define `steelbore.desktops.leftwm` option
- [✓] Enable X11 and LeftWM
- [✓] Configure XKB layout (us,ar)
- [✓] Install LeftWM packages (leftwm, leftwm-theme, leftwm-config)
- [✓] Install rlaunch from unstable
- [✓] Install rofi and dmenu
- [✓] Install polybar
- [✓] Install picom compositor
- [✓] Install utilities (feh, dunst, xclip, maim, xdotool)
- [✓] Write `/etc/leftwm/config.ron` with keybindings
- [✓] Write `/etc/leftwm/themes/current/theme.ron` with Steelbore colors
- [✓] Write `/etc/leftwm/themes/current/up` startup script
- [✓] Write `/etc/leftwm/themes/current/down` shutdown script
- [✓] Write `/etc/leftwm/themes/current/polybar.ini` with Steelbore theme
- [✓] Write `/etc/leftwm/themes/current/template.liquid` for tags
- [✓] Write `/etc/leftwm/themes/current/picom.conf`
- [✓] Write `/etc/dunst/dunstrc` with Steelbore theme

---

## Phase 6: Package Modules (`modules/packages/`)

### Infrastructure

- [✓] **`default.nix`**: Package module entry with imports

### browsers.nix

- [✓] Define `steelbore.packages.browsers` option
- [✓] Enable Firefox via programs.firefox
- [✓] Install browsers from unstable (Chrome, Brave, Edge, Librewolf)

### terminals.nix

- [✓] Define `steelbore.packages.terminals` option
- [✓] Install Rust terminals (Alacritty, WezTerm, Rio)
- [✓] Install Ghostty (Zig, memory-safe)
- [✓] Install unstable terminals (ptyxis, waveterm, warp-terminal)
- [✓] Install Termius and cosmic-term
- [✓] Write `/etc/alacritty/alacritty.toml` with Steelbore theme
- [✓] Write `/etc/wezterm/wezterm.lua` with Steelbore theme
- [✓] Write `/etc/rio/config.toml` with Steelbore theme

### editors.nix

- [✓] Define `steelbore.packages.editors` option
- [✓] Install Rust TUI editors (Helix, Amp, msedit)
- [✓] Install standard TUI editors (Neovim, Vim, mg, mc)
- [✓] Install Rust GUI editors (Zed, Lapce, Neovide, cosmic-edit)
- [✓] Install standard GUI editors (Emacs-ng, VSCode, VSCodium, Cursor)

### development.nix

- [✓] Define `steelbore.packages.development` option
- [✓] Install Git and Rust tools (gitui, delta, jujutsu)
- [✓] Install gh from unstable
- [✓] Install Rust toolchain (rustup, cargo)
- [✓] Install build tools (just, sad, pueue, tokei)
- [✓] Install environment tools (lorri, dotter)
- [✓] Install languages (JDK, PHP)
- [✓] Install Nix ecosystem (nixfmt, cachix, guix)
- [✓] Configure system Git defaults

### security.nix

- [✓] Define `steelbore.packages.security` option
- [✓] Install Rust encryption (age, rage)
- [✓] Install sops for secrets
- [✓] Install Sequoia PGP stack (sq, chameleon, wot, sqv, sqop)
- [✓] Install password managers (rbw, bitwarden-cli/desktop from unstable)
- [✓] Install authenticator (Rust 2FA)
- [✓] Install SSH tools
- [✓] Install pika-backup from unstable
- [✓] Install sbctl (Secure Boot)

### networking.nix

- [✓] Define `steelbore.packages.networking` option
- [✓] Install network management (impala, iwd)
- [✓] Install HTTP clients (xh, monolith, curl, wget2)
- [✓] Install Rust diagnostics (gping, trippy, lychee, rustscan)
- [✓] Install GUI tools (sniffnet, mullvad-vpn, rqbit from unstable)
- [✓] Install download managers (aria2, uget)
- [✓] Install DNS tools (dnsmasq, adguardhome)

### multimedia.nix

- [✓] Define `steelbore.packages.multimedia` option
- [✓] Install video players (mpv, vlc, cosmic-player)
- [✓] Install Rust audio (amberol, termusic, ncspot, psst, shortwave)
- [✓] Install Rust image viewers (loupe, viu, emulsion)
- [✓] Install mousai (audio recognition)
- [✓] Install processing tools (rav1e, gifski, oxipng, gyroflow)
- [✓] Install ffmpeg and yt-dlp

### productivity.nix

- [✓] Define `steelbore.packages.productivity` option
- [✓] Install Rust knowledge tools (AppFlowy, Affine)
- [✓] Install office suites (LibreOffice, OnlyOffice)
- [✓] Install Rust communication (iamb, fractal, newsflash)
- [✓] Install tutanota-desktop from unstable
- [✓] Install onedriver

### system.nix

- [✓] Define `steelbore.packages.system` option
- [✓] Install modern Unix (fd, ripgrep, bat, eza, sd, zoxide, procs, dust, dua)
- [✓] Install uutils (coreutils, diffutils, findutils)
- [✓] Install file managers (yazi, broot, superfile, spacedrive from unstable)
- [✓] Install disk tools (disktui from unstable, gptman)
- [✓] Install monitoring (bottom, kmon, macchina, bandwhich, mission-center)
- [✓] Install standard monitoring (htop, btop, gotop, fastfetch)
- [✓] Install text processing (jaq, teip, htmlq, skim, tealdeer, mdcat, difftastic)
- [✓] Install Rust shells (nushell, brush, ion, starship, atuin, pipr)
- [✓] Install moor and powershell from unstable
- [✓] Install multiplexers (zellij, screen)
- [✓] Install t-rec (terminal recorder)
- [✓] Install containers (distrobox, boxbuddy, qemu, flatpak)
- [✓] Install system management (topgrade, paru, doas, xremap)
- [✓] Install archiving (p7zip, zip, unzip, ouch)
- [✓] Install ZFS tools and antigravity from unstable
- [✓] Install benchmarking tools
- [✓] Enable Flatpak service

### ai.nix

- [✓] Define `steelbore.packages.ai` option
- [✓] Install Rust AI tools (aichat, gemini-cli)
- [✓] Install opencode
- [✓] Install unstable AI tools (codex, copilot-cli, gpt-cli, mcp-nixos)
- [✓] Install claude-code from **stable** (not unstable, due to issues)

---

## Phase 7: Hardware Modules (`modules/hardware/`)

- [✓] **`default.nix`**: Hardware module entry point
- [✓] **`fingerprint.nix`**: Define option and enable fprintd
- [✓] **`intel.nix`**: Define option
- [✓] **`intel.nix`**: Enable kvm-intel module
- [✓] **`intel.nix`**: Configure microcode updates
- [✓] **`intel.nix`**: Set x86-64-v4 optimization flags (RUSTFLAGS, CFLAGS, etc.)

---

## Phase 8: Host & User Configuration

### Host (`hosts/lattice/`)

- [✓] **`default.nix`**: Set hostname to "lattice"
- [✓] **`default.nix`**: Enable NetworkManager
- [✓] **`default.nix`**: Configure X11 keyboard layout
- [✓] **`default.nix`**: Enable printing
- [✓] **`default.nix`**: Create user "mj" with groups
- [✓] **`default.nix`**: Set shell to nushell
- [✓] **`default.nix`**: Enable all steelbore desktop modules
- [✓] **`default.nix`**: Enable all steelbore hardware modules
- [✓] **`default.nix`**: Enable all steelbore package modules
- [✓] **`default.nix`**: Set stateVersion to 25.11
- [✓] **`hardware.nix`**: Import from modulesPath
- [✓] **`hardware.nix`**: Configure root filesystem (ext4, UUID)
- [✓] **`hardware.nix`**: Configure boot filesystem (vfat, UUID)
- [✓] **`hardware.nix`**: Set hostPlatform to x86_64-linux

### User (`users/mj/`)

- [✓] **`default.nix`**: Define user account
- [✓] **`home.nix`**: Set username and home directory
- [✓] **`home.nix`**: Create steelbore symlink
- [✓] **`home.nix`**: Configure keyboard layout
- [✓] **`home.nix`**: Set session variables (EDITOR, VISUAL)
- [✓] **`home.nix`**: Configure Git with GPG signing (Sequoia)
- [✓] **`home.nix`**: Configure Starship with Steelbore palette
- [✓] **`home.nix`**: Configure Nushell with aliases
- [✓] **`home.nix`**: Configure Alacritty with Steelbore colors
- [✓] **`home.nix`**: Write XDG config for Niri
- [✓] **`home.nix`**: Write XDG config for Ironbar
- [✓] **`home.nix`**: Write XDG config for WezTerm
- [✓] **`home.nix`**: Write XDG config for Rio

---

## Phase 9: Overlays

- [✓] **`overlays/default.nix`**: Create overlay file
- [✓] **`overlays/default.nix`**: Disable sequoia-wot tests (build fix)

---

## Phase 10: Testing & Verification

- [ ] Run `nix flake check` without errors
- [ ] Run `nixos-rebuild dry-build --flake .#lattice` successfully
- [ ] Run `nixos-rebuild build --flake .#lattice` successfully
- [ ] Run `nixos-rebuild switch --flake .#lattice` successfully
- [ ] Verify Niri session boots and displays correctly
- [ ] Verify COSMIC session boots and displays correctly
- [ ] Verify GNOME session boots and displays correctly
- [ ] Verify LeftWM session boots and displays correctly
- [ ] Verify greetd/tuigreet login works
- [ ] Verify Steelbore palette applies to TTY
- [ ] Verify Steelbore palette applies to Alacritty
- [ ] Verify Steelbore palette applies to Ironbar
- [ ] Verify Steelbore palette applies to Polybar
- [ ] Verify sudo-rs works for privilege escalation
- [ ] Verify fingerprint authentication works

---

## Phase 11: Documentation

- [✓] **README.md**: Project overview and quick start
- [✓] **ARCHITECTURE.md**: System diagrams and data flow
- [✓] **TODO.md**: Implementation checklist (this file)
- [✓] **PRD.md**: Product requirements (reference document)

---

## Known Issues & Notes

1. **COSMIC packages**: Show `useFetchCargoVendor` deprecation warnings during flake check — these are harmless and come from the nixos-cosmic flake.

2. **claude-code**: Must use stable channel, not unstable — unstable version has build/runtime issues.

3. **XanMod kernel**: Sourced from unstable channel for latest version.

4. **sequoia-wot**: Tests disabled via overlay due to build failures.

---

## Summary

| Phase | Status | Progress |
|-------|--------|----------|
| 1. Foundation | Complete | 11/11 |
| 2. Core Modules | Complete | 17/17 |
| 3. Theme Engine | Complete | 7/7 |
| 4. Login Management | Complete | 5/5 |
| 5. Desktop Environments | Complete | 48/48 |
| 6. Package Modules | Complete | 63/63 |
| 7. Hardware Modules | Complete | 6/6 |
| 8. Host & User Config | Complete | 25/25 |
| 9. Overlays | Complete | 2/2 |
| 10. Testing | Pending | 0/15 |
| 11. Documentation | Complete | 4/4 |
| **Total** | **93%** | **188/203** |

---

*Last updated: 2026-04-03*
