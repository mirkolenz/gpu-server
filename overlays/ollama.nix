{
  fetchzip,
  lib,
  stdenvNoCC,
  acceleration ? null,
}:
stdenvNoCC.mkDerivation rec {
  pname = "ollama";
  version = "0.5.1";

  src = fetchzip {
    url = "https://github.com/ollama/ollama/releases/download/v${version}/ollama-linux-amd64.tgz";
    hash = "sha256-JdA4HGtJTQ7ymGBCNOGBx6ajxuJdR78Rhw5rjOcq6e4=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 -D bin/ollama $out/bin/ollama

    runHook postInstall
  '';

  passthru = {
    inherit acceleration;
  };

  meta = {
    homepage = "https://ollama.com";
    downloadPage = "https://github.com/ollama/ollama/releases";
    description = "Get up and running with Llama, Mistral, Gemma, and other large language models";
    mainProgram = "ollama";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirkolenz ];
  };
}
