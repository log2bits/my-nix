{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # BOOTLOADER
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.useOSProber = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" ];

  # NVIDIA
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  hardware.graphics.enable = true;
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # NETWORKING
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # LOCALE & TIME
  time.timeZone = "America/Los_Angeles";
  time.hardwareClockInLocalTime = false;
  i18n.defaultLocale = "en_US.UTF-8";

  # DISPLAY MANAGER
  services.desktopManager.plasma6.enable = true;

  # AUDIO
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # SHELL
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # FONTS
  fonts.packages = with pkgs; [
    nerd-fonts.monaspace
    maple-mono.NF
  ];

  # SYSTEM ENV VARS
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NIXOS_OZONE_WL = "1";
  };

  # USER
  users.users.logan = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };

  # SYSTEM PACKAGES (minimal)
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    xorg.xauth
  ];

  security.polkit.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  swapDevices = [{ device = "/swapfile"; size = 8192; }];

  system.stateVersion = "25.11";
}
