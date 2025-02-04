{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  python3,
}:
buildPythonApplication {
  pname = "gpt-cli";
  version = "0.3.2";
  format = "pyproject";

  preBuild = ''
    substituteInPlace pyproject.toml \
      --replace 'anthropic~=0.44.0' 'anthropic' \
      --replace 'attrs~=24.2.0' 'attrs' \
      --replace 'black~=24.10.0' 'black' \
      --replace 'cohere~=5.13.11' 'cohere' \
      --replace 'google-generativeai~=0.8.4' 'google-generativeai' \
      --replace 'openai~=1.60.0' 'openai' \
      --replace 'prompt-toolkit~=3.0.48' 'prompt-toolkit' \
      --replace 'pytest~=8.3.3' 'pytest' \
      --replace 'PyYAML~=6.0.2' 'PyYAML' \
      --replace 'rich~=13.9.4' 'rich' \
      --replace 'typing_extensions~=4.12.2' 'typing_extensions' \
      --replace 'llama-cpp-python==0.2.74' 'llama-cpp-python' \
      --replace 'pydantic<2' 'pydantic'
  '';

  nativeBuildInputs = with python3.pkgs; [
    pip
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    anthropic
    attrs
    black
    cohere
    google-generativeai
    openai
    prompt-toolkit
    pytest
    pyyaml
    rich
    typing-extensions
    pydantic
  ];

  src = fetchFromGitHub {
    owner = "kharvd";
    repo = "gpt-cli";
    rev = "08b535cb459f2f2269d8889de297f7f995d800f4";
    sha256 = "sha256-Zmqhdh+XMvJ3bhW+qkQOJT3nf+8luv7aJGW6xJSPuns=";
  };

  meta = with lib; {
    description = "Command-line interface for ChatGPT, Claude and Bard";
    homepage = "https://github.com/kharvd/gpt-cli";
    license = licenses.mit;
    maintainers = with maintainers; [_404wolf];
  };
}
