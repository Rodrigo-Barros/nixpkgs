{
  systemdUser ? import ./systemd-user.nix {},
  pkgs ? import <nixpkgs> {}
}:
{
  service = systemdUser.service;
  timer = systemdUser.timer;
}
