# modules/features/base.nix
{ self, ... }:
{
  flake.nixosModules.base =
    { pkgs, hostname, ... }:
    let
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICu6nS96uOLf4wQ+W6Uncnjh276dffhewG9zxeqQ7YSi isaac"
      ];
    in
    {

      time.timeZone = "America/Los_Angeles";
      console.keyMap = "us";
      i18n.defaultLocale = "en_US.UTF-8";

      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "prohibit-password";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };

      # mDNS so `athena.local` resolves on the LAN.
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        publish = {
          enable = true;
          addresses = true;
          workstation = true;
        };
      };

      security.sudo.wheelNeedsPassword = false;
      users.mutableUsers = false;
      users.users.root.openssh.authorizedKeys.keys = authorizedKeys;
      users.users.isaac = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = authorizedKeys;
      };

      programs.zsh.enable = true;

      environment.systemPackages = with pkgs; [
        tailscale
        git
        helix
        tmux
        btop
        gh
      ];

      users.motd = ''
        Hello from NixOS on Raspberry Pi!
      '';

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      system.stateVersion = "25.11";
    };
}
