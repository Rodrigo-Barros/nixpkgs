{ 
  pkgs ? import <nixpkgs> {}, 
  stdenv ? pkgs.stdenv,
  bundlerEnv ? pkgs.bundlerEnv,
}:
stdenv.mkDerivation rec {
  name = "ical2rem";
  homepage = "https://github.com/MStadlmeier/drivesync";
  buildInputs = with pkgs; [ ruby ri_call ];
  platforms = [ "x86_64-linux" ];

  ri_call = bundlerEnv {
    name="ri_call";
    ruby = pkgs.ruby;
    gemdir = ./.;
  };

  src = pkgs.fetchFromGitHub{
    owner = "courts";
    repo = "ical2rem.rb";
    rev = "a6e75f504d6bdd53b52b36c8ce759dd8d62c9722";
    sha256 = "sha256-TVy/+noxDt4D0v4ZMATSX/xVvHCFbuREN1Gk7+C8A3c=";
  };

    configurePhase = ''
        gem build ical2rem.rb.gemspec
    '';
    installPhase = ''
        gem install ical2rem.rb*.gem
        mkdir -p $out/{bin,lib}
        mv bin/* $out/bin
        mv lib/* $out/lib
        ls -l ${ri_call}/lib
        mv .ical2rem.yaml $out
    '';
}
