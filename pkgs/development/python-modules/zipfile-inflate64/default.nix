{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  setuptools,
  setuptools-scm,
  inflate64,
}:

buildPythonPackage rec {
  pname = "zipfile-inflate64";
  version = "0.2";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "miurahr";
    repo = "zipfile-inflate64";
    tag = "v${version}";
    hash = "sha256-vlVSshOWX4HWoqGdc0tvyzSxDtdAUvoLetz5VEncVMA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    inflate64
  ];

  pythonImportsCheck = [ "zipfile_inflate64" ];

  meta = {
    description = "Extract Enhanced Deflate ZIP archives with Python's zipfile API.";
    homepage = "https://codeberg.org/miurahr/zipfile-inflate64";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
