{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      eachSystem = nixpkgs.lib.genAttrs supportedSystems;
      pkgsBySystem = nixpkgs.lib.getAttrs supportedSystems nixpkgs.legacyPackages;

      forAllPkgs = fn: nixpkgs.lib.mapAttrs (system: pkgs: (fn pkgs)) pkgsBySystem;

      apodFor =
        pkgs:
        let
          pname = "apod";
          version = "1.2.0";
        in
        pkgs.python3Packages.buildPythonApplication {
          inherit pname version;
          src = ./.;

          propagatedBuildInputs = with pkgs.python3Packages; [
            beautifulsoup4
            requests
          ];

          preBuild = ''
            cat > setup.py << EOF
            from setuptools import setup
            setup(
            name='${pname}',
            version='${version}',
            install_requires=['beautifulsoup4','requests'],
            scripts=['${pname}.py'],
            )
            EOF
          '';
          postInstall = "mv -v $out/bin/${pname}.py $out/bin/${pname}";
        };
    in
    {
      packages = forAllPkgs (pkgs: {
        default = apodFor pkgs;
      });

      devShells = eachSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
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
