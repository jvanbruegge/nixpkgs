{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "metabigor";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "j3ssie";
    repo = "metabigor";
    tag = "v${version}";
    hash = "sha256-3bIU1eVsVhXEazcvlhTbuBLBSdjTxEuO2SXjdcUUyNs=";
  };

  vendorHash = "sha256-PGUOTEFcOL1pG+itTp9ce1qW+1V6hts8jKpA0E8orDk=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Disabled for now as there are some failures ("undefined:")
  doCheck = false;

  meta = {
    description = "Tool to perform OSINT tasks";
    homepage = "https://github.com/j3ssie/metabigor";
    changelog = "https://github.com/j3ssie/metabigor/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "metabigor";
  };
}
