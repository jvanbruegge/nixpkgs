{
  lib,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyzstd";
  version = "0.16.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Rogdham";
    repo = "pyzstd";
    tag = version;
    hash = "sha256-Az+0m1XUFxExBZK8bcjK54Zt2d5ZlAKRMZRdr7rPcss=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'setuptools>=64,<74' 'setuptools'
    substituteInPlace setup.py \
      --replace-fail "has_option('--dynamic-link-zstd')" 'True'
  '';

  nativeBuildInputs = [ pytestCheckHook ];
  buildInputs = [ pkgs.zstd ];

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pyzstd" ];

  meta = {
    description = "7zip in python3 with ZStandard, PPMd, LZMA2, LZMA1, Delta, BCJ, BZip2, and Deflate compressions, and AES encryption.";
    homepage = "https://github.com/miurahr/py7zr";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
