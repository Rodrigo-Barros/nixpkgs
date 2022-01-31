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
    fonts = pkgs.nerdfonts.override {
        fonts=[ "FiraCode" ];
    };
    
    
    # my custom packages   
    packages = with repo;[
       php
       awesome
       nvim
       drivesync
       awesome
       matrix
       jekyll
       remind
       ical2rem
       vscode-php-debug
    ];
    
    tools = with scripts; [
        post
        taskremind
        remind-notifier
        bindPrinter
        rofi-launcher
        nix-build-env
        vscode-php-debug
        encrypt-tool
        dart-lsp
    ];
    
    services = {
        # Matrix
        matrix = systemd.service {
            name="matrix";
            execStartPre="${repo.matrix}/bin/matrix --start-irc-db";
            execStart="${repo.matrix}/bin/matrix --start-server --start telegram";
            execStopPost="${repo.matrix}/bin/matrix --stop-irc-db";
            type="forking";
        };
        
        # Nix Garbage Collector
        nix-collect-garbage = systemd.service{
            name="nix-collect-garbage";
            execStart="${pkgs.nix}/bin/nix-collect-garbage";
        };
        
        # Nix updater repo
        nix-updater = systemd.service{
            name="nix-updater";
            execStart="${pkgs.nix}/bin/nix-channel --update nixpkgs";
            execStopPost="${scripts.nix-build-env}/bin/build-env --build";
            timeoutSec="600";
        };
        
        # Remind-Notifier
        remind-notifier = systemd.service{
            name="remind-notifier";
            execStart="${scripts.remind-notifier}/bin/remind-notifier";
        };
      
    };
    
    timers = {
    
        # Matrix
        matrix = systemd.timer {
            name="matrix";
            delayOnBoot="5min";
        };
        
        # Nix Garbage Collector
        nix-collect-garbage = systemd.timer{
            name="nix-collect-garbage";
            onCalendar="*-*-1/3 12:00:00";
            persistent="true";
        };
    
        # Nix updater 
        nix-updater = systemd.timer{
            name="nix-updater";
            onCalendar="*-*-1/3 12:00:00";
            persistent="true";
        };
      
    };
    
    units = [
      # Matrix
      services.matrix
      timers.matrix
     
      # Nix Garbage Collector
      services.nix-collect-garbage
      timers.nix-collect-garbage
      
      # Nix updater
      services.nix-updater
      timers.nix-updater
      
      # Remind Notifier
      services.remind-notifier
    ];
    
    home = pkgs.buildEnv {
      name = "home-env";
      paths = with pkgs; [
        # flatpak-updater from system
        # nix-update channel and packages
        # nix-garbage-collector 
        jq
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
        fonts
        fontconfig
        font-awesome_4
        line-awesome
        
        #LSP nodeps for nvim
        nodePackages.bash-language-server
        nodePackages.intelephense
        sumneko-lua-language-server
        rnix-lsp
        
        # vcs
        git lazygit
        
        # web dev
        # php74 php74Extensions.pdo mysql80 apacheHttpd
        
        # dev mobile
        flutter
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
        
        #desktop
        flameshot
        dmenu
        rofi
        conky

        element-desktop

        #others
        zathura
        nix-index
        # post
         
        # time control
        taskwarrior
        timewarrior
        
        xcape

        entr
       # Custom env
      ] ++ packages ++ tools ++ units;
      
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
