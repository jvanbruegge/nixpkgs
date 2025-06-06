{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  google-auth,
  googleapis-common-protos,
  grpcio,
  grpcio-gcp,
  grpcio-status,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "2.24.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-api-core";
    tag = "v${version}";
    hash = "sha256-7/9oU8KqwvL7DIDKDIUlGxfJZp7kGp1W6/tsEp6zcuc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    googleapis-common-protos
    google-auth
    protobuf
    proto-plus
    requests
  ];

  optional-dependencies = {
    async_rest = [ google-auth ] ++ google-auth.optional-dependencies.aiohttp;
    grpc = [
      grpcio
      grpcio-status
    ];
    grpcgcp = [ grpcio-gcp ];
    grpcio-gcp = [ grpcio-gcp ];
  };

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  disabledTests = [
    # Those grpc_helpers tests are failing
    "test_wrap_unary_errors"
    "test_wrap_stream_errors_raised"
    "test_wrap_stream_errors_read"
    "test_wrap_stream_errors_aiter"
    "test_wrap_stream_errors_write"
    "test_wrap_unary_errors"
    "test___next___w_rpc_error"
    "test_wrap_stream_errors_invocation"
    "test_wrap_stream_errors_iterator_initialization"
    "test_wrap_stream_errors_during_iteration"
    "test_exception_with_error_code"
  ];

  pythonImportsCheck = [ "google.api_core" ];

  meta = with lib; {
    description = "Core Library for Google Client Libraries";
    longDescription = ''
      This library is not meant to stand-alone. Instead it defines common
      helpers used by all Google API clients.
    '';
    homepage = "https://github.com/googleapis/python-api-core";
    changelog = "https://github.com/googleapis/python-api-core/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
