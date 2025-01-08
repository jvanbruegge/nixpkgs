{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
  pytestCheckHook,
  pytest-cov,
  hypothesis,
  coverage
}:

buildPythonPackage rec {
  pname = "pybcj";
  version = "1.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uIc2N/C+AM6qNy0PuBaTYEtLvI3s2ysa5fm4TRlniNk=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
    hypothesis
    coverage
  ];

  pythonImportsCheck = [ "bcj" ];

  meta = {
    description = "BCJ(Branch-Call-Jump) filter for python";
    homepage = "https://codeberg.org/miurahr/pybcj";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
