{ 
  pkgs ? import <nixpkgs> {},
  bundlerApp ? pkgs.bundlerApp
}:

bundlerApp {
  pname = "jekyll";
  gemdir = ./.;
  exes = [ "jekyll" ];
}
