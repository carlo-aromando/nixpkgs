{ lib
, fetchFromGitHub
, stdenv
, makeWrapper
, curl
, which
, python3
, wheel
, lxml
, portalocker
, psutil
, pyyaml
, types-pyyaml
, sarif-tools
, multiprocess
, requests
, sphinx
, deprecated
, redis
,
}:

stdenv.mkDerivation rec {
  pname = "codechecker";
  version = "6.24.0";

  src = fetchFromGitHub {
    owner = "Ericsson";
    repo = pname;
    rev = "e2037faf2d6e5d9b17675b58cf3e8e9e6995a7dd";
    sha256 = "sha256-dEIqpN4EyRWztVaFKrZboveYXPWHi4btf867sYfk/PY=";
  };

  buildInputs = [
    curl
    which
  ];

  buildPhase = ''
    make package
  '';

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r build/CodeChecker/lib $out
    cp -r build/CodeChecker/config $out
    cp -r build/CodeChecker/bin/* $out/bin
    wrapProgram $out/bin/CodeChecker --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  patches = [ ./codechecker.patch ];

  propagatedBuildInputs = [
    lxml
    portalocker
    psutil
    pyyaml
    python3
    types-pyyaml
    sarif-tools
    multiprocess
    requests
    sphinx
    deprecated
    redis
  ];

  doCheck = false;

  meta = with lib; {
    description = "CodeChecker is an analyzer tooling, defect database and viewer extension for the Clang Static Analyzer and Clang Tidy";
    homepage = "https://github.com/Ericsson/codechecker";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
