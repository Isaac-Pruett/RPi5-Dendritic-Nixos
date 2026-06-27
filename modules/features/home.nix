# modules/features/home.nix
{ self, inputs, ... }:
{
  flake.nixosModules.home =
    { ... }:
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

    };
}
