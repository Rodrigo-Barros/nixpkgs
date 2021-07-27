{ 
  # default repository / in this time is unstable
  pkgs ? import <nixpkgs> {nixpkgs.config.allowunfree=true;},

  # Graphics library
  GL ? import ( fetchTarball "https://github.com/guibou/nixGL/archive/master.tar.gz" ) {},
  
  drivesync ? pkgs.callPackage ./drivesync {},
  nvim ? pkgs.callPackage ./nvim {},
  matrix ? pkgs.callPackage ./matrix {},
  profile ? (pkgs.callPackage ./profile.nix {}).profile,
  services ? pkgs.callPackage services/default.nix {},
  jekyll ? pkgs.callPackage ./jekyll {},
  intelephense ? pkgs.callPackage ./nvim/language-server/intelephense/intelephense.nix {}
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
         GL.nixGLDefault

         # editor config 
				 ueberzug
         bat ripgrep
         nodejs 
         nvim fira-code-symbols intelephense
         nodePackages.bash-language-server
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

         # games
         chiaki lutris

         # Scripts
         nixEnvBuilder
         taskremind
				 
         #desktop
         awesome

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
           --replace "Exec=kitty" "Exec=bash -c 'nixGL kitty'"

            substituteInPlace $prefix/share/applications/chiaki.desktop \
           --replace "Exec=chiaki" "Exec=bash -c \"nixGL chiaki\""
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
