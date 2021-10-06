{ 
  pkgs ? import <nixpkgs> {}, 
  stdenv ? pkgs.stdenv,
  bundlerEnv ? pkgs.bundlerEnv,
  systemdUser ? import ./systemd-user.nix {}
}:
stdenv.mkDerivation rec {
  pname = "drivesync-${version}";
  name = "drivesync";
  version = "1.4.0";
  homepage = "https://github.com/MStadlmeier/drivesync";
  buildInputs = with pkgs; [ ruby drivesync_env makeWrapper ];
  description = "Command line that synchronizes your Google Drive";
  longDescription = ''
    A command line utility that synchronizes your Google Drive files with a local folder on your machine. 
    Downloads new remote files, uploads new local files to your Drive and deletes or updates files both 
    locally and on Drive if they have changed in one place. Allows blacklisting or whitelisting of files 
    and folders that should not / should be synced.
  '';
  src =  builtins.fetchTarball { 
    url = "https://github.com/MStadlmeier/drivesync/archive/refs/tags/${version}.tar.gz";
  };

  platforms = [ "x86_64-linux" ];

  drivesync_env = bundlerEnv {
    name="drivesync_env";
    ruby = pkgs.ruby;
    gemdir = ./.;

    # it will be used to change the default config file in future releases
    # in future this will be used
  };

  service = systemdUser.service{
    name="drivesync";
    description="Google Drive Sync Service";
    destination="/lib/systemd/user/drivesync.service";
    type="oneshot";
    execStart="${pkgs.ruby}/bin/ruby /home/rodrigo/.nix-profile/lib/drivesync.rb";
  };

  timer = systemdUser.timer{
    name="drivesync";
    description="Verifica se os arquivos do  Google Drive foram modificados";
    destination="/lib/systemd/user/drivesync.timer";
    delayOnBoot = "5min";
    delayAfterActive = "15min";
  };
  
  #OPTIONS
  allow_remote_deletion = "false";
  drivePath = "~/Documentos/Google-Drive/";

  postUnpack = ''
    mkdir -p $out/lib/src/
    mkdir -p $out/lib/systemd/user/
  '';

  installPhase = ''
    update_key(){
      key=$1
      value=$2
      file=$3
      sed -i -r "s|($key:)(\s?.*)|$key: $value|" $file; 
    }

    cp -r $src/* $out/lib
    rm $out/lib/{Gemfile.lock,Gemfile}

    # dont polute our home
    substituteInPlace $out/lib/drivesync.rb \
      --replace "~/.drivesync/config.yml" "~/.config/drivesync/config.yaml"

    substituteInPlace $out/lib/src/config_manager.rb \
      --replace "~/.drivesync/config.yml" "~/.config/drivesync/config.yaml"

    substituteInPlace $out/lib/src/synchronizer.rb \
      --replace "~/.drivesync/" "~/.config/drivesync/"

    substituteInPlace $out/lib/src/drive_manager.rb \
      --replace ".credentials" "/.config/drivesync/"
    

    update_key "allow_remote_deletion" "${allow_remote_deletion}" "$out/lib/src/defaultconfig"

    update_key "drive_path" '"${drivePath}"' "$out/lib/src/defaultconfig"

    echo ${pkgs.ruby}/bin/ruby $out/lib/drivesync.rb

    cp ${timer}/lib/systemd/user/* $out/lib/systemd/user/
    cp ${service}/lib/systemd/user/* $out/lib/systemd/user
  '';
  
  # Ensure that we replace the config path to point ~/.config/drivesync cause I don't like 
  # my homedir with many files
  checkPhase = ''
    cat $out/lib/src/{synchronizer.rb,config_manager.rb,drive_manager.rb} | grep --color "~/.config/drivesync"
    cat $out/lib/drivesync.rb | grep --color "~/.config/drivesync"
    cat $out/lib/src/defaultconfig | grep "allow_remote_deletion: ${allow_remote_deletion}"
    cat $out/lib/src/defaultconfig | grep "drive_path: ${drivePath}"
  '';

  # put greater values than 6 to debug _moveSystemdUserUnits
  # NIX_DEBUG = 7;

  postBuild = ''
    _moveSystemdUserUnits
  '';

  phases = [ "postUnpack" "installPhase" "checkPhase" "postBuild" ];
  
}
