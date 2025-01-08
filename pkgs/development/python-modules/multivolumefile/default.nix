{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
  pytestCheckHook,
  pytest-cov,
  pyannotate,
  coverage,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "multivolumefile";
  version = "0.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oGSNCq+8luWRmNXBfprK1+tTGr6lEDXQjOgGDcrXCdY=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
    pyannotate
    coverage
    hypothesis
  ];

  pythonImportsCheck = [ "multivolumefile" ];

  meta = {
    description = "multi volume file wrapper";
    homepage = "https://codeberg.org/miurahr/multivolume";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
