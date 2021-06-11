{
  systemdUser ? import ./systemd-user.nix {}
}:
{
  inherit systemdUser;
}
