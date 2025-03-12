{
  python3Packages,
}:
let
  pname = "apod";
  version = "1.3.0";
in
python3Packages.buildPythonApplication {
  inherit pname version;
  src = ./.;

  propagatedBuildInputs = with python3Packages; [
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
}
