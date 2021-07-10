{ 
  pkgs ? import <nixpkgs> {},
}:
let
   flatpakService = pkgs.writeTextFile{
      destination="/share/systemd/user/flatpak-updater.service";
      name="flatpak-updater";
      text = ''
        [Unit]
        Description=Flatpak Updater Service

        [Service]
        ExecStart=/usr/bin/flatpak --user update -y
        StandardError=syslog
        StandardOutput=syslog
        SyslogIdentifier=flatpak-updater
        Type=oneshot

        [Install]
        WantedBy=default.target
      '';
    };

    flatpakTimer = pkgs.writeTextFile {
      destination = "/share/systemd/user/flatpak-updater.timer";
      name = "flatpak-update-timer";
      text=''
        [Unit]
        Description=Flatpak updater timer

        [Timer]
        OnCalendar=*-*-1/5 10..16:00:00

        [Install]
        WantedBy=timers.target
      '';
    };

    nixUpdateService = pkgs.writeTextFile{
     destination="/share/systemd/user/nix-updater.service;";
     name="nix-updater";
     text = ''
       [Unit]
       Description=Nix pkgs Updater Service

       [Service]
       ExecStart=${pkgs.nix}/bin/nix-channel --update nixpkgs && ${pkgs.nix}/bin/nix-env -iA nixpkgs.packages
       StandardError=syslog
       StandardOutput=syslog
       SyslogIdentifier=nix-update
       Type=oneshot

       [Install]
       WantedBy=default.target
     '';
   };

   nixUpdateTimer = pkgs.writeTextFile{
     destination="/share/systemd/user/nix-updater.timer";
     name="nix-updater-timer";
     text=''
       [Unit]
       Description=Nix Updater Timer

       [Timer]
       OnCalendar=*-*-1/5 10..16:00:00

       [Install]
       WantedBy=timers.target
     '';
   };
	 
    nixGarbageCollector = pkgs.writeTextFile{
     destination="/share/systemd/user/nix-garbage-collector.service;";
     name="nix-garbage-collector";
     text = ''
       [Unit]
       Description=Nix Garbage Collector Service

       [Service]
       ExecStart=${pkgs.nix}/bin/nix-collect-garbage
       StandardError=syslog
       StandardOutput=syslog
       SyslogIdentifier=nix-garbage-collector
       Type=oneshot

       [Install]
       WantedBy=default.target
     '';
   };

   nixGarbageCollectorTimer = pkgs.writeTextFile{
     destination="/share/systemd/user/nix-garbage-collector.timer";
     name="nix-garbage-collector-timer";
     text=''
       [Unit]
       Description=Nix Gabage Collecto Timer

       [Timer]
       OnCalendar=*-*-1/3 17..22:00:00

       [Install]
       WantedBy=timers.target
     '';
   };
in
pkgs.buildEnv rec{
  name="services";
  paths = [
    flatpakService
    flatpakTimer
    nixUpdateService
    nixUpdateTimer
    nixGarbageCollector
    nixGarbageCollectorTimer
  ];
}
