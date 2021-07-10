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
}:
{
   # allow comercial programs like chrome
   allowUnfree = true;

   packageOverrides = pkgs: rec{

     nixEnvBuilder = pkgs.writeScriptBin "nix-build-env" ''
       ${builtins.readFile ./utils/nix-env-builder }
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
         nvim
         nodejs fira-code-symbols

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
				 
         #desktop
         awesome

				 #others
				 zathura
				 jekyll

       ];

       postBuild = ''
         substituteInPlace $prefix/share/applications/kitty.desktop \
          --replace "Exec=kitty" "Exec=nixGL /nix/store/3b91fwq7h8c69vq6vdy3dzh5iqhmfy8g-all-packages/bin/kitty"
       '';

     };

		 work = pkgs.buildEnv {
			name = "work-env";
			paths = with pkgs; [			
				squid
				ueberzug
				nvim
				nginx
			];

		 };

   };
}
