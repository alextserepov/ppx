{ pkgs, lib, config, modulesPath, inputs, ... }:
{
  imports = [
    "${toString modulesPath}/installer/cd-dvd/iso-image.nix"
  ];

  # EFI booting
  isoImage.makeEfiBootable = true;

  # USB booting
  isoImage.makeUsbBootable = true;
  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  
  users.users.alex = {
    isNormalUser = true;
    home = "/home/alex";
    description = "Alex Foobar";
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUz8zH1OpPhPrMGPv0XdQHcmZ+rdOcUHZf5HBm7OjhV alextserepov@gmail.com" ];
  };

  environment.systemPackages = with pkgs; [
    parted
  ];

  environment.etc."setupsh".source = scripts/setup.sh;
  environment.etc."setupsh".mode="0755";
  environment.etc."conf.nix".source = scripts/conf.nix;

  systemd.services.myScriptService = {
    description = "Installation Service";
    after = [ "network.target" ]; # Specify dependencies, if any
    wantedBy = [ "multi-user.target" ]; # Define the target that should include this service
    serviceConfig = {
      ExecStart = "${config.environment.etc.setupsh.source}";
      Type = "oneshot";
      RemainAfterExit = false;
    };
  };

}
