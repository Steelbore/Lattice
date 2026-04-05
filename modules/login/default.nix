# SPDX-License-Identifier: GPL-3.0-or-later
# Steelbore Lattice — greetd + tuigreet Login Manager
{ config, lib, pkgs, steelborePalette, ... }:

{
  # greetd display manager with tuigreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.tuigreet}/bin/tuigreet \
            --time \
            --time-format "%Y-%m-%d %H:%M:%S" \
            --remember \
            --remember-session \
            --asterisks \
            --greeting "STEELBORE :: LATTICE" \
            --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions:${config.services.displayManager.sessionData.desktops}/share/xsessions
        '';
        user = "greeter";
      };
    };
  };

  # Ensure session packages are registered
  # Note: leftwm is not included here because it lacks passthru.providedSessions.
  # LeftWM sessions are registered automatically via services.xserver.windowManager.leftwm.enable.
  # GNOME sessions are registered automatically via services.desktopManager.gnome.enable.
  services.displayManager.sessionPackages = with pkgs; [
    niri
    cosmic-session
  ];

  # tuigreet configuration directory with Steelbore theming
  # Note: LeftWM sessions are auto-discovered from xsessions directory
  environment.etc."greetd/environments".text = ''
    niri-session
    start-cosmic
    gnome-session
  '';

  environment.systemPackages = with pkgs; [
    tuigreet
  ];

  # PAM configuration for greetd
  security.pam.services.greetd.enableGnomeKeyring = true;
}
