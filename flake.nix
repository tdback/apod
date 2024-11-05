{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        bin = "apod";
        version = "1.1.0";
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            (python3.withPackages (p:
              with p; [
                beautifulsoup4
                ipython
                python-lsp-server
                requests
              ]
            ))
            ruff
          ];
        };

        defaultPackage = pkgs.python3Packages.buildPythonApplication {
          pname = bin;
          version = version;
          src = ./.;

          propagatedBuildInputs = with pkgs.python3Packages; [
            beautifulsoup4
            requests
          ];

          preBuild = ''
            cat > setup.py << EOF
            from setuptools import setup

            setup(
                name='${bin}',
                version='${version}',
                install_requires=[
                    'beautifulsoup4',
                    'requests',
                ],
                scripts=['${bin}.py'],
            )
            EOF
          '';

          postInstall = ''
            mv -v $out/bin/${bin}.py $out/bin/${bin}
          '';
        };
      });
}
