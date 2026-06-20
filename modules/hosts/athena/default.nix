{ self, inputs, ... }:
let
  hostname = import ../../../hostname.nix;
  specialArgs = {
    inherit (inputs) nixos-raspberrypi;
    inherit hostname;
  };
in
{
  flake.nixosConfigurations = rec {
    athena = inputs.nixos-raspberrypi.lib.nixosSystem {
      inherit specialArgs;
      modules = [
        inputs.agenix.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        self.nixosModules.athenaConfiguration
        self.nixosModules.athenaHardware
      ];
    };

    default = athena;

    athena-installer = inputs.nixos-raspberrypi.lib.nixosInstaller {
      inherit specialArgs;
      modules = [
        inputs.agenix.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        self.nixosModules.athenaConfiguration
      ];
    };
  };

  flake.packages.aarch64-linux.sd-image =
    self.nixosConfigurations.athena-installer.config.system.build.sdImage;
  flake.packages.x86_64-linux.sd-image =
    self.nixosConfigurations.athena-installer.config.system.build.sdImage;
}
