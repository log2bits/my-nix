{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "catppuccin-konsole";
  version = "unstable-2024-01-01";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "konsole";
    rev = "main";
    sha256 = "sha256-d5+ygDrNl2qBxZ5Cn4U7d836+ZHz77m6/yxTIANd9BU=";
  };

  installPhase = ''
    mkdir -p $out/share/konsole
    cp themes/*.colorscheme $out/share/konsole/
  '';

  meta = with lib; {
    description = "Soothing pastel theme for Konsole";
    homepage = "https://github.com/catppuccin/konsole";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
