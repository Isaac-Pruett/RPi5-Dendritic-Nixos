# modules/features/sunshine.nix
{ self, inputs, ... }:
{
  flake.nixosModules.sunshine =
    { ... }:
    {
      services.sunshine = {
        enable = true;
        autoStart = true;
        capSysAdmin = true; # Wayland/DRM capture; omit or set false for Xorg
        openFirewall = true;
      };
    };
}
