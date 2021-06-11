{ 
  # default repository / in this time is unstable
  pkgs ? import <nixpkgs> {},

  # Graphics library
  GL ? import ( fetchTarball "https://github.com/guibou/nixGL/archive/master.tar.gz" ) {},
  
  drivesync ? pkgs.callPackage ./drivesync {},
  vim ? pkgs.callPackage ./vim {},
  matrix ? pkgs.callPackage ./matrix {}
}:
{
   nix.config = {
    # allow comercial programs like chrome
    allowunfree = true;
    android_sdk.accept_license= true;
  };

   packageOverrides = pkgs: rec{
     myProfile = pkgs.writeText "my-profile" ''
       # LOCALE_ARCHIVE=/home/rodrigo/.nix-profile/lib/locale/locale-archive
       export LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive"

       # aliases
       alias chiaki="${GL.nixGLDefault}/bin/nixGL ${pkgs.chiaki}/bin/chiaki"
     '';


     buildInputs = [ pkgs.desktop-file-utils pkgs.xdg-utils ];

     packages = pkgs.buildEnv {
       name = "all-packages";
       paths = with pkgs; [
         # locale para não mostrar avisos em aplicões no terminal
         # TODO : configurar a variavel para exportar antes de inicializar o ambiente grafico 
         ( runCommand "profile" {}  ''
            mkdir -p  $out/etc/profile.d
            cp ${myProfile} $out/etc/profile.d/my-profile.sh
         '')
         glibcLocales
          
         authenticator

         # printer over usb
         linuxPackages.usbip
         GL.nixGLDefault

         # dev

         # web dev
         # php74 php74Extensions.pdo mysql80 apacheHttpd

         # dev mobile
         # jdk8 

         git
         lazygit
         
         # communication
         matrix

         # discord

         # network-tools
         nmap drivesync firefox

         
         # zshell stuff
         vim
         zsh zinit zsh-powerlevel10k nix-zsh-completions
         
         chiaki
       ];

       postBuild = ''
          ${pkgs.desktop-file-utils}/bin/update-desktop-database $out/share
          ${pkgs.xdg-utils}/bin/xdg-desktop-menu forceupdate
       '';
     };

   };
}
