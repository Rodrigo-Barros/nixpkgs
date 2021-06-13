{ 
  # default repository / in this time is unstable
  pkgs ? import <nixpkgs> {nixpkgs.config.allowunfree=true;},

  # Graphics library
  GL ? import ( fetchTarball "https://github.com/guibou/nixGL/archive/master.tar.gz" ) {},
  
  drivesync ? pkgs.callPackage ./drivesync {},
  nvim ? pkgs.callPackage ./nvim {},
  matrix ? pkgs.callPackage ./matrix {},
  profile ? (pkgs.callPackage ./profile.nix {}).profile
}:
{
   # allow comercial programs like chrome
   allowUnfree = true;

   packageOverrides = pkgs: rec{

     buildInputs = [ pkgs.desktop-file-utils pkgs.xdg-utils ];

     packages = pkgs.buildEnv {
       name = "all-packages";
       paths = with pkgs; [

         profile

         glibcLocales

         authenticator

         # printer over usb
         # linuxPackages.usbip
         GL.nixGLDefault

         # dev
         nvim fira-code

         # vcs
         git lazygit

         # web dev
         # php74 php74Extensions.pdo mysql80 apacheHttpd

         # dev mobile
         
         # communication
         matrix

         # network-tools
         nmap drivesync firefox
         
         # zshell stuff
				 
         # terminal
         kitty zsh zinit

         # games
         chiaki lutris
       ];

     };

   };
}
