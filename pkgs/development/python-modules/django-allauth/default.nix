{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, setuptools

# dependencies
, django
, python3-openid
, requests
, requests-oauthlib
, pyjwt

# optional-dependencies
, python3-saml
, qrcode

# tests
, pillow
, pytestCheckHook
, pytest-django

# passthru tests
, dj-rest-auth
}:

buildPythonPackage rec {
  pname = "django-allauth";
  version = "0.55.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pennersr";
    repo = pname;
    rev = version;
    hash = "sha256-i0thQymrEDkx2Yt9kM10j4LxL7yChHkG9vsS0508EQA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    django
    python3-openid
    pyjwt
    requests
    requests-oauthlib
  ]
  ++ pyjwt.optional-dependencies.crypto;

  passthru.optional-dependencies = {
    saml = [
      python3-saml
    ];
    mfa = [
      qrcode
    ];
  };

  pythonImportsCheck = [
    "allauth"
  ];

  nativeCheckInputs = [
    pillow
    pytestCheckHook
    pytest-django
  ]
  ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  disabledTestPaths = [
    # tests are out of date
    "allauth/socialaccount/providers/cern/tests.py"
  ];

  passthru.tests = {
    inherit dj-rest-auth;
  };

  meta = with lib; {
    changelog = "https://github.com/pennersr/django-allauth/blob/${version}/ChangeLog.rst";
    description = "Integrated set of Django applications addressing authentication, registration, account management as well as 3rd party (social) account authentication";
    downloadPage = " https://github.com/pennersr/django-allauth";
    homepage = "https://www.intenct.nl/projects/django-allauth";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
