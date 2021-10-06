{
  pkgs ? import <nixpkgs> {},
  stdenv ? pkgs.stdenv
}:
let
  nodeDependencies = (pkgs.callPackage ./default.nix {}).shell.nodeDependencies;
in

stdenv.mkDerivation {
  name = "intelephense";
  src = ./.;
  buildInputs = with pkgs;[nodejs];
  buildPhase = ''
    mkdir -p $out/bin
    ln -s ${nodeDependencies}/bin/intelephense $out/bin/intelephense
  '';
  phases = [ "buildPhase" ];
}
