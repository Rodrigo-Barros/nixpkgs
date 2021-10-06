{pkgs ? import <nixpkgs> {}}:
{
    service = {
      name ? "service name",
      description ? "description",
      execStart ? "",
      execStopPost ? "",
      log ? "syslog",
      target ? "default.target",
      destination ? "/share/systemd/user/${name}.service",
      type ? "oneshot"
    }: 
    pkgs.writeTextFile{
      inherit destination;
      inherit name;
      text = ''
        [Unit]
        Description=${description}

        [Service]
        ExecStart=${execStart}
        ExecStopPost=${execStopPost}
        StandardError=${log}
        StandardOutput=${log}
        SyslogIdentifier=${name}
        Type=${type}

        [Install]
        WantedBy=${target}
      '';
    };

    timer = {
      name ? "timer",
      delayOnBoot ? "",
      delayAfterActive ? "",
      target ? "timers.target",
      destination ? "/share/systemd/user/${name}.timer",
      description ? "Um timer"
    }: 
    pkgs.writeTextFile {
      inherit name destination;
      text=''
        [Unit]
        Description=${description}

        [Timer]
        OnBootSec=${delayOnBoot}
        OnUnitActiveSec=${delayAfterActive}

        [Install]
        WantedBy=${target}
      '';
    };
}
