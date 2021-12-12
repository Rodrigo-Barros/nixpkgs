{
 pkgs ? import <nixpkgs> {},
 python2 ? pkgs.python2,
 runCommand ? pkgs.runCommand,
 writeTextFile ? pkgs.writeTextFile,
 writeScriptBin ? pkgs.writeShellScript,
 writeShellScript ? pkgs.writeShellScript,
 nodejs ? pkgs.nodejs,
 fetchgit ? pkgs.fetchgit,
 fetchurl ? pkgs.fetchurl,
 lib ? pkgs.lib,
 stdenv ? pkgs.stdenv
}:
let 
    nodeEnv = import ./node-env.nix {
      inherit (pkgs) stdenv lib python2 runCommand writeTextFile writeShellScript;
      inherit pkgs nodejs;
      libtool = if pkgs.stdenv.isDarwin then pkgs.darwin.cctools else null;
    };

    nodePackages = import ./node-packages.nix {
      inherit (pkgs) fetchurl nix-gitignore stdenv lib fetchgit;
      inherit nodeEnv;
      globalBuildInputs = with pkgs; [ pkgconfig libsecret ];
    };

    deps = nodePackages.nodeDependencies;
in
stdenv.mkDerivation rec{
    name="vscode-php-debug";
    version="1.22.0";
    src=fetchurl{
      url="https://github.com/xdebug/vscode-php-debug/archive/refs/tags/v${version}.tar.gz";
      sha256="tCucw+WAvbSmHfZhQ3dUplJ6AbjHruB4qkt8GGuDjdQ=";
    };

    buildInputs = with pkgs;[ nodejs makeWrapper ];

    buildPhase = ''
        mkdir -p $out/lib
        # we use this link just for build
        ln -s ${deps}/lib/node_modules ./node_modules
        ln -s ${deps}/lib/node_modules $out/node_modules
        npm run build 
    '';

    installPhase = ''
        cp -r ./out/* $out/lib
    '';
}
