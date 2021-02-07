+++
title = "Installing NixOS with encryption on a Lenovo laptop"
published = "2020-11-7"
tags = ["nixos"]
rss = "Specifically, installing NixOS on the Lenovo Yoga 7."
+++

In this post, I walk through the steps to install NixOS on a Lenovo Yoga 7 with an encrypted root disk.
This tutorial is mainly based on the tutorial by [Martijn Vermaat](https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134) and comments by `@ahstro` and `dbwest`.

\toc

## USB preparation

[Download](https://nixos.org/download.html) NixOS and figure out the location of the USB drive with `lsblk`.
Use the location of the drive and not the partition, so `/dev/sdb` instead of `/dev/sdb1`.
Then, prepare the USB with
```text
dd if=nixos.iso of=/dev/<name of USB drive>
```

## Laptop preparation

For Lenovo laptops, Wi-Fi might not work out of the box.
To enable Wi-Fi, edit the boot options by pressing `e` in the boot menu and add `modprobe.blacklist=ideapad_laptop` to the command.

The new device needs some preparation before starting the NixOS installation.
Firstly, disable secure boot from BIOS settings (and, optionally, other baloney).
If you cannot move inside the BIOS settings since it is not responding to key presses, then go into the BIOS settings via Windows.
That is, search for BIOS in start and then reboot into some blue basic interface.
From there, some of the options allow you get into the BIOS settings.

Next, check whether you have an internet connection on the new device because installing NixOS without it will be difficult.
To increase the font size of the terminal, use `setfont ter-v32n`.
Useful commands for configuring Wi-Fi are 
```
uname -a # Check that kernel is above 5.3 for the Intel Wi-Fi driver to be available.
ip link
nmcli # Network Manager CLI
sudo wpa_supplicant -B -i wlp1s0 -c /etc/wpa_supplicant.conf
```
where the `wpa_supplicant.conf` contains
```text
network={
  ssid="<Wi-Fi SSID>"
  psk="<Wi-Fi password>"
}
```
Also see the NixOS manual for more information on setting up Wi-Fi.
For tethering with an iPhone, see [Appendix I](#appendix_i).

## Partitioning

After you have ensured that the system has an internet connection, NixOS can be installed.

```
lsblk
sudo gdisk /dev/nvme0n1
```

- o -> y (create new empty partition table)
- n ->  -> 500M -> ef00 (add partition, 500M, type ef00 EFI)
- n ->  ->  ->  ->  ->  (add partition, remaining space, type 8300 Linux LVM)
- w -> y (write partition  table and exit)

```text
sudo cryptsetup luksFormat /dev/nvme0n1p2
sudo cryptsetup luksOpen /dev/nvme0n1p2 enc-pv

sudo pvcreate /dev/mapper/enc-pv
sudo vgcreate vg /dev/mapper/enc-pv
sudo lvcreate -L 8G -n swap vg
sudo lvcreate -l '100%FREE' -n root vg

sudo mkfs.fat /dev/nvme0n1p1
sudo mkfs.ext4 -L root /dev/vg/root
sudo mkswap -L swap /dev/vg/swap

sudo mount /dev/vg/root /mnt
sudo mkdir /mnt/boot
sudo mount /dev/nvme0n1p1 /mnt/boot
sudo swapon /dev/vg/swap

sudo nixos-generate-config --root /mnt

cd /mnt/etc/nixos/
```

Now find the UUID for `/dev/nvme1n1p2` with
```
sudo blkid /dev/nvme0n1p2
```

And use `sudo vi configuration.nix` to add the following lines to the configuration
```text
networking.wireless.enable = true;

environment.systemPackages = with pkgs; [
  usbmuxd
];

boot.initrd.luks.devices = {
  root = {
    device = "/dev/disk/by-uuid/06e7d974-9549-4be1-8ef2-f013efad727e";
    preLVM = true;
    allowDiscards = true;
  };
};

# Without this, the graphics won't work (at the time of writing) on this relatively new laptop.
boot.kernelPackages = pkgs.linuxPackages_latest;
```

## Installing

Finally, install NixOS with
```
sudo nixos-install
sudo reboot now
```

## Troubleshooting

To fix issues with the installation, reboot from the installation media and remount all partitions.

```text
sudo cryptsetup luksOpen /dev/nvme0n1p2 enc-pv
sudo lvchange -a y /dev/vg/swap
sudo lvchange -a y /dev/vg/root
sudo mount /dev/vg/root /mnt
sudo mount /dev/nvme0n1p1 /mnt/boot
sudo swapon /dev/vg/swap
sudo wpa_supplicant -B -i wlp1s0 -c /mnt/etc/wpa_supplicant.conf
```

## Appendix I 
For me, Wi-Fi wasn't working until I read about the `modprobe.blacklist` listed above, nor did I have an ethernet port.
So, for tethering an iPhone add `pkgs.usbmuxd` to `nixos/modules/profiles/base.nix` in a cloned version of `nixpkgs`.
Note that its a good idea to clone from a release tag such as 20.03.
Then,
```text
nix-build -A config.system.build.isoImage -I nixos-config=modules/installer/cd-dvd/installation-cd-minimal.nix
dd if=result/iso/nixos-<...>.iso of=/dev/sda
```

From there, iPhone tethering worked after starting the `usbmuxd` tool as a background job.
```
sudo usbmuxd -s > usbmuxd.log 2>&1 &
```
