{ 
  # default repository / in this time is unstable
  pkgs ? import <nixpkgs> {nixpkgs.config.allowunfree=true;},

  # Graphics library
  GL ? import ( fetchTarball "https://github.com/guibou/nixGL/archive/main.tar.gz" ) {},

  profile ? (pkgs.callPackage ./profile.nix {}).profile,
  services ? pkgs.callPackage services/default.nix {},
  repo ? pkgs.callPackage ./packages {},
  scripts ? pkgs.callPackage ./scripts {}
}:
{
   # allow comercial programs like chrome
   allowUnfree = true;

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
	 ];

     home = pkgs.buildEnv {
       name = "home-env";
       paths = with pkgs; [
         # flatpak-updater from system
         # nix-update channel and packages
         # nix-garbage-collector 
         services
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

		 # Scripts
       ] ++ packages ++ tools;

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
