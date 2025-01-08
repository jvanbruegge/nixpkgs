{
  lib,
  buildPythonPackage,
  fetchzip,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-passlib";
  version = "1.7.7.20241221";
  pyproject = true;

  # fetchpypi does not work
  src = fetchzip {
    url = "https://files.pythonhosted.org/packages/d9/65/2af3d80436091cf59f06864ca2780499ab14a85ee06a6255bc653ad76913/types_passlib-1.7.7.20241221.tar.gz";
    hash = "sha256-avAhOah+VAcUjeCI035pkMdCGR23fsp+RY52vcJs5Yc=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Typing stubs for passlib";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
