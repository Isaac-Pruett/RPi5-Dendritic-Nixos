# modules/features/home.nix
{ self, inputs, ... }:
{
  flake.nixosModules.home =
    { ... }:
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.isaac =
        { pkgs, ... }:
        {
          home.username = "isaac";
          home.homeDirectory = "/home/isaac";
          home.stateVersion = "25.11";

          home.packages = with pkgs; [
            git
            helix
            btop
            tailscale
            tmux
            gh
          ];

          programs.zsh = {
            enable = true;
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;

            shellAliases = {
              update = "sudo nixos-rebuild switch --flake .#";
            };

            history.size = 100;
            history.ignoreAllDups = true;
            history.path = "$HOME/.zsh_history";
          };

        };
    };
}
