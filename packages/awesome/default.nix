{
	pkgs ? import <nixpkgs> {},
	stdenv ? pkgs.stdenv,
	config_file ? "${builtins.getEnv "HOME"}/.config/nixpkgs/packages/awesome/rc.lua",
	lgi ? pkgs.luaPackages.lgi,
	lua ? pkgs.luaPackages.lua,
	which ? pkgs.which
}:
pkgs.awesome.overrideAttrs(oldAttrs: {
	postInstall = ''
	# Don't use wrapProgram or the wrapper will duplicate the --search
    # arguments every restart
    mv "$out/bin/awesome" "$out/bin/.awesome-wrapped"
    makeWrapper "$out/bin/.awesome-wrapped" "$out/bin/awesome" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --add-flags '--search ${lgi}/lib/lua/${lua.luaversion}' \
      --add-flags '--search ${lgi}/share/lua/${lua.luaversion}' \
	  --add-flags '-c ${config_file}' \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"

    wrapProgram $out/bin/awesome-client \
      --prefix PATH : "${which}/bin"
	'';
})
