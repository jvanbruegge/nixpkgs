{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  sqlalchemy,
  python-dateutil,
  packaging,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "sqlakeyset";
  version = "2.0.1762907931";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gLGrHYgTt8kf17Rd5ESJeL4s7bPHX/8/0ZKw+c+RUI0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    sqlalchemy
    python-dateutil
    packaging
    typing-extensions
  ];

  pythonImportsCheck = [ "sqlakeyset" ];

  meta = {
    description = "Offset-free paging for sqlalchemy ";
    homepage = "https://github.com/djrobstep/sqlakeyset/tree/master";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
