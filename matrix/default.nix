{ 
  pkgs ? import <nixpkgs> {},
  stdenv ? pkgs.stdenv,
  systemd ? import ./systemd.nix {}
  #working
  #systemd ? (import ./systemd.nix {}).service{}
}:
let 
  service = systemd.service{ description ="Matrix service and bridges"; name="matrix"; type="forking";};
  timer = systemd.timer {description = "Matrix service"; delayOnBoot="5min"; };
  serviceBin = pkgs.writeScriptBin "matrix-service" ''
    set -x
    args=$0
    tabs="\t\t\t"

    edit(){
      [ -z "$EDITOR" ] && EDITOR=nvim
      $EDITOR $0
    }

    help(){
      echo "Ajuda:"
      echo "--start $tabs inicia o server e as bridges"
      echo "--stop  $tabs para o server e as bridges"
      echo "--debug $tabs inicia o modo de depuração do server e das bridges"
    }

    [ "$#" -eq 0 ] && help
    
    args="$@"
    for args in "$args"; do
      case "$arg" in
        -e)
        edit;;

        -h|--help)
          help;;

        --start)
          start;;

        --stop)
          stop;;

        --debug)
          debug;;
      esac
    done

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

    service
    postgresql
  ];
  buildInputs = with pkgs;[nodejs ];

  postBuild = ''
    mkdir -p $out/lib/systemd/user
    echo "${service.unitFile}" > $out/lib/systemd/user/matrix.service
    echo "${timer.unitFile}" > $out/lib/systemd/user/matrix.timer
    _moveSystemdUserUnits
  '';

  pathsToLink = [ "/lib" "/bin" "/share" ];
}
