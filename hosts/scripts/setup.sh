#!/usr/bin/env bash

parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary 1MB -8GB
parted /dev/sda -- mkpart primary linux-swap -8GB 100%
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkdir /mnt
mount /dev/disk/by-label/nixos /mnt
swapon /dev/sda2
nixos-generate-config --root /mnt
cp /etc/conf.nix /mnt/etc/nixos/configuration.nix
nix-channel --update
nixos-install --no-root-password
