
{
  pkgs ? import <nixpkgs> {},
  stdenv ? pkgs.stdenv
}:
let
  nodeDependencies = (pkgs.callPackage ./default.nix {}).shell.nodeDependencies;
in

stdenv.mkDerivation {
  name = "intelephense";
  src = /home/rodrigo/.config/nixpkgs/nvim/language-server/intelephense;
  buildInputs = with pkgs;[nodejs];
  buildPhase = ''
    mkdir -p $out/bin
    ln -s ${nodeDependencies}/bin/intelephense $out/bin/intelephense
  '';
  phases = [ "buildPhase" ];
}
