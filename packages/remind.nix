{
	pkgs ? import <nixpkgs> {},
	stdenv ? pkgs.stdenv,
	fetchgit ? pkgs.fetchgit
}:
stdenv.mkDerivation rec{
	pname="remind-${version}";
	name="remind";
	version="03.03.08";
	src = fetchgit{
		url = "https://git.skoll.ca/Skollsoft-Public/Remind/";
		rev = "143f1d61446c33717578a669c20d1aa172269ee9";
		sha256 = "1392sxhm8qb408cf08nq8bvmqixcr2my9w2w4ak21mf3nsxfjwdk";
	};
	installPhase = ''
		./configure --prefix $out
		make "LANGDEF=-DLANG=BRAZPORT"
		make install
	'';
}
