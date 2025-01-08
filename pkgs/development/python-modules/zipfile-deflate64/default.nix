{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage rec {
  pname = "zipfile-deflate64";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brianhelba";
    repo = "zipfile-deflate64";
    tag = "v${version}";
    hash = "sha256-RnIYh4/cUyRuOU49G4Bn+HqSCha74vzNTmGmwlEZUQg=";
    fetchSubmodules = true;
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  pythonImportsCheck = [ "zipfile_deflate64" ];

  meta = {
    description = "Extract Deflate64 ZIP archives with Python's zipfile API";
    homepage = "https://github.com/brianhelba/zipfile-deflate64/tree/master";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
