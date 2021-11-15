{ 
  # default repository / in this time is unstable
  pkgs ? import <nixpkgs> {nixpkgs.config.allowunfree=true;},

  # Graphics library
  GL ? import ( fetchTarball "https://github.com/guibou/nixGL/archive/main.tar.gz" ) {},

  profile ? (pkgs.callPackage ./profile.nix {}).profile,
  systemd ? pkgs.callPackage ./packages/utils/default.nix {},
  repo ? pkgs.callPackage ./packages {},
  scripts ? pkgs.callPackage ./scripts {}
}:
{
   # allow comercial programs like chrome
   allowUnfree = true;
   android_sdk.accept_license = true;
   packageOverrides = pkgs: rec{

     #  nixEnvBuilder = pkgs.writeScriptBin "nix-build-env" ''
     #    ${builtins.readFile ./utils/nix-env-builder }
     #  '';
    
     # my custom packages	
     packages = with repo;[
        php
		awesome
	    nvim
	    drivesync
	    awesome
	    matrix
	    jekyll
	    intelephense
		# remind
     ];

	 tools = with scripts; [
		 post
		 taskremind
		 remind
		 bindPrinter
		 rofi-launcher
		 nix-build-env
	 ];


	services = [
		# matrix
		(systemd.service {
			name="matrix";
			execStartPre="${repo.matrix}/bin/matrix --start-irc-db";
			execStart="${repo.matrix}/bin/matrix --start-server --start telegram";
			execStopPost="${repo.matrix}/bin/matrix --stop-irc-db";
			type="forking";
		})
		(systemd.timer {
			name="matrix";
			delayOnBoot="5min";
		})

		# Nix Garbage Collector
		(systemd.service{
			name="nix-collect-garbage";
			execStart="${pkgs.nix}/bin/nix-collect-garbage";
		})
		(systemd.timer{
			name="nix-collect-garbage";
			onCalendar="*-*-1/3 17..22:00:00";
		})

		# Nix updater repo
		(systemd.service{
			name="nix-updater";
			execStart="${pkgs.nix}/bin/nix-channel --update nixpkgs && ${scripts.nix-build-env}/bin/build-env --build";
		})
		(systemd.timer{
			name="nix-updater";
			onCalendar="*-*-1/3 17..22:00:00";
		})

	];

     home = pkgs.buildEnv {
       name = "home-env";
       paths = with pkgs; [
         # flatpak-updater from system
         # nix-update channel and packages
         # nix-garbage-collector 
         profile
		 compton

         glibcLocales

         #authenticator

         # printer over usb
         # linuxPackages.usbip
         GL.auto.nixGLDefault

         # editor config 
		 ueberzug
         bat ripgrep
         nodejs 
	     nerdfonts 
	     line-awesome
         #LSP nodeps for nvim
         nodePackages.bash-language-server
         sumneko-lua-language-server
	     rnix-lsp
	 
         # vcs
         git lazygit

         # web dev
         # php74 php74Extensions.pdo mysql80 apacheHttpd

         # dev mobile
         
         # communication

         # network-tools
         nmap firefox
         
         # terminal
	     fzf kitty
	     zsh zinit
         tmux
	     zsh-z

         # games
         chiaki lutris

         # Scripts
         # nixEnvBuilder
         # taskremind
				 
         #desktop
         dmenu
	     rofi
	     #others
	     zathura
		 nix-index
         # post
          
         # time control
         taskwarrior
         timewarrior

		# Custom env
       ] ++ packages ++ tools ++ services;

        postBuild = ''
          substituteInPlace $prefix/share/applications/kitty.desktop \
           --replace 'Exec=kitty' 'Exec=sh -c "nixGL kitty"'

            substituteInPlace $prefix/share/applications/chiaki.desktop \
           --replace 'Exec=chiaki' 'Exec=bash -c "nixGL chiaki"'
		
        '';

     };

	work = pkgs.buildEnv {
			name = "work-env";
			paths = with pkgs; [			
				squid
				ueberzug
				nginx
				asterisk
			];

		 };

   };
}
