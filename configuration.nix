# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # disks
  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/e46edb03-c688-4907-a2fc-e869b3b181c9";
    fsType = "ext4";
  };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";
  boot.loader.grub.useOSProber = true;

  # Memory Test
  # boot.loader.grub.memtest86.enable = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  users.users."admin" = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" "media" ];
    packages = with pkgs; [];
  };

  users.users.admin.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3+g4hdcc44+1rez/GaigfQWXZrXqaDkuwGy6SC8r0ccmrEzDaIT+qI4vfSLoMbGkNczYyYjYrv3pM7PH4TahpWzCCxCZO4omWVDIONY5uJVyORKUfDk/IjSeJDwpKcaqrHasVmrnmxGnJcLpQsFscaqaX5TmBIILjKcr30YOOwycw2VaM+dIelW2UONKfvSQYz9/k9WD8EOQe62FjIJpZUNEvT0S8rFYhLZNx3dXtzyPvZgMe4eKNdMjB4WR6/yIa9Ys887/vW/35UI5FvbTPdMHJZbwIhA4nctMMgwkla4T2EIAQxoSNMbbT6Gxl+0i+E80y7s1GNQl3hf/iROKHpEBxbm4AdD4PYFBlB9CW0Hdmk7Yw2CwDNWfwqv3S3KhaXIFN6ichbGXq1yqVnudzUNBnMitSdC2OP+1jM4VxhwAyt0FivTFDP+KuJHiLv5PVio1am7jua8949Y8pXTK7di2aT4TLaURCEvuO7wyYXA5u06RgPV/IfDh5895z4Z5XNYsuAidcE6EC2iCeVJoHBW4ajB+lVCi762hkKY+R9IJegQmRZ/CPraeFBl2mL/ZWI9VjDWJDn1Nw+QQW9KJPLv17flgD3MThbjmbOV/qhSBLJasZgHZ3YJi9Vr+ID1lVSdQAy5GLNe03CGSux6RqESwblFDw7NGttFQs7oW11w== marco@marco007.dev"
  ];

  users.groups.media = { };
  users.users.jellyfin.extraGroups = [ "media" "video" "render" ]; 

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     git neovim tmux lazygit
     btop ncdu ripgrep fd
     smartmontools pciutils usbutils fastfetch
     libva-utils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.jellyfin.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = true;
  };

  services.tailscale.enable = true;

  services.radarr = {
    enable = true;
    user = "radarr";
    group = "media";
  };

  services.prowlarr.enable = true;

  services.qbittorrent = {
    enable = true;
    user = "qbittorrent";
    group = "media";
    webuiPort = 8080;
  };

  # Open ports in the firewall.
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

  # temp files
  systemd.tmpfiles.rules = [
    "d /data                0755 root  root  -"
    "d /data/media          2775 admin media -"
    "d /data/media/movies   2775 admin media -"
    "d /data/media/shows    2775 admin media -"
    "d /data/torrents            2775 admin media -"
    "d /data/torrents/incomplete 2775 admin media -"
    "d /data/torrents/movies     2775 admin media -"
  ];
 
  # iGPU 
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-vaapi-driver ];
  };

  # other crap
  systemd.services.radarr.serviceConfig.UMask = lib.mkForce "0002";
  systemd.services.qbittorrent.serviceConfig.UMask = "0002";
  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "i965";

  #vpn things
  vpnNamespaces.wg = {
    enable = true;
    wireguardConfigFile = "/etc/wireguard/mullvad.conf";
    accessibleFrom = [ "100.64.0.0/10" "192.168.178.0/24" "127.0.0.1" ];
    portMappings = [ 
      { from = 8080; to = 8080; protocol = "tcp"; }
      { from = 9696; to = 9696; protocol = "tcp"; }
    ];
  };

  systemd.services.qbittorrent.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };
  systemd.services.prowlarr.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };
}
