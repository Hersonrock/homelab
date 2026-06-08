# Broken Kernel parameters - GRUB settings

Domain: System Management
Last Edited: June 7, 2026 11:38 PM
Objective: Basic-Linux
State: Completed
UUID: 30676008-4ed5-432c-944a-dd0326cb2545

# Set up

```bash
# Inject an invalid root device into kernel cmdline
cp /etc/default/grub /etc/default/grub.bak
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="root=\/dev\/null"/' /etc/default/grub
update-grub
```

`/etc/default/grub` contains the configuration for `grub-mkconfig` or `update-grub` which is used to create the `/boot/grub/grub.cfg` which GRUB reads at boot.$^{1}(p.83)$

On this example, we provided a wrong parameter and this will make the system panic at boot time as it cannot mount the virtual filesytem /dev/null

## Expected Symtom

System boots, kernel loads, but immediately panics trying to mount root filesystem from /dev/null. `VFS: Cannot open root device null`. Never reaches initrd userspace.

When booting up I get a BusyBox prompt, this would mean that GRUB attempted to start and it was partially sucesfull but failed to move forward.

```bash
BusyBox v1.36.1 (Ubuntu 1:1.36.1-6ubuntu3.1) built-in shell (ash)
Enter 'help' for a list of built-in commands.

(initramfs)
```

## Proposed resolution

```bash
# Boot previous kernel from GRUB advanced options
# manually edit:
vi /etc/default/grub
# Fix: GRUB_CMDLINE_LINUX=""
update-grub
reboot
```

# References

[1] [UNIX® and Linux® System Administration Handbook](https://app.notion.com/p/UNIX-and-Linux-System-Administration-Handbook-3799cd372e9780d9b368f56885555abc?pvs=21)