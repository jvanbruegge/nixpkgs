{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pytest-benchmark,
  pytest-cov,
  pytest-timeout,
  hypothesis,
  coverage
}:

buildPythonPackage rec {
  pname = "pyppmd";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8agS8edij0wm0F3jQLkbchZde2J3jCfTIrgs4uj/AMs=";
  };

  build-system = [ setuptools setuptools-scm ];

  nativeBuildInputs = [ pytestCheckHook ];
  nativeCheckInputs = [
    pytest-benchmark
    pytest-cov
    pytest-timeout
    hypothesis
    coverage
  ];

  pythonImportsCheck = [ "pyppmd" ];

  meta = {
    description = "classes and functions for compressing and decompressing text data, using PPM (Prediction by partial matching) compression algorithm variation H and I.2";
    homepage = "https://codeberg.org/miurahr/pyppmd/src/branch/main";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
