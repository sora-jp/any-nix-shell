{
  description = "Flake providing any-nix-shell";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages.any-nix-shell = pkgs.stdenv.mkDerivation rec {
          pname = "any-nix-shell";
          version = "1.2.1";
          src = self;
          strictDeps = true;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          buildInputs = [ pkgs.bash ];
          installPhase = ''
            mkdir -p $out/bin
            cp -r bin $out
            wrapProgram $out/bin/any-nix-shell --prefix PATH ":" $out/bin
          '';

          meta = with pkgs.lib; {
            description = "fish and zsh support for nix-shell";
            license = licenses.mit;
            homepage = "https://github.com/haslersn/any-nix-shell";
            maintainers = with maintainers; [ haslersn ];
            mainProgram = "any-nix-shell";
          };
        };
        devShells.default = pkgs.mkShell {
          buildInputs = [packages.any-nix-shell];
        };
    });
}
