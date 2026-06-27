{ self, inputs, ... }:
{
  flake.nixosModules.athenaConfiguration =
    { ... }:
    {
      nixpkgs.config.allowUnfree = true;

      imports = [
        self.nixosModules.rpi5
        self.nixosModules.base
        self.nixosModules.networking
        self.nixosModules.home
        self.nixosModules.isaac
      ];
    };
}
