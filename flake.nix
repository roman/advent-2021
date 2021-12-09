{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
        {
          devShell = pkgs.mkShell {
            buildInputs = builtins.attrValues {
              inherit (pkgs) go_1_17 ghc cargo ruby jdk clojure;
            };
          };
        }
    );
}
