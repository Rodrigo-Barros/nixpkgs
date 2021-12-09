# units
{ 
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib
}: {
  service = {
    name , # nome do serviço
    description ? "service description",
    execStartPre ? "",
    execStart ? "",
    execStopPost ? "",
    target ? "default.target",
    type ? "simple",
    log ? "syslog",
    timeoutSec ? "90"
  }:
    pkgs.writeTextFile {
        name="${name}";
        text=''
            [Unit]
            Description=${description}
            
            [Service]
            ExecStartPre=${execStartPre}
            ExecStart=${execStart}
            ExecStopPost=${execStopPost}
            Type=${type}
            SyslogIdentifier=${name}
            StandardOutput=${log}
            StandardError=${log}
            TimeoutSec=${timeoutSec}
            
            [Install]
            WantedBy=${target}
        '';
        destination ="/share/systemd/user/${name}.service";
	};

  timer = {
  	name,
    description ? "generic timer",
    delayOnBoot ? "", # 5min
	delayAfterActive ? "", # 15min repeat after first execution
    target ? "timers.target",
	onCalendar ? "",
    persistent? "false",
  }: 
  pkgs.writeTextFile {
    name="";
    text=''
      [Unit]
      Description=${description}
      
      [Timer]
    ''
    + (if delayOnBoot != "" then  
    ''
      OnBootSec=${delayOnBoot}
    '' 
    else "")

    + (if onCalendar != "" then 
    ''
      OnCalendar=${onCalendar}
    ''
    else "")

    + (if delayAfterActive != "" then ''
      OnUnitActiveSec=${delayAfterActive}
    '' 
    else "")

    + (if persistent == "true" then ''
      Persistent=${persistent}
    '' 
    else "")
    +
    ''
      
      [Install]
      WantedBy=${target}
    '';
    destination="/share/systemd/user/${name}.timer";
  };
}
