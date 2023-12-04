{
  description = "Flake for building NixOS images";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, ... }@inputs:
    let
      nodes = {
        "my-new-pc" = { system = "x86_64-linux"; format = "isoImage"; };
      };

      osConfigs = builtins.mapAttrs
        (name: value: inputs.nixpkgs.lib.nixosSystem {
          system = value.system;
          modules = [
            (./. + "/hosts/${name}.nix")
          ];
          specialArgs = {
            inherit inputs;
          };
        }) nodes;

      images = builtins.mapAttrs
        (name: value: value.config.system.build.${ nodes.${name}.format }) osConfigs;
    in
    {
      nixosConfigurations = ({} // osConfigs);
    } // inputs.utils.lib.eachDefaultSystem
      (system:
        {
          packages.image = images;
        }
      );
}
