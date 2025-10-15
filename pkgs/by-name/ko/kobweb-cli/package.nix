{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  jdk11,
  gradle,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kobweb-cli";
  version = "0.9.21";

  src = fetchFromGitHub {
    owner = "varabyte";
    repo = "kobweb-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zNXQrzito6TGKpBDjqog7oCrhcwARCnVKH2uQjcNAtk=";
  };

  gradleFlags = ["-Dfile.encoding=utf-8"];

  gradleBuildTask = "assembleShadowDist";

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    cp -r kobweb/build/scriptsShadow/* $out/bin
    cp -r kobweb/build/libs/* $out/lib
    chmod +x $out/bin/kobweb
    wrapProgram $out/bin/kobweb \
      --prefix PATH : ${jdk11}/bin
  '';

  meta = {
    homepage = "https://github.com/varabyte/kobweb-cli";
    changelog = "https://github.com/varabyte/kobweb-cli/releases/tag/v${finalAttrs.version}";
    description = "The CLI binary that drives the interactive Kobweb experience.";
    mainProgram = "kobweb";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      philippschuetz
    ];
  };
})
