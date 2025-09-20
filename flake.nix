{
  description = "A pure vim configuration with batteries included";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Neovim itself
          neovim

          # LSPs
          lua-language-server
          rust-analyzer
          nodePackages.typescript-language-server

          # Formatters
          stylua
        ];
      };
    };
}
