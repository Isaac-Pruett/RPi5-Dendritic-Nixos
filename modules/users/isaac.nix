{ self, ... }:

{
  flake.nixosModules.isaac =
    { pkgs, ... }:
    {
      users.users.isaac = {
        isNormalUser = true;
        description = "Isaac";

        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        hashedPassword = "$y$j9T$347eNzn/hAlwANwJKIWt8/$VykLNHB6zt3uB2Z4d2VbrXDAIQZM/h4tBh65yGRHhV9";
      };

      home-manager.users.isaac = {
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
        };
      };
    };
}
