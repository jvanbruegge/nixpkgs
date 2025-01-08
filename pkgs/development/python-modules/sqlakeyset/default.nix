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
  version = "2.0.1733540710";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HcQ9+Bysa5kqzeVgXXGC1/H2v52Xu/1+zAJyRZVXlAo=";
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
