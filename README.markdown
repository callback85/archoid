Archoid.sh: install archlinux into an android chroot
====================================================


Why
---

Just for fun.


How is this different from other similar guides/tools out there
---------------------------------------------------------------

### Simplicity

Archoid.sh installs the system into a separte ext2 partition,
rather than creating a loop device from file during each boot.
No loop device support is required from your android kernel.

### Freedom of software choice

According to the arch way, archoid.sh installs the core archlinux
without unnecessary additions, modifications, or complications.
You have got the choice of what and how to install.


Prerequisites
-------------

- Your device has got a large (4gb+) sdcard and a usb storage mode.
- Your device has been rooted + busyboxed properly.
- Your device has usb debug enabled.

- You have installed, configured and learned adb + gparted.
- You have read, analyzed and understood archoid.sh.
- You have a backup of all your precious data.

- You are not going to run this from root in a chroot on a real pc.


Prepare your device
-------------------

1. Download http://archlinuxarm.org/os/ArchLinuxARM-odroid-xu-latest.tar.gz
2. Switch android into usb storage mode
3. Repartition sd: 1 vfat (storage), 2 ext2 (linux)
4. Mount both sd1 (storage) and sd2 (linux) somewhere on your pc
5. Copy archoid.sh into sd1 (storage) root
6. Unpack tar.gz into sd2 (linux) root
7. Run `sync` from terminal
8. Unmount sd1 and sd2
9. Switch off usb storage

Download another image if you have to, this is just the one of my choice.


First launch
------------

$ adb shell su -c 'sh /sdcard/archoid.sh' && adb reboot;

Smt fails? Enter a correct $device in archoid.sh and try again.


Next launches
-------------

$ adb shell su -c 'sh /sdcard/archoid.sh';

1. Write down the listed addresses of your device
2. Root-ssh the most accessible address
3. ...
4. PROFIT


Outcome
-------

There is a working archlinux installation on your android.
You are all under shell, without the powers of systemd.
Still, you have a fully functional gnu/linux system.
Play around with nginx, node.js, mysql, whatever.
No warranties on stability or security though.


(c) callback85, 2014-01-25, Kyiv, Ukraine
-----------------------------------------
