{ 
  pkgs ? import ( fetchTarball "https://nixos.org/channels/channel-name/nixos-21.05" ) {},
  stdenv ? pkgs.stdenv,
}:
let 
  systemdUser = (import ../utils {}).systemdUser;
  service = systemdUser.service { 
    description ="Matrix service and bridges"; 
    name="matrix"; 
    type="forking";
    execStart="${matrixManager}/bin/matrix --start-server --start telegram --start whatsapp --start irc";
    execStopPost="${matrixManager}/bin/matrix --stop-irc-db";
  };
  installService = pkgs.writeTextFile {
    name="matrix-service";
    text=service.unitFile;
    destination="/share/systemd/user/matrix.service";
  };
  timer = systemdUser.timer {description = "Matrix service"; delayOnBoot="5min"; };
  installTimer = pkgs.writeTextFile {
    name="matrix-timer";
    text=timer.unitFile;
    destination="/share/systemd/user/matrix.timer";
  };

  matrixManager = pkgs.writeScriptBin "matrix" ''
    ${builtins.readFile ./matrix}
  '';
in
pkgs.buildEnv rec{
  name="matrix-with-bridges";
  paths = with pkgs;[
    # server
    matrix-synapse 

    mautrix-telegram
    mautrix-whatsapp
    matrix-appservice-irc
    # database for matrix-appservice-irc
    postgresql
    
    # systemd units
    installService
    installTimer

    # my matrix manager script
    matrixManager
  ];

  postBuild = ''
    mkdir -p $out/lib/systemd/user
    _moveSystemdUserUnits
  '';

  pathsToLink = [ "/lib" "/bin" "/share" ];
}
