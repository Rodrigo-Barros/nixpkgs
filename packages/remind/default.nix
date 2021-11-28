{
	pkgs ? import <nixpkgs> {},
}:
pkgs.stdenv.mkDerivation {
	name="remind";
	src = pkgs.fetchurl{
		url="https://dianne.skoll.ca/projects/remind/download/remind-03.03.09.tar.gz";
		sha256="sha256-yQh6jGkRNkQvPoguRmd6025pCEsvO7w8W3YNO2vztvM=";
	};
	configurePhase = ''
		ls -l 
		./configure --prefix=$out
		make "LANGDEF=-DLANG=BRAZPORT"
	'';
	installPhase = ''
		make install
	'';
}
