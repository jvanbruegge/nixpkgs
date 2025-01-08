{
  lib,
  buildPythonPackage,
  fetchzip,
  setuptools,
}:

buildPythonPackage {
  pname = "types-passlib";
  version = "1.7.7.20250602";
  pyproject = true;

  # fetchpypi does not work
  src = fetchzip {
    url = "https://files.pythonhosted.org/packages/fa/3e/501a5832130e5f93450b1e02090e2ee27a37135d11378a47debf960e3131/types_passlib-1.7.7.20250602.tar.gz";
    hash = "sha256-/z3AwlaJ0CpZRDcHZW/Vj/iNfrBS5K1GFNIjASsFGr4=";
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
