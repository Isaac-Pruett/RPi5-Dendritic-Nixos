{ self, ... }:
{
  flake.nixosModules.athenaHardware =
    { ... }:
    {
      fileSystems."/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
      };
      fileSystems."/boot/firmware" = {
        device = "/dev/disk/by-label/FIRMWARE";
        fsType = "vfat";
        neededForBoot = true;
      };
    };
}
