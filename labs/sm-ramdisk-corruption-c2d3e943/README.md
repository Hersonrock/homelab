# Corrupt initial ramdisk

Completed On: June 8, 2026
Domain: System Management
Last Edited: June 8, 2026 8:54 AM
Objective: Basic-Linux
State: Pending
UUID: c2d3e943-2033-4ab6-8b45-1f1e1e80984d

The `initramfs` solves the problem of neefind a filesystem running in order for the kernel to load the modules it needs to mount the actual root filesystem of the operative system. The `initramfs` is then a collection of kernel drivers modules along with other tools that allows this process. $^{1}(p.251)$

# Setup

```bash
cp /boot/initrd.img-$(uname -r) /boot/initrd.img-$(uname -r).bak
truncate -s 0 /boot/initrd.img-$(uname -r)
```

# Expected Symtom

Kernel loads but panics immediately, error seen is

`KERNEL PANIC! Please reboot your computer. VFS: Unable to mount root fs or unknown-block(0,0)`

# Proposed resolution

To create the RAM filesystem images we can use thje tool `mkinitramfs`  

I booted with another kernel `6.17.0-29` from grub and ran `mkinitramfs -o /boot/initrd.img-6.17.0-35-generic` 

now machine booted into `initramfs` prompt

## Root cause

The command was incomplete

So I was working wih kernel 6.17.0-29 and  I build initramfs for initrd.img-6.17.0-35-generic with modules from -29 because I did not specify the right modules.

This explains why I was dropped on initramfs prompt

Trying again by booting with old kernel again.

## Solution attempted

```bash
mkinitramfs -o /boot/initrd.img-6.17.0-35-generic 6.17.0-35-generic
```

rebooted and it worked!

# Extra

the initramfs image can be decompressed using `uninitramfs` which uses `cpio`

I ran the command `unmkinitramfs -v initrd.img-6.17.0-35-generic ./uncompressed/` , The destination folder contents.

```bash
bin  conf  etc  init  lib  lib64  lib.usr-is-merged  run  sbin  scripts  usr  var

./main/
├── conf/          # initramfs configuration
├── etc/           # minimal config (modprobe, udev, fonts, plymouth)
├── scripts/       # the boot logic scripts
├── usr/           # binaries, libraries, modules
├── var/           # runtime state (dhcp leases, font cache)
└── run/           # tmpfs mountpoint
```

One notable directory is `/etc/` which has this configuration. Including a `passwd` file, some basic name resolution config `nsswitch.conf`  and `dhcpd.conf`

# References

[1] [How Linux Works](https://app.notion.com/p/How-Linux-Works-3799cd372e97805eb514f1514559789f?pvs=21)