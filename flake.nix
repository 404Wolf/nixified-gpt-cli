{
  description = "Application packaged using poetry2nix";

  inputs = {
    flake-utils = { url = "github:numtide/flake-utils"; };
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        poetry = (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; });
      in rec {
        LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";

        packages = {
          myapp = poetry.mkPoetryApplication {
            inherit LD_LIBRARY_PATH;
            overrides = poetry.overrides.withDefaults
              (final: prev: { buildInputs = [ pkgs.llama-cpp ]; });
            projectDir = ./.;
            preferWheels = true;
          };
          default = self.packages.${system}.myapp;
        };

        # `nix develop`
        devShells.default = pkgs.mkShell {
          inherit LD_LIBRARY_PATH;
          inputsFrom = [ self.packages.${system}.myapp ];
        };

        # `nix .#poetry`
        devShells.poetry = pkgs.mkShell {
          inherit LD_LIBRARY_PATH;
          packages = [ pkgs.poetry ];
        };
      });
}

