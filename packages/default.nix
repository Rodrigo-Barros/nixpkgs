{
	pkgs ? import <nixpkgs> {}
}:
{
	jekyll = pkgs.callPackage ./jekyll {};
	intelephense = pkgs.callPackage ./intelephense/intelephense.nix {};
	matrix = pkgs.callPackage ./matrix {};
	awesome = pkgs.callPackage ./awesome {};
	drivesync = pkgs.callPackage ./drivesync {};

	nvim = pkgs.callPackage ./nvim {};
    vscode-php-debug = pkgs.callPackage ./nvim/dap/vscode-php-debug {};
	remind = pkgs.callPackage ./remind {};
    ical2rem = pkgs.callPackage ./ical2rem {};
	php = pkgs.php.buildEnv {
		extensions = {all, enabled}: with all; [xdebug];
		extraConfig = ''
			xdebug.mode = debug
			xdebug.start_with_request = yes
			xdebug.log = /tmp/xdebug.log
		'';
	};
}
