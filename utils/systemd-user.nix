# units
{pkgs ? import <nixpkgs> {} }:
{
  service = {
    name ? "service",
    description ? "service description",
    execStartPre ? "",
    execStart ? "",
    execStopPost ? "",
    target ? "default.target",
    type ? "simple",
    log ? "syslog"
  }:{
    inherit name description execStartPre execStart execStopPost target type log;
    unitFile=''
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

      [Install]
      WantedBy=${target}
    '';
  };

  timer = {
    description ? "generic timer",
    delayOnBoot ? "", # 5min
    delayAfterActive ? "", # 5min
    target ? "timers.target"
  }: {
    inherit description delayOnBoot delayAfterActive target;
    unitFile=''
      [Unit]
      Description=${description}

      [Timer]
      OnBootSec=${delayOnBoot}

      [Install]
      WantedBy=${target}
    '';
  };
}
