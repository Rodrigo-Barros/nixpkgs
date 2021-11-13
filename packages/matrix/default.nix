{ 
  pkgs ? import ( fetchTarball "https://nixos.org/channels/channel-name/nixos-21.05" ) {},
  stdenv ? pkgs.stdenv,
}:
let 
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
    
    # my matrix manager script
    matrixManager

    # dependencie for telegram bridge
    python38Packages.alembic
  ];

}
