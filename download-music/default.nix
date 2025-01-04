{ pkgs ? import <nixpkgs> {} }:
with pkgs;
stdenv.mkDerivation {
  name = "download-music";
  buildInputs = [
    (python3.withPackages (ps: with ps; [
      yt-dlp
    ]))
    ffmpeg
  ];
  dontUnpack = true;
  installPhase = ''
    install -Dm755 ${./main.py} $out/bin/download-music
    substituteInPlace $out/bin/download-music --replace-fail "%FFMPEG%" "${ffmpeg}/bin/ffmpeg"
  '';
}
