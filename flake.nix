{
  description = "My nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impurity.url = "github:outfoxxed/impurity.nix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    impurity,
  }: let
    system = "aarch64-darwin";

    commonModules = [
      ./system/configuration.nix
      home-manager.darwinModules.home-manager
      {
        imports = [impurity.nixosModules.impurity];
        impurity.configRoot = self;
      }
      ({impurity, ...}: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.extraSpecialArgs = {
          inherit impurity;
          dots = self;
        };
        home-manager.users.liempo = import ./home/liempo.nix;

        users.users.liempo = {
          name = "liempo";
          home = "/Users/liempo";
        };
      })
    ];
  in {
    darwinConfigurations.workstation = nix-darwin.lib.darwinSystem {
      inherit system;
      modules =
        commonModules
        ++ [
          {impurity.enable = false;}
        ];
    };

    darwinConfigurations.workstation-impure = nix-darwin.lib.darwinSystem {
      inherit system;
      modules =
        commonModules
        ++ [
          {impurity.enable = true;}
        ];
    };
  };
}
