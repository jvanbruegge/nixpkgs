{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "inflate64";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OxyDwiZRtZQrNYKd9SbolgLklBkr8CHg19C2AOdsQp0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "inflate64" ];

  meta = {
    description = "Python package to provide compression and decompression feature with Enhanced Deflate algorithm";
    homepage = "https://codeberg.org/miurahr/inflate64";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
