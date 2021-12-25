{
	pkgs ? import <nixpkgs> {},
	stdenv ? pkgs.stdenv,
	config_file ? "${builtins.getEnv "HOME"}/.config/nixpkgs/packages/awesome/rc.lua",
	lgi ? pkgs.luaPackages.lgi,
	lua ? pkgs.lua,
    lpkgs ? pkgs.luaPackages,
	which ? pkgs.which
}:
let 
    luaEnv = lua.withPackages(ps: [ ps.lgi ps.ldoc ]);
    awesome-wm-widgets = lpkgs.toLuaModule ( pkgs.stdenv.mkDerivation rec{
        name = "awesome-wm-widgets";
        src = pkgs.fetchFromGitHub {
            owner = "streetturtle";
            repo = "awesome-wm-widgets";
            rev = "01a4f428e0361f4222e8d2f14607fb03bbd6d94e";
            sha256 = "Hkyy7POMHEngwzWeLWM7i9NPLLk16anv9HOYos/jrUE=";
        };

        installPhase = ''
            echo $out
            mkdir -p $out/lib/lua/${lua.luaversion}/
            cp -r . $out/lib/lua/${lua.luaversion}/${name}
            printf "package.path = '$out/lib/lua/${lua.luaversion}/?/init.lua;' ..  package.path\nreturn require((...) .. '.init')\n"
        '';

    });

    awesome-buttons = lpkgs.toLuaModule ( pkgs.stdenv.mkDerivation rec{
        name = "awesome-buttons";
        src = pkgs.fetchFromGitHub {
            owner = "streetturtle";
            repo = "awesome-buttons";
            rev = "10c7fbf0e4d75a903a0313f7365fc1a19395a974";
            sha256 = "43+rjgal7P2TKLLHHliuP6xPMTZYaxF4KIa1RLi9Ovs=";
        };

        installPhase = ''
            mkdir -p $out/lib/lua/${lua.luaversion}/
            cp -r . $out/lib/lua/${lua.luaversion}/${name}
            #printf "package.path = '$out/lib/lua/${lua.luaversion}/?/init.lua;' ..  package.path\nreturn require((...) .. '.init')\n"
        '';

    });

    json-lua = lpkgs.toLuaModule ( pkgs.stdenv.mkDerivation rec{
        name = "json-lua";
        src = pkgs.fetchFromGitHub {
            owner = "rxi";
            repo = "json.lua";
            rev = "dbf4b2dd2eb7c23be2773c89eb059dadd6436f94";
            sha256 = "BrM+r0VVdaeFgLfzmt1wkj0sC3dj9nNojkuZJK5f35s=";
        };

        installPhase = ''
            mkdir -p $out/lib/lua/${lua.luaversion}/
            cp -r . $out/lib/lua/${lua.luaversion}/${name}
            #printf "package.path = '$out/lib/lua/${lua.luaversion}/?/init.lua;' ..  package.path\nreturn require((...) .. '.init')\n"
        '';

    });

in
pkgs.awesome.overrideAttrs(oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ awesome-wm-widgets awesome-buttons json-lua ];
	postInstall = ''
	# Don't use wrapProgram or the wrapper will duplicate the --search
    ln -s ${awesome-wm-widgets}/lib/lua/${lua.luaversion}/awesome-wm-widgets $out/share/awesome/lib/awesome-wm-widgets
    ln -s ${awesome-buttons}/lib/lua/${lua.luaversion}/awesome-buttons $out/share/awesome/lib/awesome-buttons
    ln -s ${json-lua}/lib/lua/${lua.luaversion}/json-lua/json.lua $out/share/awesome/lib/json.lua

    # arguments every restart
    mv "$out/bin/awesome" "$out/bin/.awesome-wrapped"
    makeWrapper "$out/bin/.awesome-wrapped" "$out/bin/awesome" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --add-flags '--search ${lgi}/lib/lua/${lua.luaversion}' \
      --add-flags '--search ${lgi}/share/lua/${lua.luaversion}' \
	  --add-flags '-c ${config_file}' \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
	  --prefix FONTCONFIG_FILE : "${pkgs.fontconfig.out}/etc/fonts/fonts.conf"

    wrapProgram $out/bin/awesome-client \
      --prefix PATH : "${which}/bin"

	'';
})
