# Corrupt Kernel Image

Completed On: June 8, 2026
Domain: System Management
Last Edited: June 8, 2026 11:09 AM
Objective: Basic-Linux
State: Pending
UUID: c2e7f896-a78f-4918-be56-c182a0f77712

# Set up

```bash
# Corrupt the current kernel image
cp /boot/vmlinuz-$(uname -r) /boot/vmlinuz-$(uname -r).bak
dd if=/dev/urandom of=/boot/vmlinuz-$(uname -r) bs=512 count=1 conv=notrunc
```

This will fill out the kernel file with random bytes

```bash
<ORIGINAL>
user1@ubu-vm:~/homelab/labs/sm-kernel-corrupt-c2e7f896/ubu-vm.lab$ sudo hexdump -C /boot/vmlinuz-6.17.0-35-generic.bak | head -10
00000000  4d 5a 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |MZ..............|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000030  00 00 00 00 00 00 00 00  cd 23 82 81 40 00 00 00  |.........#..@...|
00000040  50 45 00 00 64 86 04 00  00 00 00 00 00 00 00 00  |PE..d...........|
00000050  01 00 00 00 a0 00 06 02  0b 02 02 14 00 60 f8 00  |.............`..|
00000060  00 d0 06 00 00 00 00 00  9a f0 f7 00 00 50 00 00  |.............P..|
00000070  00 00 00 00 00 00 00 00  00 10 00 00 00 02 00 00  |................|
00000080  00 00 00 00 03 00 00 00  00 00 00 00 00 00 00 00  |................|
00000090  00 80 ff 00 00 10 00 00  96 78 00 01 0a 00 00 01  |.........x......|

<FILLED WITH NOISE>
user1@ubu-vm:~/homelab/labs/sm-kernel-corrupt-c2e7f896/ubu-vm.lab$ sudo hexdump -C /boot/vmlinuz-6.17.0-35-generic | head -10
00000000  60 f2 ae 98 db 17 ed eb  2a 99 4b 97 46 b8 d0 e7  |`.......*.K.F...|
00000010  bc ec d5 29 58 32 00 cc  b9 85 ef 69 ae 5d 2a 90  |...)X2.....i.]*.|
00000020  03 c4 2d ed da 6d cd 8f  13 a8 eb a8 ee 37 f5 a4  |..-..m.......7..|
00000030  41 1a ec 14 b6 65 63 d7  ff 82 64 1b 44 13 b6 35  |A....ec...d.D..5|
00000040  a7 85 a7 b3 cf f0 c6 35  fb 9d f8 6d 51 4e c4 0f  |.......5...mQN..|
00000050  45 9f 88 c6 aa 79 1d 2e  f3 db e4 00 71 f8 1b 8f  |E....y......q...|
00000060  c7 3d c7 63 38 f7 40 bf  e5 00 90 df d5 76 54 d8  |.=.c8.@......vT.|
00000070  12 2d 27 bb 95 fa a0 d8  36 57 c7 09 29 e5 87 4e  |.-'.....6W..)..N|
00000080  c3 f0 af 45 2f 95 5d 12  12 8a 6d 2e 41 07 c8 eb  |...E/.]...m.A...|
00000090  33 74 c0 ad 02 0b a7 87  48 a5 1b 02 e6 c8 e9 01  |3t......H.......|
```

## Expected symptom

GRUB loads but immediately shows: `error: invalid magic number` . error: you need to load a kernel first.

Press any key to continue… 

Then grub loads, but as soon as I select the current kernel the error appears again.

If I load the old kernel it works fine.

## Proposed resolution

The best solution is to just reinstall the kernel(or restore from the backup, but thats trivial)

```bash
apt install --reinstall linux-image-$(uname -r)
```

## Unexpected issues

When playing around with making backups of the kernel a few `vmlinuz*.bak` were created, and it seems GRUB updated the list of available kernels to include them, once the backups were deleted (and somehow ended up in top of the list of GRUB choices) the machine would fail to book with a kernel panic.

I could manually select advanced options and boot with the known existing kernel and ran `update-grub`

that fixed it.

```bash
user1@ubu-vm:~$ sudo update-grub
[sudo] password for user1:
Sourcing file `/etc/default/grub'
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-6.17.0-35-generic
Found initrd image: /boot/initrd.img-6.17.0-35-generic
Found linux image: /boot/vmlinuz-6.17.0-29-generic
Found initrd image: /boot/initrd.img-6.17.0-29-generic
Found memtest86+ 64bit EFI image: /boot/memtest86+x64.efi
Warning: os-prober will not be executed to detect other bootable partitions.
Systems on them will not be added to the GRUB boot configuration.
Check GRUB_DISABLE_OS_PROBER documentation entry.
Adding boot menu entry for UEFI Firmware Settings ...
done
user1@ubu-vm:~$ ls /boot/vmlinuz*
/boot/vmlinuz  /boot/vmlinuz-6.17.0-29-generic  /boot/vmlinuz-6.17.0-35-generic  /boot/vmlinuz.old
user1@ubu-vm:~$ grep -i "bak" /boot/grub/grub.cfg
grep: /boot/grub/grub.cfg: Permission denied
user1@ubu-vm:~$ sudo grep -i "bak" /boot/grub/grub.cfg
```