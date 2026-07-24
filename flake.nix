{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  inputs.vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";

  outputs = { self, nixpkgs, vpn-confinement }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
      	  ./configuration.nix
          vpn-confinement.nixosModules.default
      ];
    };
  };
}
