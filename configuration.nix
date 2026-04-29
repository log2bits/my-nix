{ config, pkgs, inputs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # BOOTLOADER
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiSupport = true;
    efiInstallAsRemovable = true;
    useOSProber = true;
    theme = pkgs.stdenv.mkDerivation {
      pname = "crossgrub";
      version = "1.0.0";
      src = pkgs.fetchFromGitHub {
        owner = "krypciak";
        repo = "crossgrub";
        rev = "2637aef5d1756881de53ec4df2f95aedc87b1b60";
        hash = "sha256-TDgi9e2/aHngdzFCkx0ykZedP3v4IFKiYJGTcWUo+rk=";
      };
      installPhase = ''
        cp -r . $out
        cp $out/assets/* $out/
      '';
    };
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "nvidia-drm.modeset=1" "nvidia.NVreg_PreserveVideoMemoryAllocations=1" "pcie_aspm=off" ];

  # NVIDIA
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  hardware.graphics.enable = true;
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # NETWORKING
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  hardware.mediatek-mt7927 = {
    enable = true;
    enableWifi = true;
    enableBluetooth = true;
    disableAspm = true;
  };

  # LOCALE & TIME
  time.timeZone = "America/Los_Angeles";
  time.hardwareClockInLocalTime = false;
  i18n.defaultLocale = "en_US.UTF-8";

  # DISPLAY MANAGER
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

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

  # SYSTEM PACKAGES
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    xauth
    # Better Blur DX: active fork of kwin-effects-forceblur (which was archived Nov 2025)
    # Forces blur on any window (Electron, GTK, Firefox) regardless of whether
    # the app requests it. Wayland only — drop the .x11 variant if you don't need X11.
    inputs.better-blur.packages.${pkgs.system}.default
    # Catppuccin color scheme for Konsole
    catppuccin-konsole
  ];
  programs.partition-manager.enable = true;
  security.polkit.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  swapDevices = [{ device = "/swapfile"; size = 8192; }];

  # CATPPUCCIN (system-level)
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
    grub.enable = false; # using custom crossgrub theme above
  };

  home-manager.backupCommand = "rm";

  system.stateVersion = "25.11";
}
