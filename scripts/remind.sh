#!/bin/bash
remind_file="$HOME/.config/nixpkgs/packages/remind/agenda"
command="notify-send 'Lembrete:' '%s' -t 0 --hint=int:transient:0 && "
command+="paplay /usr/share/sounds/freedesktop/stereo/complete.oga"
remind -z1 -k"$command" $remind_file
