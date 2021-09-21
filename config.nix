{ 
  # default repository / in this time is unstable
  pkgs ? import <nixpkgs> {nixpkgs.config.allowunfree=true;},

  # Graphics library
  GL ? import ( fetchTarball "https://github.com/guibou/nixGL/archive/main.tar.gz" ) {},

  drivesync ? pkgs.callPackage ./drivesync {},
  nvim ? pkgs.callPackage ./nvim {},
  matrix ? pkgs.callPackage ./matrix {},
  profile ? (pkgs.callPackage ./profile.nix {}).profile,
  services ? pkgs.callPackage services/default.nix {},
  jekyll ? pkgs.callPackage ./jekyll {},
  intelephense ? pkgs.callPackage ./nvim/language-server/intelephense/intelephense.nix {},
  awesomewm ? pkgs.callPackage ./awesome {}
}:
{
   # allow comercial programs like chrome
   allowUnfree = true;

   packageOverrides = pkgs: rec{

     nixEnvBuilder = pkgs.writeScriptBin "nix-build-env" ''
       ${builtins.readFile ./utils/nix-env-builder }
     '';
    
     # Jekyll helper script
     post = pkgs.writeScriptBin "post" ''
      ${builtins.readFile ./jekyll/jekyll }
     '';

     taskremind = pkgs.writeScriptBin "taskremind" ''
      ${builtins.readFile ./scripts/taskremind}
     '';

     home = pkgs.buildEnv {
       name = "home-env";
       paths = with pkgs; [
         # flatpak-updater from system
         # nix-update channel and packages
         # nix-garbage-collector 
         services
         profile

         glibcLocales

         #authenticator

         # printer over usb
         # linuxPackages.usbip
         GL.auto.nixGLDefault

         # editor config 
		 ueberzug
         bat ripgrep
         nodejs 
		 nvim
	     nerdfonts intelephense
		 line-awesome

         #LSP nodeps for nvim
         nodePackages.bash-language-server
		 nodePackages.javascript-typescript-langserver
         sumneko-lua-language-server
		 rnix-lsp
         # vcs
         git lazygit

         # web dev
         # php74 php74Extensions.pdo mysql80 apacheHttpd

         # dev mobile
         
         # communication
         matrix

         # network-tools
         nmap drivesync firefox
         
         # terminal
		 fzf kitty
		 zsh zinit
         tmux
		 zsh-z

         # games
         chiaki lutris

         # Scripts
         nixEnvBuilder
         taskremind
				 
         #desktop
         awesomewm
         dmenu
		 rofi
		 #others
		 zathura
         post
         jekyll
          
         # time control
         taskwarrior
         timewarrior

       ];

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
