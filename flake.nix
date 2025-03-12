{
  description = "Scraping stars";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      eachSystem = nixpkgs.lib.genAttrs supportedSystems;
      forPkgs =
        fn:
        nixpkgs.lib.mapAttrs (system: pkgs: (fn pkgs)) (
          nixpkgs.lib.getAttrs supportedSystems nixpkgs.legacyPackages
        );
    in
    {
      packages = forPkgs (pkgs: {
        default = pkgs.callPackage ./default.nix { };
      });

      devShells = eachSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default =
            with pkgs;
            mkShell {
              buildInputs = [
                (python3.withPackages (
                  ps: with ps; [
                    beautifulsoup4
                    ipython
                    python-lsp-server
                    requests
                  ]
                ))
              ];
            };
        }
      );
    };
}
