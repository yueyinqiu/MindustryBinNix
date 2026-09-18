{
  lib,
  stdenv,
  makeWrapper,
  fetchurl,
  jdk17,
  libGL,
  alsa-lib,
}:

stdenv.mkDerivation {
  pname = "mindustry-bin";
  version = "160.4";

  src = fetchurl {
    url = "https://github.com/Anuken/Mindustry/releases/download/v160.4/Mindustry.jar";
    hash = "sha256-Pbne73lNZZX9gW+WEjLGTYq/4jjD8beAelqqWu8fRKk=";
  };
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm644 "$src" "$out/share/mindustry.jar"
    makeWrapper "${jdk17}/bin/java" "$out/bin/mindustry" \
      --add-flags "-jar \"$out/share/mindustry.jar\"" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          alsa-lib
        ]
      }"
  '';

  meta = with lib; {
    description = "Mindustry 160.4 (prebuilt client jar)";
    homepage = "https://mindustrygame.github.io/";
    license = licenses.gpl3Plus;
    mainProgram = "mindustry";
    platforms = platforms.linux;
  };
}
