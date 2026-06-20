let
  isaac = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICu6nS96uOLf4wQ+W6Uncnjh276dffhewG9zxeqQ7YSi";

  # temporary first-boot age key; see below
  athena = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINvhcX1w6rOk6UDk3+uuC4ZbunuBrv3Qaf7kkXSdkA5S root@athena";
in
{
  "wireless.env.age".publicKeys = [ isaac athena ];
  "tailscale-authkey.age".publicKeys = [ isaac athena ];
}
