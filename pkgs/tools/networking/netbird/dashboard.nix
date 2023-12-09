{ lib, fetchFromGitHub, buildNpmPackage }:

buildNpmPackage rec {
  pname = "netbird-dashboard";
  version = "1.17.7";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "dashboard";
    rev = "v${version}";
    hash = "sha256-YWxdmPCtWMTrObYGY7GhTh3lylj9XO+tPmWDS1iteKg=";
  };
  npmDepsHash = "sha256-x7YyzBPAiXyxaIcAvUrXBexYaw0TaYnKgQKT3KadW8w=";

  npmFlags = [ "--legacy-peer-deps" ];
  NODE_OPTIONS = "--openssl-legacy-provider";

  installPhase = "cp -r build $out";
}
